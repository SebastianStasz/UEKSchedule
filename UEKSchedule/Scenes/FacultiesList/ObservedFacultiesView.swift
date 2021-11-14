//
//  ObservedFacultiesView.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 13/11/2021.
//

import SwiftUI
import UEKScheduleCoreData

struct ObservedFacultiesView: View {

    @FetchRequest private var observedFaculties: FetchedResults<FacultyGroupEntity>

    var body: some View {
        Section(header: Text(.common_observed)) {
            ForEach(observedFaculties) { facultGroup in
                NavigationLink(facultGroup.name, destination: ScheduleView(viewModel: .init(facultyGroupEntity: facultGroup)))
            }
        }
    }

    init(observedFaculties: FetchRequest<FacultyGroupEntity>) {
        self._observedFaculties = observedFaculties
    }
}


// MARK: - Preview

struct ObservedFacultiesView_Previews: PreviewProvider {
    static var previews: some View {
        ObservedFacultiesView(observedFaculties: FacultyGroupEntity.getAll())
    }
}
