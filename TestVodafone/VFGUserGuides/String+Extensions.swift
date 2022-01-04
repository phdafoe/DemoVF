//
//  String+Extensions.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUI

public extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func size(with font: UIFont) -> CGSize {
        var titleRect: CGRect?
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        titleRect = self.boundingRect(
            with: CGSize(width: Int.max, height: Int.max),
            options: .usesLineFragmentOrigin,
            attributes: [
                NSAttributedString.Key.font: font
            ],
            context: nil)
        if let titleRectWidth = titleRect?.size.width,
        let titleRectHeight = titleRect?.size.height {
            width = titleRectWidth
            height = titleRectHeight
        }
        return CGSize(width: width, height: height)
    }

    func replaceWithBlank(find key: String) -> String {
        return replacingOccurrences(of: key, with: "")
    }

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    var removeNewLines: String {
        return replacingOccurrences(of: "\\n", with: "")
    }

    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

    func attributedTextFrom(htmlText: String, fontSize: CGFloat, color: UIColor) -> NSMutableAttributedString? {
        let baseFont = UIFont.vodafoneRegular(fontSize)
        guard
            let fontName = baseFont.fontName as NSString?
        else {
            return nil
        }
        let modifiedFont = String(
            format: "<span style=\"font-family: '\(fontName)'; font-size: \(baseFont.pointSize)\">%@</span>", htmlText)

        do {
            guard let data = modifiedFont.data(using: .unicode, allowLossyConversion: true) else {
                return nil
            }
            let attributedText = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            attributedText.addAttribute(textColor: color)
            return attributedText
        } catch {
           // VFGDebugLog("Error getting attributed text from html: \(error)")
            return nil
        }
    }

    func addBoldText(boldPartOfString: String, baseFont: UIFont, baseColor: UIColor, boldFont: UIFont, boldColor: UIColor) -> NSAttributedString {
        let baseAttributes = [
            NSAttributedString.Key.font: baseFont,
            NSAttributedString.Key.foregroundColor: baseColor
        ]
        let boldAttributes = [
            NSAttributedString.Key.font: boldFont,
            NSAttributedString.Key.foregroundColor: boldColor
        ]
        let attributedString = NSMutableAttributedString(string: self, attributes: baseAttributes)
        attributedString.addAttributes(
            boldAttributes,
            range: NSRange(
                self.range(of: boldPartOfString) ?? self.startIndex..<self.endIndex,
                in: self
            )
        )
        return attributedString
    }
}


enum FontSizeType: String {
    case pt
    case px
}

extension String {
    /*func convertToHtml(fontSize: Float = 16, fontSizeType: FontSizeType = .pixel, fontName: String = "Vodafone Rg", color: UIColor? = nil, paragraphSpacing: CGFloat = 0, alignment: NSTextAlignment = NSTextAlignment.left ) -> NSMutableAttributedString? {
        let siz = fontSize
        let raw = fontSizeType.rawValue
        let styleText = """
            <html> <head> <style type='text/css'> body { \
        font: \(siz)\(raw) '\(fontName)'} p { line-height: 5.1 }</style></head> <body>
        """
        let html = styleText + self
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                let documentType = NSAttributedString.DocumentType.html
                let options = [NSAttributedString.DocumentReadingOptionKey.documentType: documentType]
                let attText = try NSMutableAttributedString(data: htmlData, options: options, documentAttributes: nil)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.paragraphSpacing = paragraphSpacing
                paragraphStyle.alignment = alignment
                if color == nil {
                    let range = NSRange(location: 0, length: attText.length)
                    attText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: range)
                } else {
                    let style = NSAttributedString.Key.paragraphStyle
                    let attributes = [style: paragraphStyle, NSAttributedString.Key.foregroundColor: color]
                    let range = NSRange(location: 0, length: attText.length)
                    attText.addAttributes(attributes as [NSAttributedString.Key: Any], range: range)
                }
                return attText
            } catch _ as NSError {
                print("Couldn't translate")
            }
        }
        return NSMutableAttributedString()
    }*/
    func convertToHtml(fontSize: Int = 16 ,fontSizeType: FontSizeType = .px, fontName: String = "Vodafone Rg" ,color : UIColor? = nil , paragraphSpacing : CGFloat = 0, alignment: NSTextAlignment = NSTextAlignment.left ) -> NSMutableAttributedString?{
        let styleText = "<html> <head> <style type='text/css'> body { font-family: '\(fontName)'; font-size: \(fontSize)\(fontSizeType.rawValue);} p { line-height: 5.1 }</style></head> <body>"
        let html = styleText + self
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                let attributedText = try NSMutableAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.paragraphSpacing = paragraphSpacing
                paragraphStyle.alignment = alignment
                
                if color == nil {
                    attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedText.length))
                }
                else {
                    attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle , NSAttributedString.Key.foregroundColor : color!], range: NSMakeRange(0, attributedText.length))
                }
                
                return attributedText
            } catch _ as NSError {
                print("Couldn't translate")
            }
        }
        return NSMutableAttributedString()
    }
}
