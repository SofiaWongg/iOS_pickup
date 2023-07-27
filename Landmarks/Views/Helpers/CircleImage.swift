//
//  CirclaImage.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/5/23.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.brown, lineWidth: 4)
            }
            .shadow(radius: 7.5)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("TurtleRock"))
    }
}
