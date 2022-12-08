//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/7/22.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    private lazy var lefBarButton: UIBarButtonItem = {
        let leftButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(onDismiss))
        leftButton.tintColor = .black
        return leftButton
    }()
    @IBOutlet private weak var emailTextField: CustomMaterialTextfield!
    @IBOutlet private weak var passwordTextField: CustomMaterialTextfield!
    @IBOutlet private weak var loginButton: UIButton!
    private let viewModel: LoginViewModelTypes
    private let disposeBag = DisposeBag()
    
    init(with viewModel: LoginViewModelTypes) {
        self.viewModel = viewModel
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        navigationItem.leftBarButtonItem = lefBarButton
    }
}

private extension LoginViewController {
    
    @IBAction func loginAction(_ sender: Any) {
        guard let emailText = emailTextField.text,
                let passwordText = passwordTextField.text else {
            return
        }
        viewModel.doLogin(email: emailText, password: passwordText)
    }
    
    func setupBindings() {
        emailTextField.rx.text.orEmpty.distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .bind(onNext: viewModel.inputs.didChange(email:))
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .bind(onNext: viewModel.inputs.didChange(password:))
            .disposed(by: disposeBag)
        
        viewModel.outputs.isEmailValid.map { $0.errorMessage }
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: self.emailTextField.rx.errorMessage)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isPasswordValid.map { $0.errorMessage }
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: self.passwordTextField.rx.errorMessage)
            .disposed(by: disposeBag)
        
        _ = viewModel.outputs.isEnableLoginButton
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: loginButton.rx.isEnabled)
        
        _ = viewModel.outputs.isEnableLoginButton
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { enable in
                self.loginButton.backgroundColor = enable ? UIColor(hex: "28518D") : .lightGray
                self.loginButton.isEnabled = enable
        })
        .disposed(by: disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
        emailTextField.addErrorLabel(parentView: emailTextField.superview)
        passwordTextField.addErrorLabel(parentView: passwordTextField.superview)
    }
}

@objc private extension LoginViewController {
    func onDismiss() {
        dismiss(animated: true)
    }
}
