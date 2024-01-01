//
//  ShowsDatabase.swift
//  Xcode Demo
//
//  Created by Owen Hennessey on 11/29/23.
//

import Foundation

struct ShowArray: Codable {
    let shows: [Show]
    let total, skip, limit: Int
}

// MARK: SHOW STRUCTURE

struct Show: Identifiable, Codable, Equatable {
    var id: String
    var showTitle: String
    var gameYear: String
//    var parts: Part
    
    init(
            showTitle: String,
            gameYear: String
        ) {
            self.id = ""
            self.showTitle = showTitle
            self.gameYear = gameYear
            
        }
    
    enum CodingKeys: String, CodingKey {
        case id = "show_id"
        case showTitle = "show_title"
        case gameYear = "game_year"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.showTitle = try container.decode(String.self, forKey: .showTitle)
        self.gameYear = try container.decode(String.self, forKey: .gameYear)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.showTitle, forKey: .showTitle)
        try container.encode(self.gameYear, forKey: .gameYear)
    }
}
