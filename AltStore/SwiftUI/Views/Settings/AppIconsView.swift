//
//  AppIconsView.swift
//  SideStore
//
//  Created by naturecodevoid on 2/14/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import SFSafeSymbols

struct Icon: Identifiable {
    var id: String { assetName }
    var displayName: String
    let assetName: String
}

private struct SpecialIcon {
    let assetName: String
    let suffix: String?
    let forceIndex: Int?
}

class AppIconsData: ObservableObject {
    static let shared = AppIconsData()
    
    private static let specialIcons = [
        SpecialIcon(assetName: "Neon", suffix: "(Stable)", forceIndex: 0),
        SpecialIcon(assetName: "Starburst", suffix: "(Beta)", forceIndex: 1),
        SpecialIcon(assetName: "Steel", suffix: "(Nightly)", forceIndex: 2),
    ]
    
    @Published var icons: [Icon] = []
    @Published var primaryIcon: Icon?
    @Published var selectedIconName: String?
    
    private init() {
        let bundleIcons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as! [String: Any]
        
        let primaryIconData = bundleIcons["CFBundlePrimaryIcon"] as! [String: Any]
        let primaryIconName = primaryIconData["CFBundleIconName"] as! String
        primaryIcon = Icon(displayName: primaryIconName, assetName: primaryIconName)
        icons.append(primaryIcon!)
        
        for (key, _) in bundleIcons["CFBundleAlternateIcons"] as! [String: Any] {
            icons.append(Icon(displayName: key, assetName: key))
        }
        
        // sort alphabetically
        icons.sort { $0.assetName < $1.assetName }
        
        for specialIcon in AppIconsData.specialIcons {
            guard let icon = icons.enumerated().first(where: { $0.element.assetName == specialIcon.assetName }) else { continue }
            
            if let suffix = specialIcon.suffix {
                icons[icon.offset].displayName += " " + suffix
            }
            
            if let forceIndex = specialIcon.forceIndex {
                let e = icons.remove(at: icon.offset)
                icons.insert(e, at: forceIndex)
            }
        }
        
        if let alternateIconName = UIApplication.shared.alternateIconName {
            selectedIconName = icons.first { $0.assetName == alternateIconName }?.assetName ?? primaryIcon!.assetName
        } else {
            selectedIconName = primaryIcon!.assetName
        }
    }
}

struct AppIconsView: View {
    @ObservedObject private var iO = Inject.observer
    
    @ObservedObject private var data = AppIconsData.shared
    
    private let artists = [
        "Chris (LitRitt)": ["Neon", "Starburst", "Steel", "Storm"],
        "naturecodevoid": ["Honeydew", "Midnight", "Sky"],
        "Swifticul": ["Vista"],
    ]
    
    @State private var selectedIcon: String? = "" // this is just so the list row background changes when selecting a value, I couldn't get it to keep the selected icon name (for some reason it was always "", even when I set it to the selected icon asset name)
    
    private let size: CGFloat = 72
    private var cornerRadius: CGFloat {
        size * 0.234
    }
    
    var body: some View {
        List(data.icons, selection: $selectedIcon) { icon in
            SwiftUI.Button(action: {
                data.selectedIconName = icon.assetName
                // Pass nil for primary icon
                UIApplication.shared.setAlternateIconName(icon.assetName == data.primaryIcon!.assetName ? nil : icon.assetName, completionHandler: { error in
                    if let error = error {
                        print("error when setting alternate app icon to \(icon.assetName): \(error.localizedDescription)")
                    } else {
                        print("successfully changed app icon to \(icon.assetName)")
                    }
                })
            }) {
                HStack(spacing: 20) {
                    // if we don't have an additional image asset for each icon, it will have low resolution
                    Image(uiImage: UIImage(named: icon.assetName + "-image") ?? UIImage())
                        .resizable()
                        .renderingMode(.original)
                        .cornerRadius(cornerRadius)
                        .frame(width: size, height: size)
                    VStack(alignment: .leading) {
                        Text(icon.displayName)
                        if let artist = artists.first(where: { $0.value.contains(icon.assetName) }) {
                            Text("By " + artist.key)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    if data.selectedIconName == icon.assetName {
                        Image(systemSymbol: .checkmark)
                            .foregroundColor(Color.blue)
                    }
                }
            }.foregroundColor(.primary)
        }
        .navigationTitle(L10n.AppIconsView.title)
        .enableInjection()
    }
}

struct AppIconsView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconsView()
    }
}
