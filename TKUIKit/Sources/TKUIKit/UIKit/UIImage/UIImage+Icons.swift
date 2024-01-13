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
        public static var wallet: UIImage {
          .imageWithName("Icons/28/ic-wallet-28")
          .withRenderingMode(.alwaysTemplate)
        }
        public static var purchase: UIImage {
          .imageWithName("Icons/28/ic-purchases-28")
          .withRenderingMode(.alwaysTemplate)
        }
        public static var clock: UIImage {
          .imageWithName("Icons/28/ic-clock-28")
          .withRenderingMode(.alwaysTemplate)
        }
        public static var gear: UIImage {
          .imageWithName("Icons/28/ic-gear-28")
          .withRenderingMode(.alwaysTemplate)
        }
      }
      public enum Size36 {
        public static var delete: UIImage {
          .imageWithName("Icons/36/ic-delete-36")
          .withRenderingMode(.alwaysTemplate)
        }
        public static var faceid: UIImage {
          .imageWithName("Icons/36/ic-faceid-36")
          .withRenderingMode(.alwaysTemplate)
        }
        public static var fingerprint: UIImage {
          .imageWithName("Icons/36/ic-fingerprint-36")
          .withRenderingMode(.alwaysTemplate)
        }
      }
    }
  }
}
