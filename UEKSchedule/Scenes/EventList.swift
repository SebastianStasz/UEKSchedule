//
//  EventList.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI

struct EventGroup {
    let title: String
    let events: [Event]
}

extension EventGroup: Identifiable {
    var id: String { title }
}

extension EventGroup {
    static let sampleData = [
        EventGroup(title: "2021-10-06", events: Event.sampleData)
    ]
}

struct EventList: View {

    let title: String
    let eventGroups: [EventGroup]

    var body: some View {
        List {
            ForEach(eventGroups) { eventGroup in
                Section(header: Text(eventGroup.title)) {
                    ForEach(eventGroup.events) { event in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Text(event.time)
                                Spacer()
                                Text(event.leader)
                            }
                            .font(.caption)

                            Text(event.name)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.insetGrouped)
    }
}

// MARK: - Preview

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList(title: "ZZISS1-3512IO", eventGroups: EventGroup.sampleData)
            .embedInNavigationView()
    }
}
