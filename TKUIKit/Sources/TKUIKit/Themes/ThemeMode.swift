import Foundation

public enum ThemeMode: String, CaseIterable {
  case system
  case blue
  case dark
  
  public var title: String {
    switch self {
    case .system:
      return "System"
    case .blue:
      return "Blue"
    case .dark:
      return "Dark"
    }
  }
  
  public static var notificationUserInfoKey: String {
    "ThemeMode"
  }
}

public extension Notification.Name {
  static var didChangeThemeMode: Notification.Name {
    Notification.Name("TKUIKit_DidChangeThemeMode")
  }
}
