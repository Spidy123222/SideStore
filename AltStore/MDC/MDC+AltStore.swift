// Extension of MDC+AltStoreCore for the functionality AltStore uses
// The only reason we can't have it all in AltStore is because AltStoreCore requires one variable of MDC to determine the free app limit

import Foundation
import AltStoreCore

extension MDC {
    #if MDC
    enum PatchError: LocalizedError {
        case NoFDA(error: String)
        case FailedPatchd
        
        var failureReason: String? {
            switch (self) {
            case .NoFDA(let error): return L10n.Remove3AppLimitView.Errors.noFDA(error)
            case .FailedPatchd: return L10n.Remove3AppLimitView.Errors.failedPatchd
            }
        }
    }
    
    static func patch3AppLimit() async throws {
        #if !targetEnvironment(simulator)
        let res: PatchError? = await withCheckedContinuation { continuation in
            grant_full_disk_access { error in
                if let error = error {
                    continuation.resume(returning: PatchError.NoFDA(error: error.message()))
                } else if !patch_installd() {
                    continuation.resume(returning: PatchError.FailedPatchd)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
        if let error = res {
            throw error
        }
        #else
        print("The patch would be running right now if you weren't using a simulator. It will stop \"running\" in 3 seconds.")
        try await Task.sleep(nanoseconds: UInt64(3 * Double(NSEC_PER_SEC)))
//        throw MDC.PatchError.NoFDA(error: "This is a test error")
        #endif
        
        UserDefaults.shared.lastInstalldPatchBootTime = bootTime()
        UserDefaults.shared.hasPatchedInstalldEver = true
    }
    
    static func alertIfNotPatched() {
        guard UserDefaults.shared.hasPatchedInstalldEver && !installdHasBeenPatched && isSupported else { return }
        
        UIApplication.alert(
            title: L10n.Remove3AppLimitView.title,
            message: L10n.Remove3AppLimitView.NotAppliedAlert.message,
            leftButton: (text: L10n.Remove3AppLimitView.NotAppliedAlert.apply, action: { _ in
                Task {
                    do {
                        try await MDC.patch3AppLimit()
                        
                        await UIApplication.alert(
                            title: L10n.Remove3AppLimitView.success
                        )
                    } catch {
                        await UIApplication.alert(
                            title: L10n.AsyncFallibleButton.error,
                            message: error.message()
                        )
                    }
                }
            }),
            rightButton: (text: L10n.Remove3AppLimitView.NotAppliedAlert.continueWithout, action: nil)
        )
    }
    #endif
    
    private static let ios15 = OperatingSystemVersion(majorVersion: 15, minorVersion: 0, patchVersion: 0) // supported
    private static let ios15_7_2 = OperatingSystemVersion(majorVersion: 15, minorVersion: 7, patchVersion: 2) // fixed
    
    private static let ios16 = OperatingSystemVersion(majorVersion: 16, minorVersion: 0, patchVersion: 0) // supported
    private static let ios16_2 = OperatingSystemVersion(majorVersion: 16, minorVersion: 2, patchVersion: 0) // fixed
    
    static var isSupported: Bool {
        #if targetEnvironment(simulator)
        true
        #else
        (ProcessInfo.processInfo.isOperatingSystemAtLeast(ios15) && !ProcessInfo.processInfo.isOperatingSystemAtLeast(ios15_7_2)) ||
        (ProcessInfo.processInfo.isOperatingSystemAtLeast(ios16) && !ProcessInfo.processInfo.isOperatingSystemAtLeast(ios16_2))
        #endif
    }
}

#if MDC
// enum WhitelistPatchResult {
//     case success, failure
// }
//
// let blankplist = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VOIiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4wLmR0ZCI+CjxwbGlzdCB2ZXJzaW9uPSIxLjAiPgo8ZGljdC8+CjwvcGxpc3Q+Cg=="
//
// func patchWhiteList() {
//    overwriteFileData(originPath: "/private/var/db/MobileIdentityData/AuthListBannedUpps.plist", replacementData: try! Data(base64Encoded: blankplist)!)
//    overwriteFileData(originPath: "/private/var/db/MobileIdentityData/AuthListBannedCdHashes.plist", replacementData: try! Data(base64Encoded: blankplist)!)
//    overwriteFileData(originPath: "/private/var/db/MobileIdentityData/Rejections.plist", replacementData: try! Data(base64Encoded: blankplist)!)
// }
//
// func overwriteFileData(originPath: String, replacementData: Data) -> Bool {
//    #if false
//        let documentDirectory = FileManager.default.urls(
//            for: .documentDirectory,
//            in: .userDomainMask
//        )[0].path
//
//        let pathToRealTarget = originPath
//        let originPath = documentDirectory + originPath
//        let origData = try! Data(contentsOf: URL(fileURLWithPath: pathToRealTarget))
//        try! origData.write(to: URL(fileURLWithPath: originPath))
//    #endif
//
//    // open and map original font
//    let fd = open(originPath, O_RDONLY | O_CLOEXEC)
//    if fd == -1 {
//        print("Could not open target file")
//        return false
//    }
//    defer { close(fd) }
//    // check size of font
//    let originalFileSize = lseek(fd, 0, SEEK_END)
//    guard originalFileSize >= replacementData.count else {
//        print("Original file: \(originalFileSize)")
//        print("Replacement file: \(replacementData.count)")
//        print("File too big!")
//        return false
//    }
//    lseek(fd, 0, SEEK_SET)
//
//    // Map the font we want to overwrite so we can mlock it
//    let fileMap = mmap(nil, replacementData.count, PROT_READ, MAP_SHARED, fd, 0)
//    if fileMap == MAP_FAILED {
//        print("Failed to map")
//        return false
//    }
//    // mlock so the file gets cached in memory
//    guard mlock(fileMap, replacementData.count) == 0 else {
//        print("Failed to mlock")
//        return true
//    }
//
//    // for every 16k chunk, rewrite
//    print(Date())
//    for chunkOff in stride(from: 0, to: replacementData.count, by: 0x4000) {
//        print(String(format: "%lx", chunkOff))
//        let dataChunk = replacementData[chunkOff..<min(replacementData.count, chunkOff + 0x4000)]
//        var overwroteOne = false
//        for _ in 0..<2 {
//            let overwriteSucceeded = dataChunk.withUnsafeBytes { dataChunkBytes in
//                unalign_csr(
//                    fd, Int64(chunkOff), dataChunkBytes.baseAddress, dataChunkBytes.count
//                )
//            }
//            if overwriteSucceeded {
//                overwroteOne = true
//                print("Successfully overwrote!")
//                break
//            }
//            print("try again?!")
//        }
//        guard overwroteOne else {
//            print("Failed to overwrite")
//            return false
//        }
//    }
//    print(Date())
//    print("Successfully overwrote!")
//    return true
// }
//
// func readFile(path: String) -> String? {
//    return (try? String?(String(contentsOfFile: path)) ?? "ERROR: Could not read from file! Are you running in the simulator or not unsandboxed?")
// }
#endif
