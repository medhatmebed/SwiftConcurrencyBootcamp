//
//  TaskGroubBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Medhat Mebed on 1/9/24.
//

import SwiftUI

class TaskGroupDataManager {
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(url: "https://picsum.photos/300")
        async let fetchImage2 = fetchImage(url: "https://picsum.photos/300")
        async let fetchImage3 = fetchImage(url: "https://picsum.photos/300")
        async let fetchImage4 = fetchImage(url: "https://picsum.photos/300")
        
        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
        return [image1, image2, image3, image4]
    }
    
    private func fetchImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url)
        else { throw URLError(.badURL)}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
        
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        
        let urlStrings = [
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300"]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images = [UIImage]()
            
            for urlString in urlStrings {
                group.addTask {
                    try? await self.fetchImage(url: urlString)
                }
            }
            
//            group.addTask {
//                try await self.fetchImage(url: "https://picsum.photos/300")
//            }
//            group.addTask {
//                try await self.fetchImage(url: "https://picsum.photos/300")
//            }
//            group.addTask {
//                try await self.fetchImage(url: "https://picsum.photos/300")
//            }
//            group.addTask {
//                try await self.fetchImage(url: "https://picsum.photos/300")
//            }
        
        
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
}


class TaskGroupViewModel: ObservableObject {
    
    @Published var images = [UIImage]()
    let manager = TaskGroupDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images = images
        }
    }
    
}

struct TaskGroubBootcamp: View {
    
    @StateObject private var viewModel = TaskGroupViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, content: {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                })
                .navigationTitle("Task Group")
                .task {
                    await viewModel.getImages()
                }
            }
        }
    }
}

#Preview {
    TaskGroubBootcamp()
}
