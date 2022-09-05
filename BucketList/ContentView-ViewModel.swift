//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Shubham Rawal on 05/09/22.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        @Published var selectedLocation : Location?
        @Published var isUnlocked = false
        
        
        //document directory where places data needs to be saved in device storage
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init(){
            do{
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        //save data
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
        
        
        //adding new location
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        
        //updating existing location
        func update(location: Location) {
            guard let selectedLocation = selectedLocation else { return }

            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = location
                save()
            }
        }
        
        
        //authentication to unlock
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    success, authenticationError in
                    if success {
                        //this adding of a new task is required because while using faceID/touchID, the control shifts from our app to device task. and on continuation, this 'if-else' codeblock turns into a background task.
//                        Task {
//                            await MainActor.run {
//                                self.isUnlocked = true
//                            }
//                        }
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                        
                    } else {
                        //error
                    }
                }
            } else {
                //no biometrics
            }
        }
    }
}
