//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Medhat Mebed on 1/9/24.
//

import SwiftUI

struct StructClassActorBootcamp: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                runTest()
            }
    }
}

#Preview {
    StructClassActorBootcamp()
}

extension StructClassActorBootcamp {
    
    private func runTest() {
        print("Test Started")
    }
}
