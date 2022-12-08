//
//  LoginRepository.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/7/22.
//

import Foundation
import RxSwift

protocol LoginRepository {
    func login(_ email: String, password: String) -> Observable<LoginResponse>
}
