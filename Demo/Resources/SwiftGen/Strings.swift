// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Common {
    /// OK
    internal static let ok = L10n.tr("Common", "OK")
    /// Retry
    internal static let retry = L10n.tr("Common", "Retry")
  }
  internal enum Error {
    /// Requesting asset not found
    internal static let assetNotFoundErrorMessage = L10n.tr("Error", "AssetNotFoundErrorMessage")
    /// Not Found
    internal static let assetNotFoundErrorTitle = L10n.tr("Error", "AssetNotFoundErrorTitle")
    /// Please try again later
    internal static let loadingErrorMessage = L10n.tr("Error", "LoadingErrorMessage")
    /// Failed to load
    internal static let loadingErrorTitle = L10n.tr("Error", "LoadingErrorTitle")
    /// Your network connection seems offline
    internal static let networkErrorMessage = L10n.tr("Error", "NetworkErrorMessage")
    /// Network Connection
    internal static let networkErrorTitle = L10n.tr("Error", "NetworkErrorTitle")
    /// Please login again
    internal static let sessionTimeoutMessage = L10n.tr("Error", "SessionTimeoutMessage")
    /// Session Timeout
    internal static let sessionTimeoutTitle = L10n.tr("Error", "SessionTimeoutTitle")
    /// An unexpected error occurred
    internal static let unknownErrorMessage = L10n.tr("Error", "UnknownErrorMessage")
    /// Unknown Connection
    internal static let unknownErrorTitle = L10n.tr("Error", "UnknownErrorTitle")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
