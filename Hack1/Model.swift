//
//  Model.swift
//  Hack1
//
//  Created by Mikhail Kolkov  on 12.07.2020.
//  Copyright © 2020 MKM.LLC. All rights reserved.
//

import Foundation

struct Test: Codable {
    let data: [Datum]
    let message, status: String
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.datumTask(with: url) { datum, response, error in
//     if let datum = datum {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Datum
struct Datum: Codable {
    let answers: [String]
    let question, skillName: String

    enum CodingKeys: String, CodingKey {
        case answers, question
        case skillName = "skill_name"
    }
}
