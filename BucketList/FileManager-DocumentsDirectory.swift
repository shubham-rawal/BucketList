//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Shubham Rawal on 05/09/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
