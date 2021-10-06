//
//  ScheduleScrapper.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 06/10/2021.
//

import Foundation

final class ScheduleScrapper: ObservableObject {

    private let url = "http://planzajec.uek.krakow.pl/index.php?typ=G&id=184261&okres=2"

    func scrapSchedule() {
        guard let webContent = getWebContent(from: url) else { return }
        print(webContent)
    }

    private func getWebContent(from url: String) -> String? {
        guard let url = URL(string: url),
              let webContent = try? String(contentsOf: url)
        else { return nil }
        return webContent
    }
}
