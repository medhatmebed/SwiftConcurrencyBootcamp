//
//  ReferencesBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Medhat Mebed on 1/10/24.
//

import SwiftUI

final class ReferencesBootcampDataService {
    
    func getData() async -> String {
        "Updated Data!"
    }
}

final class ReferencesBootcampViewModel: ObservableObject {
    
    @Published var data = "some title"
    let dataService = ReferencesBootcampDataService()
    private var someTask: Task<Void, Never>? = nil
    
    func cancelTasks() {
        someTask?.cancel()
    }
    func updateData()  {
          Task {
            data = await dataService.getData()
        }
    }
    
    func updateData2() {
        someTask = Task {
            data = await dataService.getData()
        }
    }
    
    
}

struct ReferencesBootcamp: View {
    
    @StateObject private var viewModel = ReferencesBootcampViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData2()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
    }
}

#Preview {
    ReferencesBootcamp()
}
