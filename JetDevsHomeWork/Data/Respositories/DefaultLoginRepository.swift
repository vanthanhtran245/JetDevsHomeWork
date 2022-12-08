//
//  DefaultLoginRepository.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/7/22.
//

import Foundation
import RxSwift

final class DefaultLoginRepository: LoginRepository {
    
    init() {}
    
    func login(_ email: String, password: String) -> Observable<LoginResponse> {
        let url = URL(string: "https://github.com")!
        let request = URLRequest(url: url)
        return Observable.create { obs in
            URLSession.shared.rx.response(request: request).debug("r").subscribe(
                onNext: { response in
                    let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: response.data)
                    return obs.onNext(loginResponse!)
                },
                onError: {error in
                    obs.onError(error)
                })
        }
    }
}
