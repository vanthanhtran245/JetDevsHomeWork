//
//  Reactive.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/8/22.
//

import UIKit.UITextField
import RxSwift
import RxCocoa

extension Reactive where Base: CustomMaterialTextfield {
    
    var errorMessage: Binder<String> {
        return Binder(base, binding: { textField, message in
            textField.error(message: message)
        })
    }
}
