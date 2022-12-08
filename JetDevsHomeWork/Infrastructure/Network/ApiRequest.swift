//
//  ApiRequest.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/8/22.
//

import Foundation

struct APIRequest {
    let path: String
    var method = HttpMethod.GET
    var parameters = [String: String]()
}

extension APIRequest {
    func toRequest() -> URLRequest {
        let baseURL = "https://jetdevs.mocklab.io"
        let requestFullPath = "\(baseURL)/\(path)"
        let requestURL = URL(string: requestFullPath)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
