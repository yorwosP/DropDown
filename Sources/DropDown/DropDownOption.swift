//
//  DropDownOption.swift
//  DropDown
//
//  Created by Giorgos Pallikaropoulos on 24/12/25.
//


public struct DropDownOption:Equatable, Hashable{
    public var id:String
    public var title:String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
