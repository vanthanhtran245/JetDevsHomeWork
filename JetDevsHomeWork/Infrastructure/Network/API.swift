//
//  API.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/8/22.
//

import Foundation
import RxSwift

final class API {
    
    static let manager = API()
    
    private init() {}
    
    // create a method for calling api which is return a Observable
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let task = URLSession.shared.dataTask(with: apiRequest.toRequest()) { (data, response, error) in
                do {
                    let response = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(response)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
