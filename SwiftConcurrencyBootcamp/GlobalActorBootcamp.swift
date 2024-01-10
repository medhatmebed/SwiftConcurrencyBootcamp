//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Medhat Mebed on 1/10/24.
//

import SwiftUI

@globalActor final class MyfirstGlobalActor {
    
    static var shared = MyNewDataManager()
    
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three"]
    }
    
}


class GlobalActorBootcampViewModel: ObservableObject {
    
    @Published var dataArray = [String]()
    let manager = MyfirstGlobalActor.shared
    @MyfirstGlobalActor
    func getData() {
        // HEAVY COMPLEX METHODS
        Task {
            self.dataArray = await manager.getDataFromDatabase()
        }
    }
    
}

struct GlobalActorBootcamp: View {
    
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
            .task {
                await viewModel.getData()
            }
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
