//
//  FirstScreenDemo().swift
//  
//
//  Created by Rafael Antonio Chinelatto on 23/01/24.
//

import Foundation
import SwiftUI

struct StartScreen: View {
    @State var start: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                Button("Start") {
                    start = true
                }
                .buttonStyle(.bordered)
                .font(.largeTitle)
                Spacer()
                    .navigationDestination(isPresented: $start) {
                        FirstScreen()
                            .navigationBarBackButtonHidden()
                    }
            }
        }
    }
}