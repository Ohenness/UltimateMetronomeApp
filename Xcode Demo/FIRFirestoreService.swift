//
//  FIRFirestoreService.swift
//  UltimateMetronomeApp
//
//  Created by Owen Hennessey on 10/20/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class FIRFirestoreService {
    private init() {}
    static let shared = FIRFirestoreService()
    
     
    
    func configure() {
        FirebaseApp.configure()
    }
    
    private func reference(to collectionReference: String) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference)
    }
    
    func create(show: String, part: String, song: String, tempo: Int) {
        let parameters: [String: Any] = ["Song": song, "Tempo": tempo]
        
        reference(to: show).document(part).setData(parameters)
    }
    
    func read(show: String) {
        reference(to: show).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                print(document.data())
            }
            if (snapshot.documents.isEmpty) {
                print("Show not found")
            }
        }
    }
    
    func update(show: String, part: String, song: String, tempo: Int) {
        let parameters: [String: Any] = ["Song": song, "Tempo": tempo]

        reference(to: show).document(part).setData(parameters)
    }
    
    func delete(show: String, part: String, song: String, tempo: Int) {
        reference(to: show).document(part).delete()
    }
}
