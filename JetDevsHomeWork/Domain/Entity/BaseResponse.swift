//
//  BaseResponse.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/7/22.
//

import Foundation

protocol BaseResponse {
    associatedtype T
    var result: Int { get }
    var errorMessage: String { get }
    var data: T { get }
}
