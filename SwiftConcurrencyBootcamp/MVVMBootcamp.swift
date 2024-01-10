//
//  MVVMBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Medhat Mebed on 1/10/24.
//

import SwiftUI

final class MyManagerClass {
    
    func getData() async throws -> String {
        "Some Data!"
    }
    
}

actor MyManagerActor {
    func getData() async throws -> String {
        "Some Data!"
    }
}
@MainActor
final class MVVMBootcampViewModel: ObservableObject {
    
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    @Published private(set) var myData = "Starting Text"
    private var tasks = [Task<Void, Never>]()
    
    func cancelTask() {
        tasks.forEach({ $0.cancel() })
    }
  //  @MainActor
    func onCallToActionButtonPressed() {
        let task = Task {
            do {
                myData = try await managerClass.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
    
}

struct MVVMBootcamp: View {
    
    @StateObject private var viewModel = MVVMBootcampViewModel()
    
    var body: some View {
        VStack {
            Button(viewModel.myData) {
                viewModel.onCallToActionButtonPressed()
            }
        }
    }
}

#Preview {
    MVVMBootcamp()
}
