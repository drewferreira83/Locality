//
//  JXError.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/27/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import Foundation

struct JXError: Decodable {
    let title: String?
    let status: String?
    let code: String?
    let detail: String?
    let source: [String:String]?
}
