//
//  ValidateRepository.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/7/22.
//

import Foundation

protocol ValidateRepository {
    
    func validateEmail(_ email: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
}
