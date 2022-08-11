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
       
       
    }
    
    private let backgroundImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albums_background")
        return imageView
    }()
    
    private let overlayView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let logoImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "welcomeScreen_logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let subtitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on\nthe go."
        return label
    }()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        overlayView.frame = view.bounds
        setupConstraint()
    
    }

    private func setupView(){
        title = "Spotify"
        view.backgroundColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.modalPresentationStyle = .fullScreen
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(logoImageView)
        view.addSubview(subtitleLabel)
    }
    
    private func setupSignInButton(){
        let button = UIButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sigh In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
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
                signInButton.heightAnchor.constraint(equalToConstant: 50),
                
                //logoImageView
                logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
                logoImageView.widthAnchor.constraint(equalToConstant: 120.0),
                logoImageView.heightAnchor.constraint(equalToConstant: 120.0),
                
                //subtitleLabel
                subtitleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30.0),
                subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                
                

        ])
    }
    
    
    @objc private func didTapSignInButton(){
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

