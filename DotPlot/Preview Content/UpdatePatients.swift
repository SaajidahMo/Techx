//
//  UpdatePatients.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 27/07/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

struct UpdatePatients: View {
    // https://stackoverflow.com/questions/63927231/navigate-back-after-saving-in-swift-ui
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var id = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var history = false
    
    @State private var coordination = "A2"
    @State private var scanID = ""
    @State private var diagnosis = "Unknown"
    
    let coordinatesOptions = [
                "A2", "A3", "A4",
                "B1", "B2", "B3", "B4",
                "C1", "C2", "C3", "C4",
                "D2", "D3", "E3", "F2", "F3", "F4",
                "G1", "G3", "G4",
                "H1", "H2", "H3", "H4"
            ]
    
    let diagnosisOptions = ["Unknown", "Benign", "Malignant"]
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var shouldDismiss = false
    
    @State private var isPresented = false
    @State private var goBack  = false

    
    let patients: Patients
    
   // var userID: String? {
    //    return Auth.auth().currentUser?.uid }
    @StateObject var patientsViewModel = PatientsViewModel()
    //@EnvironmentObject var patientsViewModel: PatientsViewModel
    var body: some View {
      //  @StateObject var patientsViewModel = PatientsViewModel()
        
        NavigationView{
            Form {
                Section(header: Text("Patients ID")) {
                    TextField("Item Name", text: $id)
                        .keyboardType(.numberPad)
                        .onAppear {
                            id = patients.id
                        }
                        .onChange(of: id) { newValue in
                                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                                    if filtered.count <= 4 {
                                                        id = filtered
                                                    } else {
                                                        id = String(filtered.prefix(4))
                                                    }
                                                }
                }
                
                Section(header: Text("Patient's First Name")) {
                    TextField("Item Name", text: $firstName)
                        .onAppear {
                            firstName = patients.firstName
                        }
                }
                
                Section(header: Text("Patient's Last Name")) {
                    TextField("Item Name", text: $lastName)
                        .onAppear {
                            lastName = patients.lastName
                        }
                }
                
                Section(header: Text("Age")) {
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                        .onAppear { 
                            age = patients.age
                           // age = String(patients.age)
                            ////age = patients.age }
                            //String(patients.age) }
                        }
                        .onChange(of: age) { newValue in
                                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                                    if filtered.count <= 3 {
                                                        age = filtered
                                                    } else {
                                                        age = String(filtered.prefix(3))
                                                    }
                                                }
                }
                
                Section(header: Text("Height (cm)")) {
                                                    TextField("Height", text: $height)
                                                        .keyboardType(.decimalPad)
                                                        .onAppear { height = patients.height }
                                                }

                                                Section(header: Text("Weight (kg)")) {
                                                    TextField("Weight", text: $weight)
                                                        .keyboardType(.decimalPad)
                                                        .onAppear { weight = patients.weight }
                                                }
                
                Section(header: Text("History of Breast Cancer")) {
                                                 Toggle(isOn: $history) {
                                                     Text(history ? "Yes" : "No")
                                                 }
                                                 .onAppear { history = patients.history }
                                             }
                
                Section(header: Text("Coordinates")) {
                                           Picker("Coordinates", selection: $coordination) {
                                               ForEach(coordinatesOptions, id: \.self) { option in
                                                   Text(option)
                                               }
                                           }
                                           .onAppear { coordination = patients.coordination }
                                       }

                Section(header: Text("US Scan ID")) {
                    TextField("Scan ID", text: $scanID)
                        .keyboardType(.numberPad)
                        .onAppear {
                            age = patients.age
                           // age = String(patients.age)
                            ////age = patients.age }
                            //String(patients.age) }
                        }
                        .onChange(of: age) { newValue in
                                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                                    if filtered.count <= 3 {
                                                        scanID = filtered
                                                    } else {
                                                        scanID = String(filtered.prefix(3))
                                                    }
                                                }
                }
                
                Section(header: Text("Diagnosis")) {
                    Picker("Diagnosis", selection: $diagnosis) {
                        ForEach(diagnosisOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onAppear { diagnosis = patients.diagnosis }
                }
                
            }
            .accentColor(.purple)
            .navigationTitle("Patient's Detials")
            .navigationBarItems(leading:
                                    Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }
                .foregroundColor(.purple), trailing:
                                    Button("Update") {
             updateNewPatient()
                
            } .foregroundColor(.purple)
                .bold()
            )
        }
       
        .alert(isPresented: $showAlert) {
                   Alert(
                       title: Text("Alert"),
                       message: Text(alertMessage),
                       dismissButton: .default(Text("OK")) {
                           if shouldDismiss {
                                                  self.presentationMode.wrappedValue.dismiss()
                               patientsViewModel.fetchPatientsAfterButton()
                                              //  if !alertMessage.contains("successfully") {
                          //     self.presentationMode.wrappedValue.dismiss()
                           }
                       }
                   )
               }
        
       /** .alert(isPresented: $showAlert){
            Alert(title: Text("Alert"), message:Text(alertMessage), dismissButton: .default(Text("Ok")) {
                self.presentationMode.wrappedValue.dismiss()
                patientsViewModel.fetchPatientsAfterButton()
            })
        } */
    }
 
    
    func showAlert(message: String, shouldDismiss: Bool = false) {
        alertMessage = message
        self.shouldDismiss = shouldDismiss
        showAlert = true
    }
        
    func updateNewPatient() {
        
        guard !id.isEmpty else {
            showAlert(message: "Please enter the Patient's ID")
            return
        }
        
        guard !firstName.isEmpty else {
            showAlert(message: "Please enter the Patient's name.")
            return
        }
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("dotplotDB")
        
        // code below was reused and developed to find the document of where the item is stored. https://peterfriese.dev/blog/2020/swiftui-firebase-fetch-data/
        
        collectionRef.whereField("id", isEqualTo: patients.id).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents for Patient \(patients.firstName): \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found for Patient \(patients.firstName)")
                return
            }
            
            if let document = documents.first {
                let documentID = document.documentID
                
                let updateData: [String:Any] = [
                    "id" : id,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "age": age,
                    "height": height,
                    "weight": weight,
                    "history": history,
                    "coordination": coordination,
                    "scanID": scanID,
                    "diagnosis": diagnosis
                    //  "imageURL": imageURL?.absoluteString ?? ""
                ]
                
                collectionRef.document(documentID).setData(updateData, merge: true){ error in
                    if let error = error {
                        print("Error updating patient \(patients.firstName): \(error.localizedDescription)")
                        showAlert(message: "Error updating :\(error.localizedDescription)")
                    } else {
                        print("Patient \(patients.firstName) with id \(patients.id) updated successfully.")
                        showAlert(message: "Patient updated successfully.", shouldDismiss: true)
                    }
                }
                
              
            }
        }
    }
        
    
   
}
