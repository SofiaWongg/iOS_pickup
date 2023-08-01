//
//  CategoryPill.swift
//  Landmarks
//
//  Created by Sofia Wong on 7/31/23.
//

import SwiftUI


struct CategoryPill: View {
    
    var categoryName: String
    var fontSize: CGFloat = 12.0
    
    var body: some View {
        ZStack {
            Text(categoryName)
                .font(.system(size: fontSize, weight: .regular))
                .lineLimit(2)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.green)
                .cornerRadius(5)
        }
    }
}

struct CategoryPill_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPill(categoryName: "Hello")
    }
}
