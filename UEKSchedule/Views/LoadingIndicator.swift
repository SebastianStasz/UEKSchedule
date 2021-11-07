//
//  LoadingIndicator.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import SwiftUI
import SSUtils

struct LoadingIndicator: View {

    let displayIf: Bool

    init(displayIf: Bool = true) {
        self.displayIf = displayIf
    }

    var body: some View {
        ProgressView().displayIf(displayIf)
    }
}


// MARK: - Preview

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator(displayIf: true)
    }
}
