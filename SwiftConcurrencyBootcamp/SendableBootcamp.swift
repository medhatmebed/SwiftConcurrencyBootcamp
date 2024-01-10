//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Medhat Mebed on 1/10/24.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: String) {
        
    }
    
}

class SendableBootcampViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        let info = "User Info"
        await manager.updateDatabase(userInfo: info)
    }
    
}

struct SendableBootcamp: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SendableBootcamp()
}
