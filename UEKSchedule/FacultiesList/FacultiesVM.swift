//
//  FacultiesVM.swift
//  UEKSchedule
//
//  Created by Sebastian Staszczyk on 10/10/2021.
//

import Combine
import Foundation
import SwiftSoup

final class FacultiesVM: ObservableObject {

    @Published private(set) var faculties: [Faculty] = []
    @Published var search = ""
    @Published private(set) var isLoading = true

    private var cancellables: Set<AnyCancellable> = []
    private let scheduleUrl = "https://planzajec.uek.krakow.pl/index.php"

    init() {
        loadFaculties()
    }

    private func loadFaculties() {
        APIService.shared.getWebContentFrom(url: scheduleUrl)
            .flatMap { self.parseFaculties(from: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    print(error)
                case .finished:
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] faculties in
                self?.faculties = faculties
            }
            .store(in: &cancellables)
    }

    private func parseFaculties(from content: Document) -> AnyPublisher<[Faculty], AppError> {
        guard let groups = try? content.getElementsByClass("kategorie").array().second,
              let faculties = try? groups.select("a").array()
        else {
            return Fail<[Faculty], AppError>(error: AppError.getWebContent).eraseToAnyPublisher()
        }
        return Just(faculties.compactMap { getFaculty(from: $0) })
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }

    private func getFaculty(from element: Element) -> Faculty? {
        guard let link = try? element.attr("href"),
              let name = try? element.text()
        else { return nil }
        return Faculty(name: name, url: link)
    }
}
