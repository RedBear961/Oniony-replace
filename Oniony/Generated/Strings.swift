// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum TorLoading {
    /// -----Инициализация журнала Tor-----
    internal static let log = L10n.tr("Localizable", "torLoading.log")
    internal enum Tag {
      /// Connecting to a relay to build circuits
      internal static let apConn = L10n.tr("Localizable", "torLoading.tag.ap_conn")
      /// Connected to a relay to build circuits
      internal static let apConnDone = L10n.tr("Localizable", "torLoading.tag.ap_conn_done")
      /// Handshake finished with a relay to build circuits
      internal static let apHandshake = L10n.tr("Localizable", "torLoading.tag.ap_handshake")
      /// Handshake finished with a relay to build circuits
      internal static let apHandshakeDone = L10n.tr("Localizable", "torLoading.tag.ap_handshake_done")
      /// Establishing a Tor circuit
      internal static let circuitCreate = L10n.tr("Localizable", "torLoading.tag.circuit_create")
      /// Connecting to a relay
      internal static let con = L10n.tr("Localizable", "torLoading.tag.con")
      /// Connected to a relay
      internal static let connDone = L10n.tr("Localizable", "torLoading.tag.conn_done")
      /// Done
      internal static let done = L10n.tr("Localizable", "torLoading.tag.done")
      /// Loaded enough directory info to build circuits
      internal static let enoughDirinfo = L10n.tr("Localizable", "torLoading.tag.enough_dirinfo")
      /// Handshaking with a relay
      internal static let handshake = L10n.tr("Localizable", "torLoading.tag.handshake")
      /// Handshake with a relay done
      internal static let handshakeDone = L10n.tr("Localizable", "torLoading.tag.handshake_done")
      /// Loading relay descriptors
      internal static let loadingDescriptors = L10n.tr("Localizable", "torLoading.tag.loading_descriptors")
      /// Loading authority key certs
      internal static let loadingKeys = L10n.tr("Localizable", "torLoading.tag.loading_keys")
      /// Loading networkstatus consensus
      internal static let loadingStatus = L10n.tr("Localizable", "torLoading.tag.loading_status")
      /// Establishing an encrypted directory connection
      internal static let onehopCreate = L10n.tr("Localizable", "torLoading.tag.onehop_create")
      /// Asking for relay descriptors
      internal static let requestingDescriptors = L10n.tr("Localizable", "torLoading.tag.requesting_descriptors")
      /// Asking for network status consensus
      internal static let requestingStatus = L10n.tr("Localizable", "torLoading.tag.requesting_status")
    }
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
