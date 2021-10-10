//
//  APIService.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation
import SwiftSoup

final class APIService {

    static let shared = APIService()
    private lazy var decoder = JSONDecoder()

    private init() {}

    func getWebContent(from url: String) async -> Document? {
        guard let url = URL(string: url),
              let data = try? await URLSession.shared.data(from: url)
        else { return nil }

        let content = String(decoding: data.0, as: UTF8.self)
        guard let document = try? SwiftSoup.parse(content) else { return nil }
        return document
    }
}
