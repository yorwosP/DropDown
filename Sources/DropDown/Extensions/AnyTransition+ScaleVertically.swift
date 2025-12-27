//
//  AnyTransition+ScaleVertically.swift
//  DropDown
//
//  Created by Giorgos Pallikaropoulos on 24/12/25.
//
import SwiftUI

extension AnyTransition {
    static var scaleVertically: AnyTransition {
        .modifier(
            active: ScaleEffectModifier(scaleY: 0, anchor: .top),
            identity: ScaleEffectModifier(scaleY: 1, anchor: .top)
        )
    }
}

struct ScaleEffectModifier: ViewModifier {
    let scaleY: CGFloat
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .scaleEffect(x: 1, y: scaleY, anchor: anchor)
//            .clipped()
    }
}

