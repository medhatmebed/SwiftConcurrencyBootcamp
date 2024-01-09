//
//  ActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Medhat Mebed on 1/9/24.
//

import SwiftUI

class MyDataManager {
    
    static let instance = MyDataManager()
    private init() { }
    
    var data = [String]()
    private let lock = DispatchQueue(label: "TestDispatch")
    
    func getRandomData(completionHandler: @escaping (String?) -> ()) {
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
    
    nonisolated
    func getSavedData() -> String {
        return "non isolated func"
    }
}

actor MyActorDataManager {
    
    static let instance = MyActorDataManager()
    private init() { }
    
    var data = [String]()
    
    func getRandomData() -> String? {
        
            self.data.append(UUID().uuidString)
            print(Thread.current)
            return self.data.randomElement()
        
    }
}

struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
            Task {
                if let data = await manager.getRandomData() {
//                    DispatchQueue.main.async {
//                        self.text = data
//                    }
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        })
    }
}
struct BrowseView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
            Task {
                if let data = await manager.getRandomData() {
//                    DispatchQueue.main.async {
//                        self.text = data
//                    }
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        })

    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsBootcamp()
}
