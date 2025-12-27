//
//  View+applyTheme.swift
//  DropDown
//
//  Created by Giorgos Pallikaropoulos on 24/12/25.
//

import SwiftUI

public extension View {
    func applyTheme(_ theme:DropDownTheme) -> some View {
        environment(\.dropDownTheme, theme)
    }
}
