//
//  FileExplorer.swift
//  SideStore
//
//  Created by naturecodevoid on 2/16/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import ZIPFoundation
import UniformTypeIdentifiers
import minimuxer

extension Binding<URL?>: Equatable {
    public static func == (lhs: Binding<URL?>, rhs: Binding<URL?>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

private protocol FileExplorerBackend {
    func delete(_ path: URL) throws
    func zip(_ path: URL) throws
    func insert(file: URL, to: URL) throws
    func iterate(_ directory: URL) -> DirectoryEntry
    func getQuickLookURL(_ path: URL) throws -> URL
}

private class NormalFileExplorerBackend: FileExplorerBackend {
    func delete(_ path: URL) throws {
        try FileManager.default.removeItem(at: path)
    }
    
    func zip(_ path: URL) throws {
        let dest = FileManager.default.documentsDirectory.appendingPathComponent(path.pathComponents.last! + ".zip")
        do {
            try FileManager.default.removeItem(at: dest)
        } catch {}
        
        try FileManager.default.zipItem(at: path, to: dest)
    }
    
    func insert(file: URL, to: URL) throws {
        try FileManager.default.copyItem(at: file, to: to.appendingPathComponent(file.pathComponents.last!), shouldReplace: true)
    }
    
    private func _iterate(directory: URL, parent: URL) -> DirectoryEntry {
        var directoryEntry = DirectoryEntry(path: directory, parent: parent, isFile: false)
        if let contents = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: []) {
            for entry in contents {
                if entry.hasDirectoryPath {
                    directoryEntry.children!.append(_iterate(directory: entry, parent: directory))
                } else {
                    directoryEntry.children!.append(DirectoryEntry(path: entry, parent: directory, isFile: true, size: {
                        guard let attributes = try? FileManager.default.attributesOfItem(atPath: entry.description.replacingOccurrences(of: "file://", with: "")) else { return nil }
                        return attributes[FileAttributeKey.size] as? Double
                    }()))
                }
            }
        }
        return directoryEntry
    }
    
    func iterate(_ directory: URL) -> DirectoryEntry {
        return _iterate(directory: directory, parent: directory)
    }
    
    func getQuickLookURL(_ path: URL) throws -> URL {
        path
    }
}

private class AfcFileExplorerBackend: FileExplorerBackend {
    func delete(_ path: URL) throws {
        try AfcFileManager.remove(path.description.replacingOccurrences(of: "file://", with: "").removingPercentEncoding!)
    }
    
    func zip(_ path: URL) throws {
        throw NSError(domain: "AFC currently doesn't support zipping a directory/file. however, it is possible (we should be able to copy the files outside of AFC and then zip the copied directory/file), it just hasn't been implemented", code: -1)
    }
    
    func insert(file: URL, to: URL) throws {
        let data = try Data(contentsOf: file)
        let rustByteSlice = data.toRustByteSlice()
        let to = to.appendingPathComponent(file.lastPathComponent).description.replacingOccurrences(of: "file://", with: "").removingPercentEncoding!
        print("writing to \(to)")
        try AfcFileManager.writeFile(to, rustByteSlice.forRust())
    }
    
    private func _addChildren(_ rustEntry: RustDirectoryEntryRef) -> DirectoryEntry {
        var entry = DirectoryEntry(
            path: URL(string: rustEntry.path().toString())!,
            parent: URL(string: rustEntry.parent().toString())!,
            isFile: rustEntry.isFile(),
            size: rustEntry.size() != nil ? Double(rustEntry.size()!) : nil
        )
        for child in rustEntry.children() {
            entry.children!.append(_addChildren(child))
        }
        return entry
    }
    
    func iterate(_ directory: URL) -> DirectoryEntry {
        var directoryEntry = DirectoryEntry(path: directory, parent: directory, isFile: false)
        for child in AfcFileManager.contents() {
            directoryEntry.children!.append(_addChildren(child))
        }
        return directoryEntry
    }
    
    func getQuickLookURL(_ path: URL) throws -> URL {
        throw NSError(domain: "AFC currently doesn't support viewing a file. however, it is possible (we should be able to copy the file outside of AFC and then view the copied file), it just hasn't been implemented", code: -1)
    }
}

private struct DirectoryEntry: Identifiable {
    var id = UUID()
    
    var path: URL
    var parent: URL
    
    var isFile: Bool
    var size: Double?
    var children: [DirectoryEntry]? = []
    
    var asString: String {
        let str = path.description.replacingOccurrences(of: parent.description, with: "").removingPercentEncoding!
        if str.count <= 0 {
            return "/"
        }
        return str
    }
}

private enum FileExplorerAction {
    case delete
    case zip
    case insert
    case quickLook
}

private struct File: View {
    @ObservedObject private var iO = Inject.observer
    
    var item: DirectoryEntry
    var backend: FileExplorerBackend
    @Binding var explorerHidden: Bool
    
    @State var quickLookURL: URL?
    @State var fileExplorerAction: FileExplorerAction?
    @State var hidden = false
    @State var isShowingFilePicker = false
    @State var selectedFile: URL?
    
    var body: some View {
        AsyncFallibleButton(action: {
            switch (fileExplorerAction) {
            case .delete:
                print("deleting \(item.path.description)")
                try backend.delete(item.path)
                
            case .zip:
                print("zipping \(item.path.description)")
                try backend.zip(item.path)
                
            case .insert:
                print("inserting \(selectedFile!.description) to \(item.path.description)")

                try backend.insert(file: selectedFile!, to: item.path)
                explorerHidden = true
                explorerHidden = false
                
            case .quickLook:
                print("viewing \(item.path.description)")
                quickLookURL = try backend.getQuickLookURL(item.path)
                
            default:
                print("unknown action for \(item.path.description): \(String(describing: fileExplorerAction))")
            }
        }, label: { execute in
            HStack {
                Text(item.asString)
                if item.isFile {
                    Text(getFileSize(item.size)).foregroundColor(.secondary)
                }
                Spacer()
                Menu {
                    if item.isFile {
                        SwiftUI.Button(action: {
                            fileExplorerAction = .quickLook
                            execute()
                        }) {
                            Label("View/Share", systemSymbol: .eye)
                        }
                    } else {
                        SwiftUI.Button(action: {
                            fileExplorerAction = .zip
                            execute()
                        }) {
                            Label("Save to ZIP file", systemSymbol: .squareAndArrowDown)
                        }
                        
                        SwiftUI.Button {
                            isShowingFilePicker = true
                        } label: {
                            Label("Insert file", systemSymbol: .plus)
                        }
                    }
                    
                    if item.asString != "/" {
                        SwiftUI.Button(action: {
                            fileExplorerAction = .delete
                            execute()
                        }) {
                            Label("Delete", systemSymbol: .trash)
                        }
                    }
                } label: {
                    Image(systemSymbol: .ellipsis)
                        .frame(width: 20, height: 20) // Make it easier to tap
                }
            }
            .onChange(of: $selectedFile) { file in
                guard file.wrappedValue != nil else { return }
                
                fileExplorerAction = .insert
                execute()
            }
        }, afterFinish: { success in
            switch (fileExplorerAction) {
            case .delete:
                if success { hidden = true }
                
            case .zip:
                UIApplication.shared.open(URL(string: "shareddocuments://" + FileManager.default.documentsDirectory.description.replacingOccurrences(of: "file://", with: ""))!, options: [:], completionHandler: nil)
                
            default: break
            }
        }, wrapInButton: false)
        .quickLookPreview($quickLookURL)
        .sheet(isPresented: $isShowingFilePicker) {
            DocumentPicker(selectedUrl: $selectedFile, supportedTypes: allUTITypes().map({ $0.identifier }))
                .ignoresSafeArea()
        }
        .isHidden($hidden)
        .enableInjection()
    }
    
    func getFileSize(_ bytes: Double?) -> String {
        guard var bytes = bytes else { return "Unknown file size" }
        
        // https://stackoverflow.com/a/14919494 (ported to swift)
        let thresh = 1024.0;

        if (bytes < thresh) {
            return String(describing: bytes) + " B";
        }

        let units = ["kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
        var u = -1;

        while (bytes >= thresh && u < units.count - 1) {
            bytes /= thresh;
            u += 1;
        }

        return String(format: "%.2f", bytes) + " " + units[u];
    }
}

struct FileExplorer: View {
    @ObservedObject private var iO = Inject.observer
    
    private var url: URL?
    private var backend: FileExplorerBackend
    
    private init(_ url: URL?, _ backend: FileExplorerBackend) {
        self.url = url
        self.backend = backend
    }
    
    static func normal(url: URL?) -> FileExplorer {
        FileExplorer(url, NormalFileExplorerBackend())
    }
    
    static func afc() -> FileExplorer {
        FileExplorer(URL(string: "/")!, AfcFileExplorerBackend())
    }
    
    @State var hidden = false
    
    var body: some View {
        List([backend.iterate(url!)], children: \.children) { item in
            File(item: item, backend: backend, explorerHidden: $hidden)
        }
        .toolbar {
            ToolbarItem {
                SwiftUI.Button {
                    hidden = true
                    hidden = false
                } label: {
                    Image(systemSymbol: .arrowClockwise)
                }
            }
        }
        .isHidden($hidden)
        .enableInjection()
    }
}

struct FileExplorer_Previews: PreviewProvider {
    static var previews: some View {
        FileExplorer.normal(url: FileManager.default.altstoreSharedDirectory)
    }
}

// https://stackoverflow.com/a/72165424
func allUTITypes() -> [UTType] {
    let types: [UTType] =
        [.item,
         .content,
         .compositeContent,
         .diskImage,
         .data,
         .directory,
         .resolvable,
         .symbolicLink,
         .executable,
         .mountPoint,
         .aliasFile,
         .urlBookmarkData,
         .url,
         .fileURL,
         .text,
         .plainText,
         .utf8PlainText,
         .utf16ExternalPlainText,
         .utf16PlainText,
         .delimitedText,
         .commaSeparatedText,
         .tabSeparatedText,
         .utf8TabSeparatedText,
         .rtf,
         .html,
         .xml,
         .yaml,
         .sourceCode,
         .assemblyLanguageSource,
         .cSource,
         .objectiveCSource,
         .swiftSource,
         .cPlusPlusSource,
         .objectiveCPlusPlusSource,
         .cHeader,
         .cPlusPlusHeader]

    let types_1: [UTType] =
        [.script,
         .appleScript,
         .osaScript,
         .osaScriptBundle,
         .javaScript,
         .shellScript,
         .perlScript,
         .pythonScript,
         .rubyScript,
         .phpScript,
         .json,
         .propertyList,
         .xmlPropertyList,
         .binaryPropertyList,
         .pdf,
         .rtfd,
         .flatRTFD,
         .webArchive,
         .image,
         .jpeg,
         .tiff,
         .gif,
         .png,
         .icns,
         .bmp,
         .ico,
         .rawImage,
         .svg,
         .livePhoto,
         .heif,
         .heic,
         .webP,
         .threeDContent,
         .usd,
         .usdz,
         .realityFile,
         .sceneKitScene,
         .arReferenceObject,
         .audiovisualContent]

    let types_2: [UTType] =
        [.movie,
         .video,
         .audio,
         .quickTimeMovie,
         UTType("com.apple.quicktime-image"),
         .mpeg,
         .mpeg2Video,
         .mpeg2TransportStream,
         .mp3,
         .mpeg4Movie,
         .mpeg4Audio,
         .appleProtectedMPEG4Audio,
         .appleProtectedMPEG4Video,
         .avi,
         .aiff,
         .wav,
         .midi,
         .playlist,
         .m3uPlaylist,
         .folder,
         .volume,
         .package,
         .bundle,
         .pluginBundle,
         .spotlightImporter,
         .quickLookGenerator,
         .xpcService,
         .framework,
         .application,
         .applicationBundle,
         .applicationExtension,
         .unixExecutable,
         .exe,
         .systemPreferencesPane,
         .archive,
         .gzip,
         .bz2,
         .zip,
         .appleArchive,
         .spreadsheet,
         .presentation,
         .database,
         .message,
         .contact,
         .vCard,
         .toDoItem,
         .calendarEvent,
         .emailMessage,
         .internetLocation,
         .internetShortcut,
         .font,
         .bookmark,
         .pkcs12,
         .x509Certificate,
         .epub,
         .log]
            .compactMap({ $0 })

    return types + types_1 + types_2
}
