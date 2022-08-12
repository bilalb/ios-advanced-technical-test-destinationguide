//
//  DestinationFetchingService.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 02/08/2021.
//

import Foundation

enum DestinationFetchingServiceError : Error {
    case destinationNotFound
}

protocol DestinationFetchingServiceProtocol {
    func getDestinations(completion: @escaping  (Result<Set<Destination>, DestinationFetchingServiceError>)->())
    func getDestinationDetails(for destinationID: Destination.ID, completion: @escaping  (Result<DestinationDetails, DestinationFetchingServiceError>)->())
}

final class DestinationFetchingService : DestinationFetchingServiceProtocol {
    func getDestinations(completion: @escaping (Result<Set<Destination>, DestinationFetchingServiceError>) -> ()) {
        let extraSeconds = Double.random(in: 1..<5)
        DispatchQueue.global().asyncAfter(deadline: .now() + extraSeconds) {
            completion(.success(destinationsStub))
        }
    }
    
    func getDestinationDetails(for destinationID: Destination.ID, completion: @escaping  (Result<DestinationDetails, DestinationFetchingServiceError>) -> ()) {
        let extraSeconds = Double.random(in: 1..<5)
        DispatchQueue.global().asyncAfter(deadline: .now() + extraSeconds) {
            let destinationDetails = destinationDetailsStub
                .first(where: { $0.id == destinationID})
            completion(destinationDetails.map { .success($0) } ?? .failure(.destinationNotFound))
        }
    }
}

fileprivate var destinationsStub : Set<Destination> = [
    .init(id: "217", name: "Barbade", picture: URL(string:"https://static1.evcdn.net/images/reduction/1027399_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5),
    .init(id: "50", name: "Arménie", picture: URL(string:"https://static1.evcdn.net/images/reduction/1544481_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "6", name: "Allemagne", picture: URL(string:"https://static1.evcdn.net/images/reduction/1027397_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5),
    .init(id: "306", name: "Bali", picture: URL(string:"https://static1.evcdn.net/images/reduction/1581674_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "13", name: "Autriche", picture: URL(string:"https://static1.evcdn.net/images/reduction/354894_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5),
    .init(id: "147", name: "Antilles", picture: URL(string:"https://static1.evcdn.net/images/reduction/397848_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "373", name: "Basse-Californie", picture: URL(string:"https://static1.evcdn.net/images/reduction/1596154_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "73", name: "Afrique du Sud", picture: URL(string:"https://static1.evcdn.net/images/reduction/1506493_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5),
    .init(id: "98", name: "Australie", picture: URL(string:"https://static1.evcdn.net/images/reduction/635304_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "426", name: "Amazonie Brésilienne", picture: URL(string:"https://static1.evcdn.net/images/reduction/1595441_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "377", name: "Bajio", picture: URL(string:"https://static1.evcdn.net/images/reduction/1596170_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "74", name: "Azerbaïdjan", picture: URL(string:"https://static1.evcdn.net/images/reduction/611704_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5),
    .init(id: "115", name: "Antarctique", picture: URL(string:"https://static1.evcdn.net/images/reduction/210925_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "110", name: "Bangladesh", picture: URL(string:"https://static1.evcdn.net/images/reduction/356979_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "29", name: "Algérie", picture: URL(string:"https://static1.evcdn.net/images/reduction/1230836_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5),
    .init(id: "75", name: "Argentine", picture: URL(string:"https://static1.evcdn.net/images/reduction/904030_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5),
    .init(id: "173", name: "Açores", picture: URL(string:"https://static1.evcdn.net/images/reduction/356685_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "170", name: "Albanie", picture: URL(string:"https://static1.evcdn.net/images/reduction/413980_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "287", name: "Angleterre", picture: URL(string:"https://static1.evcdn.net/images/reduction/609757_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 4),
    .init(id: "107", name: "Bahamas", picture: URL(string:"https://static1.evcdn.net/images/reduction/39034_w-800_h-800_q-70_m-crop.jpg")!, tag: "Incontournable", rating: 5)
]

fileprivate var destinationDetailsStub : Set<DestinationDetails> = [
    .init(id: "217", name: "Barbade", url: URL(string:"https://evaneos.fr/barbade")!),
    .init(id: "50", name: "Arménie", url: URL(string:"https://evaneos.fr/armenie")!),
    .init(id: "6", name: "Allemagne", url: URL(string:"https://evaneos.fr/allemagne")!),
    .init(id: "306", name: "Bali", url: URL(string:"https://evaneos.fr/bali")!),
    .init(id: "13", name: "Autriche", url: URL(string:"https://evaneos.fr/autriche")!),
    .init(id: "147", name: "Antilles", url: URL(string:"https://evaneos.fr/antilles")!),
    .init(id: "373", name: "Basse-Californie", url: URL(string:"https://evaneos.fr/basse-californie")!),
    .init(id: "73", name: "Afrique du Sud", url: URL(string:"https://evaneos.fr/afrique-du-sud")!),
    .init(id: "98", name: "Australie", url: URL(string:"https://evaneos.fr/australie")!),
    .init(id: "426", name: "Amazonie Brésilienne", url: URL(string:"https://evaneos.fr/amazonie-bresilienne")!),
    .init(id: "377", name: "Bajio", url: URL(string:"https://evaneos.fr/bajio")!),
    .init(id: "74", name: "Azerbaïdjan", url: URL(string:"https://evaneos.fr/azerbaidjan")!),
    .init(id: "115", name: "Antarctique", url: URL(string:"https://evaneos.fr/antarctique")!),
    .init(id: "110", name: "Bangladesh", url: URL(string:"https://evaneos.fr/bangladesh")!),
    .init(id: "29", name: "Algérie", url: URL(string:"https://evaneos.fr/algerie")!),
    .init(id: "75", name: "Argentine", url: URL(string:"https://evaneos.fr/argentine")!),
    .init(id: "173", name: "Açores", url: URL(string:"https://evaneos.fr/acores")!),
    .init(id: "287", name: "Angleterre", url: URL(string:"https://evaneos.fr/angleterre")!),
    .init(id: "107", name: "Bahamas", url: URL(string:"https://evaneos.fr/bahamas")!)
]
