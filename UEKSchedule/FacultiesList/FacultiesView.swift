//
//  FacultiesView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct FacultiesView: View {

    @StateObject private var viewModel = FacultiesVM()

    var body: some View {
        List {
            ForEach(viewModel.faculties) {
                NavigationLink($0.name) {
//                    Text($0.name)
                }
            }
        }
        .searchable(text: $viewModel.search)
        .overlay(activityIndicator)
        .embedInNavigationView(title: "Faculties")
    }

    private var activityIndicator: some View {
        ProgressView().displayIf(viewModel.isLoading)
        
    }
}


// MARK: - Preview

struct FacultiesView_Previews: PreviewProvider {
    static var previews: some View {
        FacultiesView()
    }
}
