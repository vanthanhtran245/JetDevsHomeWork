//
//  API.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/8/22.
//

import Foundation
import RxSwift

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
    
    var localizedDescription: String {
        switch self {
        case .network(let value):   return value
        case .parser(let value):    return value
        case .custom(let value):    return value
        }
    }
}

final class API {
    
    static let manager = API()
    
    private init() {}
    
    // create a method for calling api which is return a Observable
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let task = URLSession.shared.dataTask(with: apiRequest.toRequest()) { (data, response, error) in
                guard let response = response as? HTTPURLResponse, response.isResponseOK() else {
                    observer.onError(ErrorResult.network(string: "An error occur during request. Please try again"))
                    observer.onCompleted()
                    return
                }
                do {
                    let response = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(response)
                } catch {
                    observer.onError(ErrorResult.parser(string: "Invalid response data. Please try again later"))
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

extension HTTPURLResponse {
    func isResponseOK() -> Bool {
        return (200...299).contains(self.statusCode)
    }
}
