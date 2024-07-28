//
//  PatientsModel.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 27/07/2024.
//

import Foundation
import Firebase

struct Patients: Identifiable { //, Codable {
    var id: String
    var firstName: String
    var lastName: String
    var age: String
    var height: String
    var weight: String
    var history: Bool
    var coordination: String
    var scanID: String
    var diagnosis: String 
}
