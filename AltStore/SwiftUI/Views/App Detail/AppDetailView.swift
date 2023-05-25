//
//  AppDetailView.swift
//  SideStore
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import AsyncImage
import ExpandableText
import SFSafeSymbols
import AltStoreCore

struct AppDetailView: View {
    
    let storeApp: StoreApp

    let byteCountFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        return formatter
    }()
    
    @State var scrollOffset: CGFloat = .zero
    let maxContentCornerRadius: CGFloat = 24
    let headerViewHeight: CGFloat = 140
    let permissionColumns = 4

    var headerBlurRadius: CGFloat {
        min(20, max(0, 20 - (scrollOffset / -150) * 20))
    }
    var isHeaderViewVisible: Bool {
        scrollOffset < headerViewHeight + 12
    }
    var contentCornerRadius: CGFloat {
        max(CGFloat.zero, min(maxContentCornerRadius, maxContentCornerRadius * (1 - self.scrollOffset / self.headerViewHeight)))
    }

    var canRateApp: Bool {
        self.storeApp.installedApp != nil
    }

    
    var body: some View {
        ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
            LazyVStack {
                headerView
                    .frame(height: headerViewHeight)
                
                contentView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                AppPillButton(app: storeApp)
                    .disabled(isHeaderViewVisible)
                    .offset(y: isHeaderViewVisible ? 12 : 0)
                    .opacity(isHeaderViewVisible ? 0 : 1)
                    .animation(.easeInOut(duration: 0.2), value: isHeaderViewVisible)
            }
            
            ToolbarItemGroup(placement: .principal) {
                HStack {
                    Spacer()
                    AppIconView(iconUrl: storeApp.iconURL, isSideStore: storeApp.isSideStore, size: 24)
                    Text(storeApp.name)
                        .bold()
                    Spacer()
                }
                .offset(y: isHeaderViewVisible ? 12 : 0)
                .opacity(isHeaderViewVisible ? 0 : 1)
                .animation(.easeInOut(duration: 0.2), value: isHeaderViewVisible)
            }
        }
    }
    
    
    var headerView: some View {
        ZStack(alignment: .center) {
            GeometryReader { proxy in
                AppIconView(iconUrl: storeApp.iconURL, isSideStore: storeApp.isSideStore, size: proxy.frame(in: .global).width)
                    .blur(radius: headerBlurRadius)
                    .offset(y: min(0, scrollOffset))
            }
            .padding()
            
            AppRowView(app: storeApp)
                .padding(.horizontal)
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 32) {
                if storeApp.isFromOfficialSource {
                    officialAppBadge
                } else if storeApp.isFromTrustedSource {
                    trustedAppBadge
                }

                if let subtitle = storeApp.subtitle {
                    VStack {
                        if #available(iOS 15.0, *) {
                            Image(systemSymbol: .quoteOpening)
                                .foregroundColor(.secondary.opacity(0.5))
                                .imageScale(.large)
                                .transformEffect(CGAffineTransform(a: 1, b: 0, c: -0.3, d: 1, tx: 0, ty: 0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(x: 30)
                        }

                        Text(subtitle)
                            .bold()
                            .italic()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)

                        if #available(iOS 15.0, *) {
                            Image(systemSymbol: .quoteClosing)
                                .foregroundColor(.secondary.opacity(0.5))
                                .imageScale(.large)
                                .transformEffect(CGAffineTransform(a: 1, b: 0, c: -0.3, d: 1, tx: 0, ty: 0))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .offset(x: -30)
                        }
                    }
                    .padding(.horizontal)
                }

                if !storeApp.screenshotURLs.isEmpty {
                    // Equatable: Only reload the view if the screenshots change.
                    // This prevents unnecessary redraws on scroll.
                    AppScreenshotsScrollView(urls: storeApp.screenshotURLs)
                        .equatable()
                } else {
                    VStack() {
                        Text(L10n.AppDetailView.noScreenshots)
                            .italic()
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }

                ExpandableText(text: storeApp.localizedDescription)
                    .lineLimit(6)
                    .expandButton(TextSet(text: L10n.AppDetailView.more, font: .callout, color: .accentColor))
                    .padding(.horizontal)
            }


            VStack(spacing: 24) {
                Divider()

                currentVersionView

                if false {
                    Divider()
                    
                    ratingsView
                }

                Divider()

                permissionsView

                Divider()

                informationView

                if !(storeApp.isFromOfficialSource || storeApp.isFromTrustedSource) {
                    Divider()

                    reportButton
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(
            RoundedRectangle(cornerRadius: contentCornerRadius)
                .foregroundColor(Color(UIColor.systemBackground))
                .shadow(radius: isHeaderViewVisible ? 12 : 0)
        )
    }
    
    var officialAppBadge: some View {
        HintView(backgroundColor: Color(UIColor.secondarySystemBackground)) {
            HStack {
                Spacer()
                Image(systemSymbol: .checkmarkSealFill)
                Text(L10n.AppDetailView.Badge.official)
                Spacer()
            }
            .foregroundColor(.accentColor)
        }
        .padding(.horizontal)
    }
    
    var trustedAppBadge: some View {
        HintView(backgroundColor: Color(UIColor.secondarySystemBackground)) {
            HStack {
                Spacer()
                Image(systemSymbol: .shieldLefthalfFill)
                Text(L10n.AppDetailView.Badge.trusted)
                Spacer()
            }
            .foregroundColor(.accentColor)
        }
        .padding(.horizontal)
    }
    
    var currentVersionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(L10n.AppDetailView.whatsNew)
                        .bold()
                        .font(.title3)

                    Spacer()

                    NavigationLink {
                        AppVersionHistoryView(storeApp: self.storeApp)
                    } label: {
                        Text(L10n.AppDetailView.WhatsNew.versionHistory)
                    }
                }

                if let latestVersion = storeApp.latestVersion {
                    HStack {
                        Text(L10n.AppDetailView.version(latestVersion.version))
                        Spacer()
                        Text(DateFormatterHelper.string(forRelativeDate: latestVersion.date))
                    }
                    .font(.callout)
                    .foregroundColor(.secondary)
                }
            }
            
            if let versionDescription = storeApp.versionDescription {
                ExpandableText(text: versionDescription)
                    .lineLimit(5)
                    .expandButton(TextSet(text: L10n.AppDetailView.more, font: .callout, color: .accentColor))
            } else {
                Text(L10n.AppDetailView.noVersionInformation)
                    .foregroundColor(.secondary)
            }


            if true {
                SwiftUI.Button {
                    UIApplication.shared.open(URL(string: "https://github.com/SideStore/SideStore")!) { _ in }
                } label: {
                    HStack {
                        Text(L10n.AppDetailView.WhatsNew.showOnGithub)
                        Image(systemSymbol: .arrowUpForwardSquare)
                    }
                }
            }
        }
    }

    var ratingsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(L10n.AppDetailView.whatsNew)
                    .bold()
                    .font(.title3)

                Spacer()

                NavigationLink {
                    AppVersionHistoryView(storeApp: self.storeApp)
                } label: {
                    Text(L10n.AppDetailView.Reviews.seeAll)
                }
            }

            HStack(spacing: 40) {
                VStack {
                    Text("3.0")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .opacity(0.8)
                    Text(L10n.AppDetailView.Reviews.outOf(5))
                        .bold()
                        .font(.callout)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .trailing) {
                    LazyVGrid(columns: [GridItem(.fixed(48), alignment: .trailing), GridItem(.flexible())], spacing: 2) {
                        ForEach(Array(1...5).reversed(), id: \.self) { rating in
                            HStack(spacing: 2) {
                                ForEach(0..<rating) { _ in
                                    Image(systemSymbol: .starFill)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 8)
                                }
                            }

                            ProgressView(value: 0.5)
                                .frame(maxWidth: .infinity)
                                .progressViewStyle(LinearProgressViewStyle(tint: .secondary))
                        }
                    }
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)

                    Text(L10n.AppDetailView.Reviews.ratings(5))
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }

            TabView {
                ForEach(0..<5) { i in
                    HintView(backgroundColor: Color(UIColor.secondarySystemBackground)) {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Review \(i + 1)")
                                        .bold()
                                        .lineLimit(1)

                                    Spacer()

                                    Text(DateFormatterHelper.string(forRelativeDate: Date().addingTimeInterval(-60*60)))
                                        .foregroundColor(.secondary)
                                }

                                RatingStars(rating: 5 - i)
                                    .frame(height: 12)
                                    .foregroundColor(.yellow)
                            }

                            ExpandableText(text: "Long review text content here.\nMultiple lines.\nAt least three are shown.\nBut are there more?")
                                .lineLimit(3)
                                .expandButton(TextSet(text: L10n.AppDetailView.more, font: .callout, color: .accentColor))
                        }
                        .frame(maxWidth: .infinity)

                    }
                    .tag(i)
                    .padding(.horizontal, 16)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 150)
            .padding(.horizontal, -16)

            if self.canRateApp {
                ModalNavigationLink {
                    NavigationView {
                        WriteAppReviewView(storeApp: self.storeApp)
                    }
                } label: {
                    Label("Write a Review", systemSymbol: .squareAndPencil)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    var permissionsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.AppDetailView.permissions)
                .bold()
                .font(.title3)
            
            if storeApp.permissions.isEmpty {
                Text(L10n.AppDetailView.noPermissions)
                    .font(.callout)
                    .foregroundColor(.secondary)
            } else {
                AppPermissionsGrid(permissions: storeApp.permissions)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var informationData: [(title: String, content: String)] {
        var data: [(title: String, content: String)] = [
            (L10n.AppDetailView.Information.source, self.storeApp.source?.name ?? ""),
            (L10n.AppDetailView.Information.developer, self.storeApp.developerName),
//                ("Category", self.storeApp.category),
        ]

        if let latestVersion = self.storeApp.latestVersion {
            data += [
                (L10n.AppDetailView.Information.size, self.byteCountFormatter.string(fromByteCount: latestVersion.size)),
                (L10n.AppDetailView.Information.latestVersion, self.storeApp.latestVersion?.version ?? ""),
            ]

            let iOSVersion = ProcessInfo.processInfo.operatingSystemVersion
            let hasCompatibilityInfo = [latestVersion.minOSVersion, latestVersion.maxOSVersion].compactMap({ $0 }).isEmpty == false
            var compatibility: String = hasCompatibilityInfo ?
                L10n.AppDetailView.Information.compatibilityCompatible :
                L10n.AppDetailView.Information.compatibilityUnknown

            if let minOSVersion = latestVersion.minOSVersion, ProcessInfo.processInfo.isOperatingSystemAtLeast(minOSVersion) == false {
                compatibility = L10n.AppDetailView.Information.compatibilityAtLeast(minOSVersion.stringValue)
            }

            if let maxOSVersion = latestVersion.maxOSVersion,
               (!ProcessInfo.processInfo.isOperatingSystemAtLeast(maxOSVersion) || maxOSVersion.stringValue.compare(iOSVersion.stringValue, options: .numeric) == .orderedSame) {
                compatibility = L10n.AppDetailView.Information.compatibilityOrLower(maxOSVersion.stringValue)
            }

            data.append((L10n.AppDetailView.Information.compatibility, compatibility))
        }
        return data
    }

    var informationView: some View {
        VStack(alignment: .leading) {
            Text(L10n.AppDetailView.information)
                .bold()
                .font(.title3)

            LazyVGrid(columns: [GridItem(.flexible(), alignment: .leading), GridItem(.flexible(), alignment: .trailing)], spacing: 8) {
                ForEach(informationData, id: \.title) { title, content in
                    Text(title)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(content)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    var reportButton: some View {
        SwiftUI.Button {

        } label: {
            Label("Report this App", systemSymbol: .exclamationmarkBubble)
        }
    }
}


struct AppDetailView_Previews: PreviewProvider {

    static let context = DatabaseManager.shared.viewContext
    static let app = StoreApp.makeAltStoreApp(in: context)

    static var previews: some View {
        NavigationView {
            AppDetailView(storeApp: app)
        }
    }
}
