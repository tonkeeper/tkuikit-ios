import UIKit

public extension UIImage {
  enum TKUIKit {
    public enum Icons {
      public enum Size16 {
        public static var chevronDown: UIImage {
          .imageWithName("Icons/16/ic-chevron-down-16")
          .withRenderingMode(.alwaysTemplate)
        }
        public static var chevronLeft: UIImage {
          .imageWithName("Icons/16/ic-chevron-left-16")
          .withRenderingMode(.alwaysTemplate)
        }
        public static var close: UIImage {
          .imageWithName("Icons/16/ic-close-16")
          .withRenderingMode(.alwaysTemplate)
        }
        public static var globe: UIImage {
          .imageWithName("Icons/16/ic-globe-16")
          .withRenderingMode(.alwaysTemplate)
        }
      }
      public enum Size28 {
        public static var qrViewFinder: UIImage {
          .imageWithName("Icons/28/ic-qr-viewfinder-28")
          .withRenderingMode(.alwaysTemplate)
        }
      }
    }
  }
}
