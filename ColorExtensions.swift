//
//  ColorExtensions.swift
//  Landmarks
//
//  Created by Sofia Wong on 7/31/23.
//

import SwiftUI

extension UIColor {
    static let flatDarkBackground = UIColor(red: 36, green: 36, blue: 36)
    static let flatDarkCardBackground = UIColor(red: 46, green: 46, blue: 46)
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
}

extension Color {
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
    
    public static var flatDarkBackground: Color {
        return Color(decimalRed: 36, green: 36, blue: 36)
    }
    
    public static var flatDarkCardBackground: Color {
        return Color(decimalRed: 46, green: 46, blue: 46)
    }
    
    public static var lightRed: Color {
            return Color(red: 255 / 255, green: 100 / 255, blue: 100 / 255)
        }
        
        public static var darkRed: Color {
            return Color(red: 180 / 255, green: 0 / 255, blue: 0 / 255)
    }
}
