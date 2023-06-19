// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Action {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "Action.cancel", fallback: "Cancel")
    /// Close
    internal static let close = L10n.tr("Localizable", "Action.close", fallback: "Close")
    /// General Actions
    internal static let done = L10n.tr("Localizable", "Action.done", fallback: "Done")
    /// Enable
    internal static let enable = L10n.tr("Localizable", "Action.enable", fallback: "Enable")
    /// Submit
    internal static let submit = L10n.tr("Localizable", "Action.submit", fallback: "Submit")
    /// Success
    internal static let success = L10n.tr("Localizable", "Action.success", fallback: "Success")
    /// Try Again
    internal static let tryAgain = L10n.tr("Localizable", "Action.tryAgain", fallback: "Try Again")
  }
  internal enum AddSourceView {
    /// Continue
    internal static let `continue` = L10n.tr("Localizable", "AddSourceView.continue", fallback: "Continue")
    /// AddSourceView
    internal static let sourceURL = L10n.tr("Localizable", "AddSourceView.sourceURL", fallback: "Source URL")
    /// Please enter the source url here. Then, tap continue to validate and add the source in the next step.
    internal static let sourceWarning = L10n.tr("Localizable", "AddSourceView.sourceWarning", fallback: "Please enter the source url here. Then, tap continue to validate and add the source in the next step.")
    /// Be careful with unvalidated third-party sources! Make sure to only add sources that you trust.
    internal static let sourceWarningContinued = L10n.tr("Localizable", "AddSourceView.sourceWarningContinued", fallback: "Be careful with unvalidated third-party sources! Make sure to only add sources that you trust.")
    /// Add Source
    internal static let title = L10n.tr("Localizable", "AddSourceView.title", fallback: "Add Source")
  }
  internal enum AdvancedSettingsView {
    /// Anisette
    internal static let anisetteSettings = L10n.tr("Localizable", "AdvancedSettingsView.anisetteSettings", fallback: "Anisette")
    /// Danger Zone
    internal static let dangerZone = L10n.tr("Localizable", "AdvancedSettingsView.dangerZone", fallback: "Danger Zone")
    /// AdvancedSettingsView
    internal static let title = L10n.tr("Localizable", "AdvancedSettingsView.title", fallback: "Advanced Settings")
    internal enum AnisetteSettings {
      /// Anisette URL
      internal static let anisetteURL = L10n.tr("Localizable", "AdvancedSettingsView.AnisetteSettings.anisetteURL", fallback: "Anisette URL")
      /// If you disable "Use preferred servers" then SideStore will use the server you input into the "Anisette URL" box rather than one selected in "Anisette Server".
      internal static let footer = L10n.tr("Localizable", "AdvancedSettingsView.AnisetteSettings.footer", fallback: "If you disable \"Use preferred servers\" then SideStore will use the server you input into the \"Anisette URL\" box rather than one selected in \"Anisette Server\".")
      /// Anisette Server
      internal static let server = L10n.tr("Localizable", "AdvancedSettingsView.AnisetteSettings.server", fallback: "Anisette Server")
      /// Use preferred servers
      internal static let usePreferred = L10n.tr("Localizable", "AdvancedSettingsView.AnisetteSettings.usePreferred", fallback: "Use preferred servers")
    }
    internal enum DangerZone {
      /// Debug Logging
      internal static let debugLogging = L10n.tr("Localizable", "AdvancedSettingsView.DangerZone.debugLogging", fallback: "Debug Logging")
    }
  }
  internal enum AppAction {
    /// Activate
    internal static let activate = L10n.tr("Localizable", "AppAction.activate", fallback: "Activate")
    /// Backup
    internal static let backup = L10n.tr("Localizable", "AppAction.backup", fallback: "Backup")
    /// Customize icon
    internal static let chooseCustomIcon = L10n.tr("Localizable", "AppAction.chooseCustomIcon", fallback: "Customize icon")
    /// Deactivate
    internal static let deactivate = L10n.tr("Localizable", "AppAction.deactivate", fallback: "Deactivate")
    /// Activate JIT
    internal static let enableJIT = L10n.tr("Localizable", "AppAction.enableJIT", fallback: "Activate JIT")
    /// Export backup
    internal static let exportBackup = L10n.tr("Localizable", "AppAction.exportBackup", fallback: "Export backup")
    /// AppAction
    internal static let install = L10n.tr("Localizable", "AppAction.install", fallback: "Install")
    /// Open
    internal static let `open` = L10n.tr("Localizable", "AppAction.open", fallback: "Open")
    /// Refresh
    internal static let refresh = L10n.tr("Localizable", "AppAction.refresh", fallback: "Refresh")
    /// Remove
    internal static let remove = L10n.tr("Localizable", "AppAction.remove", fallback: "Remove")
    /// Reset icon
    internal static let resetIcon = L10n.tr("Localizable", "AppAction.resetIcon", fallback: "Reset icon")
    /// Restore backup
    internal static let restoreBackup = L10n.tr("Localizable", "AppAction.restoreBackup", fallback: "Restore backup")
  }
  internal enum AppDetailView {
    /// Information
    internal static let information = L10n.tr("Localizable", "AppDetailView.information", fallback: "Information")
    /// More...
    internal static let more = L10n.tr("Localizable", "AppDetailView.more", fallback: "More...")
    /// The app requires no permissions.
    internal static let noPermissions = L10n.tr("Localizable", "AppDetailView.noPermissions", fallback: "The app requires no permissions.")
    /// No screenshots available for this app.
    internal static let noScreenshots = L10n.tr("Localizable", "AppDetailView.noScreenshots", fallback: "No screenshots available for this app.")
    /// No version information
    internal static let noVersionInformation = L10n.tr("Localizable", "AppDetailView.noVersionInformation", fallback: "No version information")
    /// Permissions
    internal static let permissions = L10n.tr("Localizable", "AppDetailView.permissions", fallback: "Permissions")
    /// Ratings & Reviews
    internal static let reviews = L10n.tr("Localizable", "AppDetailView.reviews", fallback: "Ratings & Reviews")
    /// Version %@
    internal static func version(_ p1: Any) -> String {
      return L10n.tr("Localizable", "AppDetailView.version", String(describing: p1), fallback: "Version %@")
    }
    /// What's New
    internal static let whatsNew = L10n.tr("Localizable", "AppDetailView.whatsNew", fallback: "What's New")
    internal enum Badge {
      /// AppDetailView
      internal static let official = L10n.tr("Localizable", "AppDetailView.Badge.official", fallback: "Official App")
      /// From Trusted Source
      internal static let trusted = L10n.tr("Localizable", "AppDetailView.Badge.trusted", fallback: "From Trusted Source")
    }
    internal enum Information {
      /// Compatibility
      internal static let compatibility = L10n.tr("Localizable", "AppDetailView.Information.compatibility", fallback: "Compatibility")
      /// Requires iOS %@ or higher
      internal static func compatibilityAtLeast(_ p1: Any) -> String {
        return L10n.tr("Localizable", "AppDetailView.Information.compatibilityAtLeast", String(describing: p1), fallback: "Requires iOS %@ or higher")
      }
      /// Unknown
      internal static let compatibilityCompatible = L10n.tr("Localizable", "AppDetailView.Information.compatibilityCompatible", fallback: "Unknown")
      /// Requires iOS %@ or lower
      internal static func compatibilityOrLower(_ p1: Any) -> String {
        return L10n.tr("Localizable", "AppDetailView.Information.compatibilityOrLower", String(describing: p1), fallback: "Requires iOS %@ or lower")
      }
      /// Unknown
      internal static let compatibilityUnknown = L10n.tr("Localizable", "AppDetailView.Information.compatibilityUnknown", fallback: "Unknown")
      /// Developer
      internal static let developer = L10n.tr("Localizable", "AppDetailView.Information.developer", fallback: "Developer")
      /// Latest Version
      internal static let latestVersion = L10n.tr("Localizable", "AppDetailView.Information.latestVersion", fallback: "Latest Version")
      /// Size
      internal static let size = L10n.tr("Localizable", "AppDetailView.Information.size", fallback: "Size")
      /// Source
      internal static let source = L10n.tr("Localizable", "AppDetailView.Information.source", fallback: "Source")
    }
    internal enum Reviews {
      /// out of %d
      internal static func outOf(_ p1: Int) -> String {
        return L10n.tr("Localizable", "AppDetailView.Reviews.outOf", p1, fallback: "out of %d")
      }
      /// %d Ratings
      internal static func ratings(_ p1: Int) -> String {
        return L10n.tr("Localizable", "AppDetailView.Reviews.ratings", p1, fallback: "%d Ratings")
      }
      /// See All
      internal static let seeAll = L10n.tr("Localizable", "AppDetailView.Reviews.seeAll", fallback: "See All")
    }
    internal enum WhatsNew {
      /// Show project on GitHub
      internal static let showOnGithub = L10n.tr("Localizable", "AppDetailView.WhatsNew.showOnGithub", fallback: "Show project on GitHub")
      /// Version History
      internal static let versionHistory = L10n.tr("Localizable", "AppDetailView.WhatsNew.versionHistory", fallback: "Version History")
    }
  }
  internal enum AppIDsView {
    /// Each app and app extension installed with SideStore must register an App ID with Apple.
    /// 
    /// App IDs for paid developer accounts never expire, and there is no limit to how many you can create.
    internal static let description = L10n.tr("Localizable", "AppIDsView.description", fallback: "Each app and app extension installed with SideStore must register an App ID with Apple.\n\nApp IDs for paid developer accounts never expire, and there is no limit to how many you can create.")
    /// AppIDsView
    internal static let title = L10n.tr("Localizable", "AppIDsView.title", fallback: "App IDs")
  }
  internal enum AppIconsView {
    /// AppIconsView
    internal static let title = L10n.tr("Localizable", "AppIconsView.title", fallback: "App Icon")
  }
  internal enum AppPermissionGrid {
    /// AppPermissionGrid
    internal static let usageDescription = L10n.tr("Localizable", "AppPermissionGrid.usageDescription", fallback: "Usage Description")
  }
  internal enum AppPillButton {
    /// AppPillButton
    internal static let free = L10n.tr("Localizable", "AppPillButton.free", fallback: "Free")
    /// Open
    internal static let `open` = L10n.tr("Localizable", "AppPillButton.open", fallback: "Open")
  }
  internal enum AppRowView {
    /// AppRowView
    internal static let sideloaded = L10n.tr("Localizable", "AppRowView.sideloaded", fallback: "Sideloaded")
  }
  internal enum AsyncFallibleButton {
    /// AsyncFallibleButton
    internal static let error = L10n.tr("Localizable", "AsyncFallibleButton.error", fallback: "An error occurred")
  }
  internal enum BrowseView {
    /// Search
    internal static let search = L10n.tr("Localizable", "BrowseView.search", fallback: "Search")
    /// BrowseView
    internal static let title = L10n.tr("Localizable", "BrowseView.title", fallback: "Browse")
    internal enum Actions {
      /// Sources
      internal static let sources = L10n.tr("Localizable", "BrowseView.Actions.sources", fallback: "Sources")
    }
    internal enum Categories {
      /// Games and
      /// Emulators
      internal static let gamesAndEmulators = L10n.tr("Localizable", "BrowseView.Categories.gamesAndEmulators", fallback: "Games and\nEmulators")
    }
    internal enum Hints {
      internal enum NoApps {
        /// Add Source
        internal static let addSource = L10n.tr("Localizable", "BrowseView.Hints.NoApps.addSource", fallback: "Add Source")
        /// Apps are provided by "sources". The specification for them is an open standard, so everyone can create their own source. To get you started, we have compiled a list of "Trusted Sources" which you can check out by tapping the button below.
        internal static let text = L10n.tr("Localizable", "BrowseView.Hints.NoApps.text", fallback: "Apps are provided by \"sources\". The specification for them is an open standard, so everyone can create their own source. To get you started, we have compiled a list of \"Trusted Sources\" which you can check out by tapping the button below.")
        /// You don't have any apps yet.
        internal static let title = L10n.tr("Localizable", "BrowseView.Hints.NoApps.title", fallback: "You don't have any apps yet.")
      }
    }
    internal enum Section {
      internal enum AllApps {
        /// All Apps
        internal static let title = L10n.tr("Localizable", "BrowseView.Section.AllApps.title", fallback: "All Apps")
      }
      internal enum PromotedCategories {
        /// Show all
        internal static let showAll = L10n.tr("Localizable", "BrowseView.Section.PromotedCategories.showAll", fallback: "Show all")
        /// Promoted Categories
        internal static let title = L10n.tr("Localizable", "BrowseView.Section.PromotedCategories.title", fallback: "Promoted Categories")
      }
    }
  }
  internal enum ConfirmAddSourceView {
    /// Add Source
    internal static let addSource = L10n.tr("Localizable", "ConfirmAddSourceView.addSource", fallback: "Add Source")
    /// ConfirmAddSourceView
    internal static let apps = L10n.tr("Localizable", "ConfirmAddSourceView.apps", fallback: "Apps")
    /// News Items
    internal static let newsItems = L10n.tr("Localizable", "ConfirmAddSourceView.newsItems", fallback: "News Items")
    /// Source Contents
    internal static let sourceContents = L10n.tr("Localizable", "ConfirmAddSourceView.sourceContents", fallback: "Source Contents")
    /// Source Identifier
    internal static let sourceIdentifier = L10n.tr("Localizable", "ConfirmAddSourceView.sourceIdentifier", fallback: "Source Identifier")
    /// Source Information
    internal static let sourceInfo = L10n.tr("Localizable", "ConfirmAddSourceView.sourceInfo", fallback: "Source Information")
    /// Source URL
    internal static let sourceURL = L10n.tr("Localizable", "ConfirmAddSourceView.sourceURL", fallback: "Source URL")
  }
  internal enum ConnectAppleIDView {
    /// Apple ID
    internal static let appleID = L10n.tr("Localizable", "ConnectAppleIDView.appleID", fallback: "Apple ID")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "ConnectAppleIDView.cancel", fallback: "Cancel")
    /// Connect Your Apple ID
    internal static let connectYourAppleID = L10n.tr("Localizable", "ConnectAppleIDView.connectYourAppleID", fallback: "Connect Your Apple ID")
    /// Failed to Sign In
    internal static let failedToSignIn = L10n.tr("Localizable", "ConnectAppleIDView.failedToSignIn", fallback: "Failed to Sign In")
    /// Your Apple ID is used to configure apps so they can be installed on this device. Your credentials will be stored securely in this device's Keychain and sent only to Apple for authentication.
    internal static let footer = L10n.tr("Localizable", "ConnectAppleIDView.footer", fallback: "Your Apple ID is used to configure apps so they can be installed on this device. Your credentials will be stored securely in this device's Keychain and sent only to Apple for authentication.")
    /// Password
    internal static let password = L10n.tr("Localizable", "ConnectAppleIDView.password", fallback: "Password")
    /// Sign In
    internal static let signIn = L10n.tr("Localizable", "ConnectAppleIDView.signIn", fallback: "Sign In")
    /// ConnectAppleIDView
    internal static let startWithSignIn = L10n.tr("Localizable", "ConnectAppleIDView.startWithSignIn", fallback: "Sign in with your Apple ID to get started.")
    /// Why do we need this?
    internal static let whyDoWeNeedThis = L10n.tr("Localizable", "ConnectAppleIDView.whyDoWeNeedThis", fallback: "Why do we need this?")
  }
  internal enum DevModeView {
    /// Incorrect password.
    internal static let incorrectPassword = L10n.tr("Localizable", "DevModeView.incorrectPassword", fallback: "Incorrect password.")
    /// Password
    internal static let password = L10n.tr("Localizable", "DevModeView.password", fallback: "Password")
    /// SideStore's Developer Mode gives access to a menu with some debugging actions commonly used by developers. **However, some of them can break SideStore if used in the wrong way.**
    /// 
    /// You should only enable Developer Mode if you meet one of the following requirements:
    /// - You are a SideStore developer or contributor
    /// - You were asked to do this by a helper when getting support
    /// - You were asked to do this when you reported a bug or helped a developer test a change
    /// 
    /// **_We will not provide support if you break SideStore with Developer Mode._**
    internal static let prompt = L10n.tr("Localizable", "DevModeView.prompt", fallback: "SideStore's Developer Mode gives access to a menu with some debugging actions commonly used by developers. **However, some of them can break SideStore if used in the wrong way.**\n\nYou should only enable Developer Mode if you meet one of the following requirements:\n- You are a SideStore developer or contributor\n- You were asked to do this by a helper when getting support\n- You were asked to do this when you reported a bug or helped a developer test a change\n\n**_We will not provide support if you break SideStore with Developer Mode._**")
    /// Read the text!
    internal static let read = L10n.tr("Localizable", "DevModeView.read", fallback: "Read the text!")
    /// DevModeView
    internal static let title = L10n.tr("Localizable", "DevModeView.title", fallback: "Developer Mode")
    internal enum Files {
      /// Data File Explorer
      internal static let dataExplorer = L10n.tr("Localizable", "DevModeView.Files.dataExplorer", fallback: "Data File Explorer")
      /// Files
      internal static let header = L10n.tr("Localizable", "DevModeView.Files.header", fallback: "Files")
      /// Temporary File Explorer
      internal static let tmpExplorer = L10n.tr("Localizable", "DevModeView.Files.tmpExplorer", fallback: "Temporary File Explorer")
    }
    internal enum General {
      /// Console
      internal static let console = L10n.tr("Localizable", "DevModeView.General.console", fallback: "Console")
      /// Disable Developer Mode
      internal static let disableDevMode = L10n.tr("Localizable", "DevModeView.General.disableDevMode", fallback: "Disable Developer Mode")
      /// General
      internal static let header = L10n.tr("Localizable", "DevModeView.General.header", fallback: "General")
      /// Reset Image Cache
      internal static let resetImageCache = L10n.tr("Localizable", "DevModeView.General.resetImageCache", fallback: "Reset Image Cache")
      /// Unstable Features are only available on nightly builds, PR builds and debug builds.
      internal static let unstableFeaturesNightlyOnly = L10n.tr("Localizable", "DevModeView.General.unstableFeaturesNightlyOnly", fallback: "Unstable Features are only available on nightly builds, PR builds and debug builds.")
    }
    internal enum Mdc {
      /// Tell SideStore installd has not been patched (may cause undefined behavior or boot loop if you apply the patch more than once on a real device!!)
      internal static let fakeUndo3AppLimitPatch = L10n.tr("Localizable", "DevModeView.Mdc.fakeUndo3AppLimitPatch", fallback: "Tell SideStore installd has not been patched (may cause undefined behavior or boot loop if you apply the patch more than once on a real device!!)")
      /// MDC
      internal static let header = L10n.tr("Localizable", "DevModeView.Mdc.header", fallback: "MDC")
    }
    internal enum Minimuxer {
      /// AFC File Explorer (check footer for notes)
      internal static let afcExplorer = L10n.tr("Localizable", "DevModeView.Minimuxer.afcExplorer", fallback: "AFC File Explorer (check footer for notes)")
      /// Dump provisioning profiles to Documents directory
      internal static let dumpProfiles = L10n.tr("Localizable", "DevModeView.Minimuxer.dumpProfiles", fallback: "Dump provisioning profiles to Documents directory")
      /// Notes on AFC File Explorer:
      /// - If nothing shows up, check minimuxer logs for error
      /// - It is currently extremely very unoptimized and may be very slow; a new AFC client is created for every action
      /// - It is currently limited to a maximum depth of 3 to ensure it doesn't take too long to iterate over everything when you open it
      /// - Very buggy
      /// - There are multiple unimplemented actions
      internal static let footer = L10n.tr("Localizable", "DevModeView.Minimuxer.footer", fallback: "Notes on AFC File Explorer:\n- If nothing shows up, check minimuxer logs for error\n- It is currently extremely very unoptimized and may be very slow; a new AFC client is created for every action\n- It is currently limited to a maximum depth of 3 to ensure it doesn't take too long to iterate over everything when you open it\n- Very buggy\n- There are multiple unimplemented actions")
      /// minimuxer debug actions
      internal static let header = L10n.tr("Localizable", "DevModeView.Minimuxer.header", fallback: "minimuxer debug actions")
    }
    internal enum Signing {
      /// Skip Resign should only be used when you have an IPA that you have self signed. Otherwise, it will break things, and might make SideStore crash (there is absolutely no error handling and everything is expected to work).
      internal static let footer = L10n.tr("Localizable", "DevModeView.Signing.footer", fallback: "Skip Resign should only be used when you have an IPA that you have self signed. Otherwise, it will break things, and might make SideStore crash (there is absolutely no error handling and everything is expected to work).")
      /// Signing
      internal static let header = L10n.tr("Localizable", "DevModeView.Signing.header", fallback: "Signing")
      /// Skip Resign
      internal static let skipResign = L10n.tr("Localizable", "DevModeView.Signing.skipResign", fallback: "Skip Resign")
    }
  }
  internal enum ErrorLogView {
    /// ErrorLogView
    internal static let title = L10n.tr("Localizable", "ErrorLogView.title", fallback: "Error Log")
  }
  internal enum MyAppsView {
    /// MyAppsView
    internal static let active = L10n.tr("Localizable", "MyAppsView.active", fallback: "Active")
    /// App IDs Remaining
    internal static let appIDsRemaining = L10n.tr("Localizable", "MyAppsView.appIDsRemaining", fallback: "App IDs Remaining")
    /// apps
    internal static let apps = L10n.tr("Localizable", "MyAppsView.apps", fallback: "apps")
    /// Failed to refresh
    internal static let failedToRefresh = L10n.tr("Localizable", "MyAppsView.failedToRefresh", fallback: "Failed to refresh")
    /// My Apps
    internal static let myApps = L10n.tr("Localizable", "MyAppsView.myApps", fallback: "My Apps")
    /// Refresh All
    internal static let refreshAll = L10n.tr("Localizable", "MyAppsView.refreshAll", fallback: "Refresh All")
    /// Sideloading in progress...
    internal static let sideloading = L10n.tr("Localizable", "MyAppsView.sideloading", fallback: "Sideloading in progress...")
    /// Keep this lowercase
    internal static let viewAppIDs = L10n.tr("Localizable", "MyAppsView.viewAppIDs", fallback: "View App IDs")
    internal enum Hints {
      internal enum NoUpdates {
        /// Dismiss for now
        internal static let dismissForNow = L10n.tr("Localizable", "MyAppsView.Hints.NoUpdates.dismissForNow", fallback: "Dismiss for now")
        /// Don't show this again
        internal static let dontShowAgain = L10n.tr("Localizable", "MyAppsView.Hints.NoUpdates.dontShowAgain", fallback: "Don't show this again")
        /// You will be notified once updates for your apps are available. The updates will then be shown here.
        internal static let text = L10n.tr("Localizable", "MyAppsView.Hints.NoUpdates.text", fallback: "You will be notified once updates for your apps are available. The updates will then be shown here.")
        /// All Apps are Up To Date
        internal static let title = L10n.tr("Localizable", "MyAppsView.Hints.NoUpdates.title", fallback: "All Apps are Up To Date")
      }
    }
  }
  internal enum NewsView {
    /// NewsView
    internal static let title = L10n.tr("Localizable", "NewsView.title", fallback: "News")
    internal enum Section {
      internal enum FromSources {
        /// From your Sources
        internal static let title = L10n.tr("Localizable", "NewsView.Section.FromSources.title", fallback: "From your Sources")
      }
    }
  }
  internal enum RefreshAttemptsView {
    /// RefreshAttemptsView
    internal static let title = L10n.tr("Localizable", "RefreshAttemptsView.title", fallback: "Refresh Attempts")
  }
  internal enum Remove3AppLimitView {
    /// It seems that installd has already been patched to remove the 3 app limit. Please know that the patch will be undone upon boot, so if the patch isn't working, try restarting your device and then apply the patch again using SideStore.
    internal static let alreadyPatched = L10n.tr("Localizable", "Remove3AppLimitView.alreadyPatched", fallback: "It seems that installd has already been patched to remove the 3 app limit. Please know that the patch will be undone upon boot, so if the patch isn't working, try restarting your device and then apply the patch again using SideStore.")
    /// Apply Patch
    internal static let applyPatch = L10n.tr("Localizable", "Remove3AppLimitView.applyPatch", fallback: "Apply Patch")
    /// Sorry, the MacDirtyCow exploit is only supported on iOS/iPadOS versions 15.0-15.7.1 or 16.0-16.1.2.
    internal static let notSupported = L10n.tr("Localizable", "Remove3AppLimitView.notSupported", fallback: "Sorry, the MacDirtyCow exploit is only supported on iOS/iPadOS versions 15.0-15.7.1 or 16.0-16.1.2.")
    /// To remove the 3 app limit that free developer accounts have, SideStore will use the MacDirtyCow exploit to patch installd. The patch will be undone upon boot, so if you want to undo it, simply restart your device.
    internal static let patchInfo = L10n.tr("Localizable", "Remove3AppLimitView.patchInfo", fallback: "To remove the 3 app limit that free developer accounts have, SideStore will use the MacDirtyCow exploit to patch installd. The patch will be undone upon boot, so if you want to undo it, simply restart your device.")
    /// Successfully applied the patch!
    internal static let success = L10n.tr("Localizable", "Remove3AppLimitView.success", fallback: "Successfully applied the patch!")
    /// The patch will allow for 10 apps per Apple ID. If you need more than 10 apps, you can sideload SideStore again with a different Apple ID than the one you are using with this SideStore to allow for 10 more apps.
    internal static let tenAppsInfo = L10n.tr("Localizable", "Remove3AppLimitView.tenAppsInfo", fallback: "The patch will allow for 10 apps per Apple ID. If you need more than 10 apps, you can sideload SideStore again with a different Apple ID than the one you are using with this SideStore to allow for 10 more apps.")
    /// Remove3AppLimitView
    internal static let title = L10n.tr("Localizable", "Remove3AppLimitView.title", fallback: "Remove 3 App Limit")
    internal enum Errors {
      /// Failed to patch installd
      internal static let failedPatchd = L10n.tr("Localizable", "Remove3AppLimitView.Errors.failedPatchd", fallback: "Failed to patch installd")
      /// Failed to get full disk access: %s
      internal static func noFDA(_ p1: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "Remove3AppLimitView.Errors.noFDA", p1, fallback: "Failed to get full disk access: %s")
      }
    }
    internal enum NotAppliedAlert {
      /// Apply patch
      internal static let apply = L10n.tr("Localizable", "Remove3AppLimitView.NotAppliedAlert.apply", fallback: "Apply patch")
      /// Continue without patch
      internal static let continueWithout = L10n.tr("Localizable", "Remove3AppLimitView.NotAppliedAlert.continueWithout", fallback: "Continue without patch")
      /// It seems that you have not applied the patch that removes the 3 app limit. Would you like to apply the patch?
      internal static let message = L10n.tr("Localizable", "Remove3AppLimitView.NotAppliedAlert.message", fallback: "It seems that you have not applied the patch that removes the 3 app limit. Would you like to apply the patch?")
    }
  }
  internal enum RootView {
    /// Browse
    internal static let browse = L10n.tr("Localizable", "RootView.browse", fallback: "Browse")
    /// My Apps
    internal static let myApps = L10n.tr("Localizable", "RootView.myApps", fallback: "My Apps")
    /// RootView
    internal static let news = L10n.tr("Localizable", "RootView.news", fallback: "News")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "RootView.settings", fallback: "Settings")
  }
  internal enum SettingsView {
    /// Add to Siri...
    internal static let addToSiri = L10n.tr("Localizable", "SettingsView.addToSiri", fallback: "Add to Siri...")
    /// Background Refresh
    internal static let backgroundRefresh = L10n.tr("Localizable", "SettingsView.backgroundRefresh", fallback: "Background Refresh")
    /// Connect your Apple ID
    internal static let connectAppleID = L10n.tr("Localizable", "SettingsView.connectAppleID", fallback: "Connect your Apple ID")
    /// Credits
    internal static let credits = L10n.tr("Localizable", "SettingsView.credits", fallback: "Credits")
    /// Debug
    internal static let debug = L10n.tr("Localizable", "SettingsView.debug", fallback: "Debug")
    /// Export Logs
    internal static let exportLogs = L10n.tr("Localizable", "SettingsView.exportLogs", fallback: "Export Logs")
    /// You seem to be on iOS/iPadOS version 15.0-15.7.1 or 16.0-16.1.2 which means you can remove the 3 app limit that free developer accounts have by using the MacDirtyCow exploit.
    /// 
    /// This is normally not included in SideStore since it triggers antivirus warnings, so you must download an IPA that includes MacDirtyCow separately from sidestore.io or install SideStore using the separate MacDirtyCow source.
    internal static let mdcPopup = L10n.tr("Localizable", "SettingsView.mdcPopup", fallback: "You seem to be on iOS/iPadOS version 15.0-15.7.1 or 16.0-16.1.2 which means you can remove the 3 app limit that free developer accounts have by using the MacDirtyCow exploit.\n\nThis is normally not included in SideStore since it triggers antivirus warnings, so you must download an IPA that includes MacDirtyCow separately from sidestore.io or install SideStore using the separate MacDirtyCow source.")
    /// Refreshing Apps
    internal static let refreshingApps = L10n.tr("Localizable", "SettingsView.refreshingApps", fallback: "Refreshing Apps")
    /// Enable Background Refresh to automatically refresh apps in the background when connected to WiFi and with Wireguard active.
    internal static let refreshingAppsFooter = L10n.tr("Localizable", "SettingsView.refreshingAppsFooter", fallback: "Enable Background Refresh to automatically refresh apps in the background when connected to WiFi and with Wireguard active.")
    /// Reset adi.pb
    internal static let resetAdiPb = L10n.tr("Localizable", "SettingsView.resetAdiPb", fallback: "Reset adi.pb")
    /// Reset Pairing File
    internal static let resetPairingFile = L10n.tr("Localizable", "SettingsView.resetPairingFile", fallback: "Reset Pairing File")
    /// Show Error Log
    internal static let showErrorLog = L10n.tr("Localizable", "SettingsView.showErrorLog", fallback: "Show Error Log")
    /// Show Refresh Attempts
    internal static let showRefreshAttempts = L10n.tr("Localizable", "SettingsView.showRefreshAttempts", fallback: "Show Refresh Attempts")
    /// SwiftUI Redesign
    internal static let swiftUIRedesign = L10n.tr("Localizable", "SettingsView.swiftUIRedesign", fallback: "SwiftUI Redesign")
    /// Switch to UIKit
    internal static let switchToUIKit = L10n.tr("Localizable", "SettingsView.switchToUIKit", fallback: "Switch to UIKit")
    /// Settings
    internal static let title = L10n.tr("Localizable", "SettingsView.title", fallback: "Settings")
    internal enum ConnectedAppleID {
      /// E-Mail
      internal static let eMail = L10n.tr("Localizable", "SettingsView.ConnectedAppleID.eMail", fallback: "E-Mail")
      /// SettingsView
      internal static let name = L10n.tr("Localizable", "SettingsView.ConnectedAppleID.name", fallback: "Name")
      /// Sign Out
      internal static let signOut = L10n.tr("Localizable", "SettingsView.ConnectedAppleID.signOut", fallback: "Sign Out")
      /// Connected Apple ID
      internal static let text = L10n.tr("Localizable", "SettingsView.ConnectedAppleID.text", fallback: "Connected Apple ID")
      /// Type
      internal static let type = L10n.tr("Localizable", "SettingsView.ConnectedAppleID.type", fallback: "Type")
      internal enum Footer {
        /// Your Apple ID is required to sign the apps you install with SideStore.
        internal static let p1 = L10n.tr("Localizable", "SettingsView.ConnectedAppleID.Footer.p1", fallback: "Your Apple ID is required to sign the apps you install with SideStore.")
        /// Your credentials are only sent to Apple's servers and are not accessible by the SideStore Team. Once successfully logged in, the login details are stored securely on your device.
        internal static let p2 = L10n.tr("Localizable", "SettingsView.ConnectedAppleID.Footer.p2", fallback: "Your credentials are only sent to Apple's servers and are not accessible by the SideStore Team. Once successfully logged in, the login details are stored securely on your device.")
      }
    }
    internal enum ResetAdiPb {
      /// The adi.pb file is used to generate anisette data, which is required to log into an Apple ID. If you are having issues with account related things, you can try this. However, you will be required to do 2FA again. This will do nothing if you are using an older anisette server.
      internal static let description = L10n.tr("Localizable", "SettingsView.ResetAdiPb.description", fallback: "The adi.pb file is used to generate anisette data, which is required to log into an Apple ID. If you are having issues with account related things, you can try this. However, you will be required to do 2FA again. This will do nothing if you are using an older anisette server.")
      /// Are you sure you want to reset the adi.pb file?
      internal static let title = L10n.tr("Localizable", "SettingsView.ResetAdiPb.title", fallback: "Are you sure you want to reset the adi.pb file?")
    }
    internal enum ResetPairingFile {
      /// If you are having issues with SideStore not being able to install/refresh apps or enable JIT, you can try resetting the pairing file. You will need to generate a new pairing file after doing this. SideStore will close when the file has been deleted.
      internal static let description = L10n.tr("Localizable", "SettingsView.ResetPairingFile.description", fallback: "If you are having issues with SideStore not being able to install/refresh apps or enable JIT, you can try resetting the pairing file. You will need to generate a new pairing file after doing this. SideStore will close when the file has been deleted.")
      /// Are you sure to reset the pairing file?
      internal static let title = L10n.tr("Localizable", "SettingsView.ResetPairingFile.title", fallback: "Are you sure to reset the pairing file?")
    }
  }
  internal enum SourcesView {
    /// Done
    internal static let done = L10n.tr("Localizable", "SourcesView.done", fallback: "Done")
    /// Remove
    internal static let remove = L10n.tr("Localizable", "SourcesView.remove", fallback: "Remove")
    /// SideStore has reviewed these sources to make sure they meet our safety standards.
    internal static let reviewedText = L10n.tr("Localizable", "SourcesView.reviewedText", fallback: "SideStore has reviewed these sources to make sure they meet our safety standards.")
    /// Sources
    internal static let sources = L10n.tr("Localizable", "SourcesView.sources", fallback: "Sources")
    /// SourcesView
    internal static let sourcesDescription = L10n.tr("Localizable", "SourcesView.sourcesDescription", fallback: "Sources control what apps are available to download through SideStore.")
    /// Trusted Sources
    internal static let trustedSources = L10n.tr("Localizable", "SourcesView.trustedSources", fallback: "Trusted Sources")
  }
  internal enum UnstableFeaturesView {
    /// Unstable Features are features that are currently being tested or still a work-in-progress and not ready for public usage. Because of this, they are only available on nightly builds, PR builds and debug builds. By default, all unstable features are off. Additionally, only more stable unstable features are available in Advanced Settings; most are locked behind Developer Mode to ensure normal users don't use them as they could contain .
    /// 
    /// Every unstable feature has a tracking issue, which contains info on what the unstable feature adds and tracks the unstable feature status. To view a tracking issue for an unstable feature, simply click it in the list. **Please use the tracking issue for reporting bugs or giving feedback.**
    /// 
    /// **Do not ask for support on using unstable features, you will not receive any help.**
    internal static let description = L10n.tr("Localizable", "UnstableFeaturesView.description", fallback: "Unstable Features are features that are currently being tested or still a work-in-progress and not ready for public usage. Because of this, they are only available on nightly builds, PR builds and debug builds. By default, all unstable features are off. Additionally, only more stable unstable features are available in Advanced Settings; most are locked behind Developer Mode to ensure normal users don't use them as they could contain .\n\nEvery unstable feature has a tracking issue, which contains info on what the unstable feature adds and tracks the unstable feature status. To view a tracking issue for an unstable feature, simply click it in the list. **Please use the tracking issue for reporting bugs or giving feedback.**\n\n**Do not ask for support on using unstable features, you will not receive any help.**")
    /// There are currently no unstable features available.
    internal static let noUnstableFeatures = L10n.tr("Localizable", "UnstableFeaturesView.noUnstableFeatures", fallback: "There are currently no unstable features available.")
    /// UnstableFeaturesView
    internal static let title = L10n.tr("Localizable", "UnstableFeaturesView.title", fallback: "Unstable Features")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
