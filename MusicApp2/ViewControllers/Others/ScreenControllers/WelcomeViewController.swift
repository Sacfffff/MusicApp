//
//  WelcomeViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

class WelcomeViewController: UIViewController {

    private weak var signInButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSignInButton()
        setupConstraint()
       
    }

    private func setupView(){
        title = "Spotify"
        view.backgroundColor = .systemGreen
    }
    
    private func setupSignInButton(){
        let button = UIButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sigh In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        signInButton = button
        view.addSubview(signInButton)
        
    }
    
    private func setupConstraint(){
        NSLayoutConstraint.activate(
            [
                //sighInButton
                signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
                signInButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0),
                signInButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0),
                signInButton.heightAnchor.constraint(equalToConstant: 50)
                
        ])
    }
    
    
    @objc func didTapSignInButton(){
        let authVC = AuthViewController()
        authVC.completionHandler = { [weak self] success in
            self?.handleSignIn(success: success)
        }
        authVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(authVC, animated: true)
    }
    
    private func handleSignIn(success: Bool){
        guard success else {
       alert(title: "Ooops",
             message: "Something went wrong when signing in",
             preferredStyle: .alert)
            return
            
        }
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
    
    private func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style){
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
        
    }

}

