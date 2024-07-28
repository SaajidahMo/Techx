//
//  HomeView.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 26/07/2024.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State private var showAddPatient = false
    @StateObject private var viewModel = PatientsViewModel()
    
    
    var body: some View {
        // Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        NavigationView {
            List {
                        ForEach(viewModel.filteredPatients,  id: \.scanID) { patient in
                            NavigationLink(destination: PatientDetailView(patient: patient)) {
                                Text("\(patient.id): \(patient.firstName) \(patient.lastName)")
                                    .font(.title3)
                                    .padding(.top, 5)
                            }
                        }
                    }
                    .navigationTitle("Patients")
                    .searchable(text: $viewModel.searchText)
                
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddPatient.toggle()
                    }) {
                        Label("Add Patient", systemImage: "plus")
                    }
                    
                }
            }
                .fullScreenCover(isPresented: $showAddPatient) {
                                NewPatientView()
                            }
        }
    }
}

#Preview {
    HomeView()
}
