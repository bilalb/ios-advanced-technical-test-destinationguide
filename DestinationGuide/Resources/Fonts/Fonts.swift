//
//  Fonts.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 18/07/2022.
//

import UIKit
import SwiftUI

public enum EvaneosFont {
    case defaultLExtrabold
    case defaultMExtrabold
    case defaultBodyBold
    case defaultBodyRegular
    case defaultXsBold
    case defaultXsRegular
    case defaultBodyLink
    case defaultXsLink
    
    enum AvertaFontWeight {
        case light
        case regular
        case semiBold
        case bold
        case extraBold
        
        var fontSystemName: String {
            switch self {
            case .light: return "Averta-Light"
            case .regular: return "Averta-Regular"
            case .semiBold: return "Averta-SemiBold"
            case .bold: return "Averta-Bold"
            case .extraBold: return "Averta-ExtraBold"
            }
        }
    }
    
    public var font: UIFont {
        switch self {
        case .defaultLExtrabold: return UIFont.averta(weight: .extraBold, size: 38)
        case .defaultMExtrabold: return UIFont.averta(weight: .extraBold, size: 24)
        case .defaultBodyBold: return UIFont.averta(weight: .bold, size: 18)
        case .defaultBodyRegular: return UIFont.averta(weight: .regular, size: 18)
        case .defaultXsBold: return UIFont.averta(weight: .bold, size: 16)
        case .defaultXsRegular: return UIFont.averta(weight: .regular, size: 16)
        case .defaultBodyLink: return UIFont.averta(weight: .bold, size: 18)
        case .defaultXsLink: return UIFont.averta(weight: .bold, size: 16)
        }
    }
    
    public var lineHeightFromDesignSystem: CGFloat {
        switch self {
        case .defaultLExtrabold: return 36
        case .defaultMExtrabold: return 28
        case .defaultBodyBold, .defaultBodyRegular, .defaultXsBold, .defaultXsRegular, .defaultBodyLink, .defaultXsLink: return 24
        }
    }
}

extension UIFont {
    static func averta(weight: EvaneosFont.AvertaFontWeight, size: CGFloat) -> UIFont {
        return UIFont(name: weight.fontSystemName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
    }
}

struct DesignSystemFontModifier: ViewModifier {
    let designSystemFont: EvaneosFont
    
    func body(content: Content) -> some View {
        content
            .font(Font(designSystemFont.font))
            .lineSpacing(designSystemFont.lineHeightFromDesignSystem - designSystemFont.font.lineHeight)
            .padding(.vertical, (designSystemFont.lineHeightFromDesignSystem - designSystemFont.font.lineHeight) / 2)
    }
}

public extension View {
    func font(designSystemFont: EvaneosFont) -> some View {
        ModifiedContent(content: self, modifier: DesignSystemFontModifier(designSystemFont: designSystemFont))
    }
}
