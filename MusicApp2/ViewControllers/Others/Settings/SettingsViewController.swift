//
//  SettingsViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var viewModel : SettingsViewModelProtocol = SettingsViewModel()

    private var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
    }()
  

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
    

    private func setup(){
        title = "Settings"
        configureModels()
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureModels() {
        

        
        viewModel.sections.append(Sections(title: "Profile",
                                 options: [Option(title: "View your profile",
                                                  handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
           
        })]))
        
        viewModel.sections.append(Sections(title: "Account",
                                 options: [Option(title: "Sign out",
                                                  handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
           
        })]))
    }
    
    
    private func viewProfile(){
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func signOutTapped(){
        let alert = UIAlertController(title: "Sigh out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sigh out", style: .destructive, handler: { _ in
            AuthManager.shared.sighOut { sighedOut in
                if sighedOut {
                    DispatchQueue.main.async { [weak self] in
                        let navigationController = UINavigationController(rootViewController: WelcomeViewController())
                        navigationController.modalPresentationStyle = .fullScreen
                        self?.present(navigationController, animated: true, completion: {
                            self?.navigationController?.popToRootViewController(animated: false)
                        })
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    

}

extension SettingsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = viewModel.sections[section]
        return model.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
}

extension SettingsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
}
