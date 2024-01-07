//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Medhat Mebed on 1/7/24.
//

import SwiftUI

class DoCatchTryThrowsDataManager {
    
    let isActive = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEw Text", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Text2")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitile3() throws -> String {
        if isActive {
            return "New Text 3"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitile4() throws -> String {
        if isActive {
            return "Final Text"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
}

class DoCatchTryThrowsBootcampViewModel: ObservableObject{
    
    @Published var text = "Starting Text"
    let manager = DoCatchTryThrowsDataManager()
    
    func fetchTitile() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
        
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        /// note that try? means that you don't care about throwing and error... bubt try without question mark means you gonna handle the error if it throws one
        
        do {
            let newTitle = try manager.getTitile3()
            self.text = newTitle
            
            let finalTitle = try manager.getTitile4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
        
    }
   
    
    
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitile()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
