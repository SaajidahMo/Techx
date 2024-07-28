//
//  NewPatientView.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 27/07/2024.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import Kingfisher


struct NewPatientView: View {
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
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var shouldDismiss = false
    @State private var showImagePicker = false
    

    
    @StateObject var patientsViewModel = PatientsViewModel()
    
    let coordinatesOptions = [
                "A2", "A3", "A4",
                "B1", "B2", "B3", "B4",
                "C1", "C2", "C3", "C4",
                "D2", "D3", "E3", "F2", "F3", "F4",
                "G1", "G3", "G4",
                "H1", "H2", "H3", "H4"
            ]
    
    let diagnosisOptions = ["Unknown", "Benign", "Malignant"]
    
    var body: some View {
      //  @StateObject var patientsViewModel = PatientsViewModel()
        // @StateObject var itemsViewModel = ItemsViewModel()
        //  Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationView{
            Form {
                Section(header: Text("Patient ID")) {
                    TextField("Patient ID", text: $id)
                        .keyboardType(.numberPad)
                        .onChange(of: id) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered.count <= 4 {
                                id = filtered
                            } else {
                                id = String(filtered.prefix(4))
                            }
                        }
                }
                
                Section(header: Text("Patient First Name")) {
                    TextField("First Name", text: $firstName)
                }
                
                Section(header: Text("Patient Last Name")) {
                    TextField("Last Name", text: $lastName)
                }
                
                Section(header: Text("Patient Age")) {
                    TextField("Patient Age", text: $age)
                        .keyboardType(.numberPad)
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
                }
                Section(header: Text("Weight (kg)")) {
                    TextField("Weight", text: $weight)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("History of Breast Cancer")) {
                    Toggle(isOn: $history) {
                        Text(history ? "Yes" : "No")
                    }
                    
                }
                
                Section(header: Text("Coordinates")) {
                    Picker("Coordinates", selection: $coordination) {
                        ForEach(coordinatesOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
                
                Section(header: Text("US Scan ID")) {
                    TextField("Scan ID", text: $scanID)
                        .keyboardType(.numberPad)
                        .onChange(of: scanID) { newValue in
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
                }
                
                
            }
            .navigationTitle("New Patient")
            .navigationBarItems(leading:
                                    Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }
                .foregroundColor(.purple), trailing:
                                    Button("Save") {
                savePatientInfo()
                
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
                            //fetchPatients()
                           // .fetchPatientsAfterButton()
                            //  if !alertMessage.contains("successfully") {
                            //     self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
               
        /**.alert(isPresented: $showAlert){
            Alert(title: Text("Alert"), message:Text(alertMessage), dismissButton: .default(Text("Ok")) {
                self.presentationMode.wrappedValue.dismiss()
            })
        } */
    }
    
     
    
    func showAlert(message: String, shouldDismiss: Bool = false) {
        alertMessage = message
        self.shouldDismiss = shouldDismiss
        showAlert = true
    }
    
    func savePatientInfo(){
        let db = Firestore.firestore()
        
        guard !id.isEmpty else {
            showAlert(message: "Please enter the Patient's ID.")
            return
        }
        
        guard !firstName.isEmpty else {
            showAlert(message: "Please enter the Patient's name.")
            return
        }
        
        let itemData : [String:Any] = [
            "id" : id,
            "firstName": firstName,
            "lastName": lastName,
            "age": age,
            "height": height,
            "weight": weight,
            "history": history,
            "coordination": coordination,
            "scanID": scanID,
            "diagnosis": diagnosis
        ]
        
        db.collection("dotplotDB").addDocument(data:itemData) { error in
            if let error = error {
                showAlert(message: "Error saving :\(error.localizedDescription)")
            } else {
                showAlert(message: "Patient saved successfully.", shouldDismiss: true)
                id = ""
                firstName = ""
                lastName = ""
                age = ""
                height = ""
                weight = ""
                history = false
                coordination = "A2"
                scanID = ""
                diagnosis = "Unknown"
                
                
            }
        }
    }
    
}
#Preview {
    NewPatientView()
}



struct PatientDetailView: View {
    let patient: Patients
    @State private var editShown = false
    @State private var imageShown = false
    @State private var imageShown2 = false
    @State private var isShowingCoordinationImage = true
    
    @EnvironmentObject var patientsViewModel: PatientsViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var imageUrl: URL? {
        // URL(string: "https://hello.\(patient.coordination).png")
        URL(string: "https://firebasestorage.googleapis.com/v0/b/dotplot-9fcce.appspot.com/o/\(patient.coordination).png?alt=media&token=c59c6e36-b20f-4fd0-b98e-47b330c2aa8a"
        )
    }
    
    var scanUrl : URL? {
        // URL(string: "https://hello.\(patient.coordination).png")
        URL(string: "https://firebasestorage.googleapis.com/v0/b/dotplot-9fcce.appspot.com/o/\(patient.scanID).png?alt=media&token=d9b87af8-35a8-4be7-9158-06acdb935c32" //"https://firebasestorage.googleapis.com/v0/b/dotplot-9fcce//.appspot.com/o/\(patient.scanID).png?alt=media&token=c59c6e36-b20f-4fd0-b98e-47b330c2aa8a"
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Patient Details")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("ID: \(patient.id)")
                .font(.title2)
            
            Text("Name: \(patient.firstName) \(patient.lastName)")
                .font(.title2)
            
            Text("Age: \(patient.age)")
                .font(.title2)
            
            if !patient.height.isEmpty {
                Text("Height (cm): \(patient.height)")
                    .font(.title2)
            }
            if !patient.weight.isEmpty {
                Text("Weight (kg) \(patient.weight)")
                    .font(.title2)
            }
            
            Text("History of Breast Cancer: \(patient.history ? "Yes" : "No")")
                .font(.title2)
            
            HStack {
                Text("Coordinates: \(patient.coordination)")
                    .font(.title2)
                
                Spacer()
                if let url = imageUrl {
                    /** Button(action: {
                     imageShown.toggle()
                     }) {
                     KFImage(url)
                     .resizable()
                     .placeholder {
                     ProgressView()
                     }
                     .cancelOnDisappear(true)
                     .aspectRatio(contentMode: .fit)
                     .frame(height: 200) // Adjust height as needed
                     } */
                    Button(action: {
                        isShowingCoordinationImage = true
                        imageShown.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                        //.clipShape(S())
                            .cornerRadius(12)
                    }
                    .sheet(isPresented: $imageShown) {
                        if let url = imageUrl {
                                                   FullScreenImageView(imageUrl: url)
                                               }
                    }
                    
                }
            }
            
            HStack {
                Text("US Scan ID: \(patient.scanID)")
                    .font(.title2)
                
                Spacer()
                if let url2 = scanUrl {
                    /** Button(action: {
                     imageShown.toggle()
                     }) {
                     KFImage(url)
                     .resizable()
                     .placeholder {
                     ProgressView()
                     }
                     .cancelOnDisappear(true)
                     .aspectRatio(contentMode: .fit)
                     .frame(height: 200) // Adjust height as needed
                     } */
                    Button(action: {
                        isShowingCoordinationImage = false
                        imageShown2.toggle()
                    }) {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                        //.clipShape(S())
                            .cornerRadius(12)
                    }
                    .sheet(isPresented: $imageShown2) {
                        if let url2 = scanUrl {
                                                    FullScreenImageView(imageUrl: url2)
                                                }
                    }
                    
                }
                
            }
            Text("Diagnosis: \(patient.diagnosis)")
                .font(.title2)
            //}
            
            //}
            Spacer()
        }
        .padding()
        .navigationTitle("Patient Details")
        .navigationBarTitleDisplayMode(.inline)
        
        .navigationBarItems(
            // edit button
            trailing: Button(action: {
                editShown.toggle()
            }, label: {
                Image(systemName: "pencil")
                    .foregroundColor(.purple)
                    .frame(width: 24, height: 24)
            }))
        
        // navigates to the view of edit item
        .sheet(isPresented: $editShown, onDismiss: nil) {
            UpdatePatients(patients: patient)
        }
        
    }
}
    
    
    struct FullScreenImageView: View {
        let imageUrl: URL
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
        
        var body: some View {
            VStack {
                /**   KFImage(imageUrl)
                 .resizable()
                 .placeholder {
                 ProgressView()
                 }
                 .aspectRatio(contentMode: .fit)
                 .frame(maxWidth: .infinity, maxHeight: .infinity)
                 .background(Color.black)
                 .edgesIgnoringSafeArea(.all) */
                
                ZoomableScrollView(imageUrl: imageUrl)
                    .edgesIgnoringSafeArea(.all)
                
                Spacer()
                
                Button("Close") {
                    // Close the sheet
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(.bottom, 20)
            }
        }
    }

struct ZoomableScrollView: UIViewRepresentable {
    let imageUrl: URL

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        let imageView = UIImageView()
        KF.url(imageUrl)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .set(to: imageView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        context.coordinator.imageView = imageView
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var imageView: UIImageView?
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
    }
}
