//
//  ProfileViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import SDWebImage
import UIKit

protocol ProfileViewControllerProtocol : AnyObject {
    func selectedRow()
}

class ProfileViewController: UIViewController {
    
    private var viewModel : ProfileViewModelProtocol = ProfileViewModel()
    
    @IBOutlet private weak var tableView : UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    weak var delegate : ProfileViewControllerProtocol?
    
    init() {
        super.init(nibName: "\(Self.self)", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        setup()
    }
    
    private func setup(){
        title = "Profile"
        viewModel.failed = failedToGetProfile
        viewModel.update = updateUI
        viewModel.fetchData()
        self.navigationItem.largeTitleDisplayMode = .never
        
       
        tableView.register(UINib(nibName: "\(ProfileViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(ProfileViewCell.self)")
       
    }
    
  
    
//MARK: - updateUI
    private func updateUI(with model: UserProfile) {
        tableView.isHidden = false
        //configure
        viewModel.models.append(ProfileCellViewModel(title: "Full name:", description: model.displayName))
        viewModel.models.append(ProfileCellViewModel(title: "Email adress:", description: model.email))
        viewModel.models.append(ProfileCellViewModel(title: "User ID:", description: model.id))
        viewModel.models.append(ProfileCellViewModel(title: "Plan:", description: model.product))
       
        createTableHeader(with: model.images.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeader(with string: String?) {
        guard let urlString = string, let url = URL(string: urlString) else {
            return
        }
        
        let headerView = ProfileViewControllerHeader(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        headerView.setup(with: url)
        tableView.tableHeaderView = headerView
    }
    
    private func failedToGetProfile() {
        tableView.isHidden = true
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    

}

//MARK: - extension UITableViewDataSource
extension ProfileViewController : UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProfileViewCell.self)", for: indexPath) as? ProfileViewCell else { return .init() }
        cell.setup(with: viewModel.models[indexPath.row])
        return cell
    }
    
    
    
}

//MARK: - extension UITableViewDelegate

extension ProfileViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
}
