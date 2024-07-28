//
//  PatientsViewModel.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 27/07/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class PatientsViewModel : ObservableObject{
    @AppStorage("log_status") private var logStatus: Bool = false
    @Published var patients: [Patients] = []
    @Published var searchText: String = "" {
            didSet {
                filterPatients()
            }
        }
        @Published var filteredPatients: [Patients] = []
    private var db = Firestore.firestore()
    
    var userID: String? {
        return Auth.auth().currentUser?.uid }
    
    init() {
        fetchPatients()
        
        /**
        // I implemented state change listener to check if the user is logged in or not.
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            
            if let user = user {
                print("User : \(user.uid)")
                self.fetchPatients()
            } else {
                print("User is not logged in")
                self.patients.removeAll()
            }
        }*/
    }
    
    
   
    func fetchPatients(){
       
        
       
       // patients.removeAll()
        
        let db = Firestore.firestore()
        let ref = db.collection("dotplotDB")
        
        
        ref.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print ("Error fetching items: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is empty")
                return
            }
            //self.patients.removeAll()
            
            var fetchedPatients: [Patients] = []
            
            for document in snapshot.documents {
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let firstName = data["firstName"] as? String ?? ""
                let lastName = data["lastName"] as? String ?? ""
                let age = data["age"] as? String ?? ""
                let height = data["height"] as? String ?? ""
                let weight = data["weight"] as? String ?? ""
                let history = data["history"] as? Bool ?? false
                let coordination = data["coordination"] as? String ?? ""
                let scanID = data["scanID"] as? String ?? ""
                let diagnosis = data["diagnosis"] as? String ?? ""
                
                
                let patient = Patients(id:id, firstName:firstName, lastName: lastName, age:age, height:height, weight:weight,history: history, coordination: coordination, scanID: scanID, diagnosis: diagnosis)
               // self.patients.append(patient)
               
                fetchedPatients.append(patient)
            }
            self.patients = fetchedPatients
                   self.filterPatients()
            
        }
    }
    
    func fetchPatientsAfterButton(){
        patients.removeAll()
        print("Patients removed")
        fetchPatients()
        print("Done")
    }
    
    func filterPatients() {
            if searchText.isEmpty {
                filteredPatients = patients
            } else {
                filteredPatients = patients.filter { patient in
                    patient.id.contains(searchText) ||
                    patient.firstName.lowercased().contains(searchText.lowercased()) ||
                    patient.lastName.lowercased().contains(searchText.lowercased())
                }
            }
        }
}
