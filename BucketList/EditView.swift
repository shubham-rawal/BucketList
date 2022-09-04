//
//  EditView.swift
//  BucketList
//
//  Created by Shubham Rawal on 05/09/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location : Location
    var onSave : (Location) -> Void
    
    
    @State private var name : String
    @State private var description : String
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    //we have told the Location class that the objects having the same id are the same objects, so if we do not update the id of the newLocation, we would end up with the same object as before and it would not update.
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }
    
    //the @escaping keyword is used to escape the calling of the function from when it is initialised to later in the code, where it is actually called. However, the function needs to be initialised somewhere else (for eg in this case the ContentView)
    init(location : Location, onSave : @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in
            
        }
    }
}
