// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Bridge {
    /// Настройте мост для подключения к Tor
    internal static let configureBridge = L10n.tr("Localizable", "bridge.configureBridge")
    /// Текущий настроенный мост
    internal static let currentBridge = L10n.tr("Localizable", "bridge.currentBridge")
    /// Не настроен
    internal static let notConfigured = L10n.tr("Localizable", "bridge.notConfigured")
    /// Использовать мост
    internal static let specifyBridge = L10n.tr("Localizable", "bridge.specifyBridge")
    /// Укажите данные моста из доверенного источника
    internal static let specifyBridgeData = L10n.tr("Localizable", "bridge.specifyBridgeData")
    /// Конфигурация моста
    internal static let title = L10n.tr("Localizable", "bridge.title")
    /// Использовать мост
    internal static let useBridge = L10n.tr("Localizable", "bridge.useBridge")
    internal enum TableView {
      internal enum Header {
        /// Мосты - не включенные в списки узлы, затрудняющие блокировку соединений с сетью Tor. Из-за того, что ряд стран пытается заблокировать Tor, некоторые мосты будут работать в одних странах, но могут не работать в других.
        internal static let aboutBridges = L10n.tr("Localizable", "bridge.tableView.header.aboutBridges")
      }
    }
  }

  internal enum Network {
    /// Конфигурация моста
    internal static let bridgeConfiguration = L10n.tr("Localizable", "network.bridgeConfiguration")
    /// Используйте мост для подключения к Tor
    internal static let bridgeDescription = L10n.tr("Localizable", "network.bridgeDescription")
    /// Мосты включены
    internal static let bridgeStatus = L10n.tr("Localizable", "network.bridgeStatus")
    /// Отключен
    internal static let disconnected = L10n.tr("Localizable", "network.disconnected")
    /// Oniony перенаправляет ваш трафик через сеть Tor. Ее поддерживают тысячи добровольцев по всему миру.
    internal static let header = L10n.tr("Localizable", "network.header")
    /// Готовность Tor
    internal static let netowrkStatus = L10n.tr("Localizable", "network.netowrkStatus")
    /// Нет
    internal static let no = L10n.tr("Localizable", "network.no")
    /// Сеть Tor
    internal static let title = L10n.tr("Localizable", "network.title")
    /// Состояние
    internal static let torStatus = L10n.tr("Localizable", "network.torStatus")
    /// Да
    internal static let yes = L10n.tr("Localizable", "network.yes")
    internal enum Tableview {
      internal enum Footer {
        /// Oniony перенаправляет ваш трафик через сеть Tor. Ее поддерживают тысячи добровольцев по всему миру.
        internal static let oniony = L10n.tr("Localizable", "network.tableview.footer.oniony")
      }
      internal enum Header {
        /// Текущий статус
        internal static let currentStatus = L10n.tr("Localizable", "network.tableview.header.currentStatus")
      }
    }
  }

  internal enum Tab {
    /// Потяните, чтобы обновить
    internal static let pullToRefresh = L10n.tr("Localizable", "tab.pullToRefresh")
    /// Введите запрос или адрес
    internal static let searchPlaceholder = L10n.tr("Localizable", "tab.searchPlaceholder")
  }

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
