//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Leong Zhe Cheng on 29/04/2022.
//

import Foundation

extension FileManager {
    
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
