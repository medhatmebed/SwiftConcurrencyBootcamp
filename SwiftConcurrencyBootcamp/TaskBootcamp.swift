//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Medhat Mebed on 1/8/24.
//

import SwiftUI


class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    self.image = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    self.image2 = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchImage()
               
            }
//            Task {
//                await viewModel.fetchImage2()
//            }
            Task(priority: .high) {
                await viewModel.fetchImage2()
            }
        }
    }
}

#Preview {
    TaskBootcamp()
}
