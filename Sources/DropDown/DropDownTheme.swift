//
//  DropDownTheme.swift
//  DropDown
//
//  Created by Giorgos Pallikaropoulos on 24/12/25.
//

import SwiftUI

public struct DropDownTheme{
    let backgroundColor:Color
    let selectionColor:Color
    let borderColor:Color
    let radius:CGFloat
    let font:Font
    let textColor:Color
    let iconColor:Color
    let insets:EdgeInsets
    
    public init(
        backgroundColor:Color = Color(.systemBackground),
        selectionColor:Color = .gray,
        borderColor:Color = .gray,
        radius:CGFloat = 8,
        font:Font = .system(size: 17, weight: .medium, design: .default),
        textColor:Color = .primary,
        iconColor:Color = .primary,
        insets:EdgeInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
    
    )
    {
        self.backgroundColor = backgroundColor
        self.selectionColor = selectionColor
        self.borderColor = borderColor
        self.radius = radius
        self.font = font
        self.textColor = textColor
        self.iconColor = iconColor
        self.insets = insets
    }
    
    public static let standard:DropDownTheme = .init()

}


// MARK: - Environment extensions




