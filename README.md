# DropDown

A Swift UI drop down list customizable component.



## Installation

**DropDown requires iOS 	15+**
### Swift Package Manager
- In XCode: File > Add Packages 
- Add  url https://github.com/yorwosP/DropDown


### Manually 
Just copy the folder into your project

## Usage:

DropDown takes following arguments: 

- a title that is displayed when no option is selected. 
- an array of `DropDownOption`s elements.
- a Binding to the `DropDownOption` that is currently selected.
- a Binding to a boolean (`isExpanded`) that controls if the dropdown is currently expanded or collapsed. Setting this boolean to true will expand the dropdown and setting this to false will collapse it. Both transitions are animated. Tapping on the expand/collapse icon and selecting an option will set automatically set this boolean appropriately. To collapse an expanded view by tapping outside of the dropdown, you simply attach an `onTapGesture` modifier to the parent view and change the isExpanded value to false

The DropDown is designed to overlap the view(s) below it when expanded (instead of pushing them down). To ensure that the overlapping views are hidden when the dropdown is expanded you provide a higher zIndex to the dropdown (or its containing view depending on the view hierarchy you have defined)

e.g 
```
import SwiftUI
import DropDown

struct MyView:View{

    @State private var isExpanded = false
    @State private var toggleIsOn = false
    private var options:[DropDownOption] = [
        .init(id: "1", title: "Option 1"),
        .init(id: "2", title: "Option 2"),
        .init(id: "3", title: "Option 3")
    ]
    
    @State private var selectedOption: DropDownOption? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                DropDown("Select from the list", options: options, selectedOption: $selectedOption, isExpanded: $isExpanded)
            }
            .zIndex(1)
            Text("Your choise: \(selectedOption?.title ?? "-")")
                .font(.body)
                .padding()
            Spacer()
        }
        .background()
        .onTapGesture {
            withAnimation {
                isExpanded = false
            }
        }
    }
}
```

## Customization - theming

DropDown appearance can be customized by creating an instance of a DropDownTheme and applying it using the .applyTheme() modifier

Following properties can be customized: 

- backgroundColor  
- selectionColor
- borderColor
- radius
- font
- textColor
- iconColor
- insets

