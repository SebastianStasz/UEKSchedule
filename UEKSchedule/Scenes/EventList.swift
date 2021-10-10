//
//  EventList.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct EventList: View {

    let title: String
    let events: [Event]

    var body: some View {
        List {
            ForEach(events) { event in
                Text(event.name)
            }
        }
        .navigationTitle(title)
    }
}


// MARK: - Preview

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList(title: "Sample title", events: [])
    }
}
