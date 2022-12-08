//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/7/22.
//

import UIKit
import RxCocoa
import RxSwift

protocol LoginViewControllerDelegate: AnyObject {
    func didLoginSuccess(_ viewController: LoginViewController, response: LoginResponse)
}

class LoginViewController: UIViewController, ViewControllerAlerting {
    
    private lazy var lefBarButton: UIBarButtonItem = {
        let leftButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                         target: self,
                                         action: #selector(onDismiss))
        leftButton.tintColor = .black
        return leftButton
    }()
    @IBOutlet private weak var emailTextField: CustomMaterialTextfield!
    @IBOutlet private weak var passwordTextField: CustomMaterialTextfield!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    private let viewModel: LoginViewModelTypes
    private let disposeBag = DisposeBag()
    private weak var delegate: LoginViewControllerDelegate?
    
    init(with viewModel: LoginViewModelTypes,
         delegate: LoginViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
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
        
        viewModel.outputs.signingIn
            .observeOn(MainScheduler.instance)
            .bind { [weak self] animate in
                if animate {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }.disposed(by: disposeBag)
        
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
        
        loginBindings()
    }
    
    func loginBindings() {
        loginButton.rx.tap
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.inputs.submit)
            .disposed(by: disposeBag)
        
        viewModel.outputs.loginResult.observeOn(MainScheduler.instance)
            .subscribe { [weak self] response in
                guard let `self` = self else {
                    return
                }
                if response.errorMessage.isEmpty && response.data.user != nil {
                    self.delegate?.didLoginSuccess(self, response: response)
                } else {
                    self.displayMessage(message: response.errorMessage)
                }
                debugPrint("Result \(response)")
            } onError: { error in
                if let networkError = error as? ErrorResult {
                    self.displayMessage(message: networkError.localizedDescription)
                } else {
                    self.displayMessage(message: error.localizedDescription)
                }
                debugPrint("Login error \(error)")
            }.disposed(by: disposeBag)
    }
}

@objc private extension LoginViewController {
    func onDismiss() {
        dismiss(animated: true)
    }
}
