//
//  SceneDelegate.swift
//  DestinationGuide
//
//  Created by Alexandre Guibert1 on 02/08/2021.
//

import Combine
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let service = DestinationFetchingService()
            window.rootViewController = UINavigationController(
                rootViewController: DestinationsViewController(
                    viewModel: .init(
                        getDestinations: {
                            let future = Future<Set<Destination>, DestinationFetchingServiceError> { promise in
                                service.getDestinations { result in
                                    switch result {
                                    case .success(let destinations):
                                        promise(.success(destinations))
                                    case .failure(let error):
                                        promise(.failure(error))
                                    }
                                }
                            }
                            return future.eraseToAnyPublisher()
                        },
                        getDestinationDetails: { id in
                            let future = Future<DestinationDetails, DestinationFetchingServiceError> { promise in
                                service.getDestinationDetails(for: id) { result in
                                    switch result {
                                    case .success(let destinationDetails):
                                        promise(.success(destinationDetails))
                                    case .failure(let error):
                                        promise(.failure(error))
                                    }
                                }
                            }
                            return future.eraseToAnyPublisher()
                        }
                    )
                )
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
