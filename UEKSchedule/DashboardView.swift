//
//  DashboardView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 06/10/2021.
//

import SwiftUI

struct DashboardView: View {

    @StateObject private var viewModel = ScheduleScrapper()

    var body: some View {
        VStack {
            Button("Scrap") {
                viewModel.scrapSchedule()
            }
        }
    }
}


// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
