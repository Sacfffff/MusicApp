//
//  AuthViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//
import UIKit

import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    public var completionHandler : ((Bool) -> Void)?
    
    private lazy var webView : WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
        guard let url = AuthManager.shared.sighInURL else { return }
        webView.load(URLRequest(url: url))
       
    }
    

    private func setupView(){
        title = "Sigh In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
     func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"})?.value else { return }
     
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
}

