//
//  AboutView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Form {
            Section(header: Text(.common_about)) {
                Text(.about_appDescription).textBodyThin
            }
            Section(header: Text(.common_email)) {
                Text("sebastianstaszczyk.1999@gmail.com").textBodyThin
            }
        }
        .navigationTitle(String.common_appName)
    }
}


// MARK: - Preview

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .embedInNavigationView()
    }
}
