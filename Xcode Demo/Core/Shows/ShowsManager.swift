//
//  ShowManager.swift
//  Xcode Demo
//
//  Created by Owen Hennessey on 11/27/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: Tempo Structures

struct TemposArray: Codable {
    let tempos: [Tempo]
    let total, skip, limit: Int
}

struct Tempo: Identifiable, Codable, Equatable {
    var id: String
    var measure: String
    var tempo: String
    
    init(measure: String, tempo: String) {
        self.id = ""
        self.measure = measure
        self.tempo = tempo
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "tempo_id"
        case measure = "measure"
        case tempo = "tempo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.measure = try container.decode(String.self, forKey: .measure)
        self.tempo = try container.decode(String.self, forKey: .tempo)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.measure, forKey: .measure)
        try container.encodeIfPresent(self.tempo, forKey: .tempo)
    }
}

// MARK: - Part Structures

struct PartsArray: Codable {
    let parts: [Part]
    let total, skip, limit: Int
}

struct Part: Identifiable, Codable, Equatable {
    var id: String
    var partNumber: String
    var songName: String
    
    init(partNumber: String, songName: String) {
        self.id = ""
        self.partNumber = partNumber
        self.songName = songName
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "part_id"
        case partNumber = "part_number"
        case songName = "song_name"    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.partNumber = try container.decode(String.self, forKey: .partNumber)
        self.songName = try container.decode(String.self, forKey: .songName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.partNumber, forKey: .partNumber)
        try container.encodeIfPresent(self.songName, forKey: .songName)
    }
}

// MARK: - ShowsManager Class

final class ShowsManager {
    
    // MARK: Shared Instance
    
    static let shared = ShowsManager()
    private init() { }
    
    // MARK: Collection References
        
    private let showsCollection = Firestore.firestore().collection("Shows")
    
    private func showPartCollection(showId: String) -> CollectionReference {
        showDocument(showId: showId).collection("Parts")
    }
    
    private func showPartTempoCollection(showId: String, partId: String) -> CollectionReference {
        showPartDocument(showId: showId, partId: partId).collection("Tempos")
    }
    
    // MARK: Document References
    
    private func showDocument(showId: String) -> DocumentReference {
        showsCollection.document(showId)
    }
    
    private func showPartDocument(showId: String, partId: String) -> DocumentReference {
        showPartCollection(showId: showId).document(partId)
    }
    
    private func showPartTempoDocument(showId: String, partId: String, tempoId: String) -> DocumentReference {
        showPartTempoCollection(showId: showId, partId: partId).document(tempoId)
    }
    
    // MARK: Create Functions
    
    func createNewShow(newShow: Show) async throws {
        let document = showsCollection.document()
        let documentId = document.documentID
        let data: [String:Any] = [
            Show.CodingKeys.id.rawValue : documentId,
            Show.CodingKeys.showTitle.rawValue : newShow.showTitle,
            Show.CodingKeys.gameYear.rawValue : newShow.gameYear,
        ]
        try await document.setData(data, merge: false)
    }
    
    func createNewPart(showId: String, newPart: Part) async throws {
        let document = showPartCollection(showId: showId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            Part.CodingKeys.id.rawValue : documentId,
            Part.CodingKeys.songName.rawValue : newPart.songName,
            Part.CodingKeys.partNumber.rawValue : newPart.partNumber
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func createNewTempo(showId: String, partId: String, newTempo: Tempo) async throws {
        let document = showPartTempoCollection(showId: showId, partId: partId).document()
        let documentId = document.documentID
        
        let data: [String:Any] = [
            Tempo.CodingKeys.id.rawValue : documentId,
            Tempo.CodingKeys.measure.rawValue : newTempo.measure,
            Tempo.CodingKeys.tempo.rawValue : newTempo.tempo
        ]
        try await document.setData(data, merge: false)
    }
    
    // MARK: Update Functions
    
    func updateShow(show: Show) async throws {
        let document = showDocument(showId: show.id)
        let data: [String:Any] = [
            Show.CodingKeys.id.rawValue : document.documentID,
            Show.CodingKeys.showTitle.rawValue : show.showTitle,
            Show.CodingKeys.gameYear.rawValue : show.gameYear,
        ]
        try await document.setData(data, merge: false)
    }
    
    // TODO: Simplify function
    func updatePart(showId: String, part: Part) async throws {
        let document = showPartDocument(showId: showId, partId: part.id)
        let data: [String:Any] = [
            Part.CodingKeys.id.rawValue : part.id,
            Part.CodingKeys.songName.rawValue : part.songName,
            Part.CodingKeys.partNumber.rawValue : part.partNumber
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func updateTempo(showId: String, partId: String, newTempo: Tempo) async throws {
        let document = showPartTempoDocument(showId: showId, partId: partId, tempoId: newTempo.id)
        let data: [String:Any] = [
            Tempo.CodingKeys.id.rawValue : document.documentID,
            Tempo.CodingKeys.measure.rawValue : newTempo.measure,
            Tempo.CodingKeys.tempo.rawValue : newTempo.tempo
        ]
        try await document.setData(data, merge: false)
    }
    
    // MARK: Delete Functions
    
    func deleteShow(showId: String) async throws {
        let parts = try await getAllParts(showId: showId)
        for part in parts {
            try await deletePart(showId: showId, partId: part.id)
        }
        try await showDocument(showId: showId).delete()
    }
    
    func deletePart(showId: String, partId: String) async throws {
        let tempos = try await getAllTempos(showId: showId, partId: partId)
        for tempo in tempos {
            try await deleteTempo(showId: showId, partId: partId, tempoId: tempo.id)
        }
        try await showPartDocument(showId: showId, partId: partId).delete()
    }
    
    func deleteTempo(showId: String, partId: String, tempoId: String) async throws {
        try await showPartTempoDocument(showId: showId, partId: partId, tempoId: tempoId).delete()
    }
    
    // MARK: Get Functions
    
    func getShow(showId: String) async throws -> Show {
        try await showDocument(showId: showId).getDocument(as: Show.self)
    }
    
    func getPart(showId: String, partId: String) async throws -> Part {
        try await showPartDocument(showId: showId, partId: partId).getDocument(as: Part.self)
    }
    
    func getTempo(showId: String, partId: String, tempoId: String) async throws -> Tempo {
        try await showPartTempoDocument(showId: showId, partId: partId, tempoId: tempoId).getDocument(as: Tempo.self)
    }
    
    // MARK: Get All Functions
    
    func getAllShows() async throws -> [Show] {
        try await showsCollection.getDocuments(as: Show.self)
    }
    
    func getAllParts(showId: String) async throws -> [Part] {
        try await showPartCollection(showId: showId).order(by: "part_number", descending: false).getDocuments(as: Part.self)
    }
    
    func getAllTempos(showId: String, partId: String) async throws -> [Tempo] {
        try await showPartTempoCollection(showId: showId, partId: partId).order(by: "measure", descending: false).getDocuments(as: Tempo.self)
    }
    
    func addListenerForAllParts(showId: String, completion: @escaping (_ parts: [Part]) -> Void) {
        showPartCollection(showId: showId).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            let parts: [Part] = documents.compactMap({ try? $0.data(as: Part.self)})
            completion(parts)
        }
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
    }
}
