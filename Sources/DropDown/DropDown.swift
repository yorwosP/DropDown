//
//  DropDown.swift
//
//
//  Created by Giorgos Pallikaropoulos on 23/12/25.
//

import SwiftUI



/// # DropDown
///
/// a  drop down list component
///
/// ## initializer
///
/// - ``init(_:options:selectedOption:isExpanded:)``
///
/// - important: when placing the dropdown in a view it is important that its z-index is higher than the views it may
/// overlap in expanded state, so that it will appear above these views when expanded.
///
/// - important: to "dismiss" (i.e collapse) the dropdown list by tapping outside the view, a tag gesture recognizer
/// should be placed to the parent view. that will set isExpanded to false

public struct DropDown: View {
    @Environment(\.font) private var font
    @Environment(\.dropDownTheme) private var theme
    private var padding:CGFloat = 8
    public var title:String
    public var options: [DropDownOption]
    
    @Binding  var selectedOption: DropDownOption?
    // passing this as a Binding so that the parent view can control it (e.g tap to dismiss)
    @Binding  var isExpanded: Bool
    // setting the expanded view's frame width to .zero will mean that controls "below" the dropdown won't
    // respond to user interaction. So we need to "remove" (set the opacity to 0) when it is totally collapsed
    // (animation has ended). We use the following variable to track this.
    @State private var shouldHideExpandedViewCompletely:Bool = true

    let animationDuration: Double = 0.3
    
    /// initializer for DropDown
    /// - Parameters:
    ///   - title: the title to show when no option is selected
    ///   - options: an array of available oprtions
    ///   - selectedOption: a Binding to the DropDownOption that is currently selected (or nil if nothing is selected yet)
    ///   - isExpanded: a Binding indicating the status of the dropwdown (expanded/collapsed)
    public init(
        _ title: String,
        options: [DropDownOption],
        selectedOption: Binding<DropDownOption?>,
        isExpanded: Binding<Bool>
    ) {
        self.title = title
        self.options = options
        self._selectedOption = selectedOption
        self._isExpanded = isExpanded
    }
    
    public var body: some View {
        VStack(alignment: .leading){
            headerView
            expandedView
                .opacity(shouldHideExpandedViewCompletely ? 0 : 1) // setting the opacity to 0, will allow the views below to handle user interaction
        }
        .onAppear {
            // initially set the value of shouldHideCompletely to cover the case where the dropdown starts in expanded state
            shouldHideExpandedViewCompletely = !isExpanded
        }
        .onChange(of: isExpanded) { newValue in
            // if it is collapsed (newValue == true), then we should add the view first, i.e set shouldHideCompletely to false.
            // otherwise we should remove the view AFTER the animation is done
            if newValue == true {
                shouldHideExpandedViewCompletely = false
            }else{
                // we use a "delay" to change the value, because prior to ios 17 we don't have completion handler for withAnimation
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    shouldHideExpandedViewCompletely = !isExpanded
                }
            }
        }
        .animation(.easeInOut(duration: animationDuration), value: isExpanded)

        
    }

    
    @ViewBuilder
    private var headerView: some View {
        HStack{
            Text(selectedOption?.title ?? title)
                .animation(.smooth, value: selectedOption)
                .font(theme.font)
                .foregroundStyle(theme.textColor)
            Spacer()
            Image(systemName: "chevron.down.circle.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(theme.iconColor)
                .rotationEffect(.degrees((isExpanded ?  180 : 0)))
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isExpanded.toggle()
            }
        }
        .padding(theme.insets)
        .background(
            RoundedRectangle(cornerRadius: theme.radius)
                .fill(theme.backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: theme.radius)
                .stroke(
                    theme.borderColor,
                    // TODO: consider showing the border color on expansion. e.g
//                    isExpanded ? theme.borderColor :
//                        theme.backgroundColor,
                    lineWidth: 1
                )
        )
    }
    
    
    @ViewBuilder
    private var expandedView: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 0){
                
                ForEach(options, id: \.self) { option in
                    HStack {
                        Text(option.title)
                        // TODO: - provide the option to define line spacing (vertical padding)
                            .padding(.vertical, 8)
                        // we keep half the horizontal padding inside so that there is some space
                        // between the selection color and the edges. the rest is applied externally on the VStack
                            .padding(.leading, theme.insets.leading/2)
                            .padding(.trailing, theme.insets.trailing/2)
                        Spacer()
                    }
                    .background( option == selectedOption ? theme.selectionColor : Color.clear )
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius))
                    .contentShape(Rectangle()) // make the whole row tappable
                    .onTapGesture {
                        selectedOption = option
                        
                        withAnimation(.smooth(duration:animationDuration)) {
                            //                            isAnimating = true // if expanded it means that collapsing is about to start
                            isExpanded.toggle()
                        }
                    }
                }
            }
            .padding(.leading, theme.insets.leading/2)
            .padding(.trailing, theme.insets.trailing/2)
            .padding(.top, theme.insets.top)
            .padding(.bottom, theme.insets.bottom)

        }
        
        // allow interaction only when expanded by setting the opacity to zero when not
        .opacity(isExpanded ? 1 : 0)
        
        .font(theme.font)
        .background(theme.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: theme.radius)
                .stroke(
                    isExpanded ?
                    theme.borderColor :
                        theme.backgroundColor,
                    lineWidth: 2
                )
        )
        
        // need to clip so that the background does not "bleed" past the border
        .clipShape(RoundedRectangle(cornerRadius: isExpanded ? theme.radius : 0))
        
        // we use a mask to gradually reveal/hide the expanded view
        .mask{
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: theme.radius)
                    .frame(width: proxy.size.width, height: isExpanded ? proxy.size.height : 0, alignment: .top)
                    .transition(.scaleVertically)
            }
        }
        // we set the height to 0 so that the view overflows
        // overlays siblings, instead of pushing them
        .frame(height:0, alignment: .top)
        // TODO: - consider providing shadow option. e.g
        //        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 5)
        
    }
}

// MARK: - Previews

struct DropDownPreview:View{

    @State private var isExpanded = false
    @State private var toggleIsOn = false
    private var options:[DropDownOption] = [
        .init(id: "1", title: "Option 1"),
        .init(id: "2", title: "Option 2"),
        .init(id: "3", title: "Option 3")
    ]
    
    private let customTheme = DropDownTheme(selectionColor: .orange, iconColor: .orange)
    
    @State private var selectedOption: DropDownOption? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                DropDown("Select from the list", options: options, selectedOption: $selectedOption, isExpanded: $isExpanded)
                    .applyTheme(customTheme)
            }
            .zIndex(1)
            Text("Your choise: \(selectedOption?.title ?? "-")")
                .font(.body)
                .padding()
            Spacer()
        }
        .background()

        
//        .background(Color.white)
        .onTapGesture {
            withAnimation {
                isExpanded = false
            }
        }
    }
}

#Preview("customized theming") {
    VStack{
        DropDownPreview()
        Spacer()
    }
    .padding()
    
    
}



