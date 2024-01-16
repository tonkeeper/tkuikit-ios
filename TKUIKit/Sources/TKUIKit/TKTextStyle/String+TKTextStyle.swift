import Foundation
import UIKit.NSParagraphStyle

public extension String {
  func withTextStyle(_ textStyle: TKTextStyle,
                     color: UIColor,
                     alignment: NSTextAlignment = .left,
                     lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> NSAttributedString {    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = textStyle.lineHeight
    paragraphStyle.maximumLineHeight = textStyle.lineHeight
    paragraphStyle.alignment = alignment
    paragraphStyle.lineBreakMode = lineBreakMode
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: textStyle.font,
      .foregroundColor: color,
      .paragraphStyle: paragraphStyle,
      .baselineOffset: (textStyle.lineHeight - textStyle.font.lineHeight)/2
    ]
    let string = textStyle.uppercased ? uppercased() : self
    return NSAttributedString(string: string, attributes: attributes)
  }
}
