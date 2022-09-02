//
//  ContentView.swift
//  BucketList
//
//  Created by Shubham Rawal on 31/08/22.
//

import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data" //for touch id reason
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    //there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
