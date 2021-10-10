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

    private init() {}

    func getWebContentFrom(url: String) -> AnyPublisher<Document, AppError> {
        Just(url)
            .flatMap { url -> AnyPublisher<URL, AppError> in
                guard let url = URL(string: url) else {
                    return Fail<URL, AppError>(error: AppError.getWebContent).eraseToAnyPublisher()
                }
                return Just(url)
                    .setFailureType(to: AppError.self)
                    .eraseToAnyPublisher()
            }
            .tryMap { try String(contentsOf: $0) }
            .tryMap { try SwiftSoup.parse($0) }
            .mapError { _ in AppError.getWebContent }
            .eraseToAnyPublisher()
    }
}
