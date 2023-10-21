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
        let parameters: [String: Any] = ["Show": show, "Part": part, "Song": song, "Tempo": tempo]
        
        reference(to: "Shows").addDocument(data: parameters)
    }
    
    func read() {
        reference(to: "Shows").addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                print(document.data())
            }
        }
    }
    
    func update(show: String, part: String, song: String, tempo: Int) {
        reference(to: "Shows").document("xNEXYLCh90I9n1rUHSYl").setData(["Show": show, "Part": part, "Song": song, "Tempo": tempo])
    }
    
    func delete() {
        reference(to: "Shows").document("xNEXYLCh90I9n1rUHSYl").delete()
    }
}
