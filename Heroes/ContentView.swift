//
//  ContentView.swift
//  Heroes
//
//  Created by Edoardo on 18/07/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
     
            Text(
                "Hello, world \n\nwe are heroic!!!!!!")
                .textCase(.uppercase)
                .font(.largeTitle)
                .multilineTextAlignment(.center)


                
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
