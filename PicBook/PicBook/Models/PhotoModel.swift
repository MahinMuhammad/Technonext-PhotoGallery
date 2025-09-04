//
//  PhotoModel.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/4/25.
//

import Foundation

struct PhotoModel: Decodable, Identifiable{
    let id: String
    let author: String?
    let downloadURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id, author
        case downloadURL = "download_url"
    }
}
