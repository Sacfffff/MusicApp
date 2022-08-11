//
//  LibraryPlaylistsViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 15.07.22.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    private var viewModel : LibraryPlaylistViewModelProtocol = LibraryPlaylistViewModel()
  
    var selectionHandler: ((Playlist) -> Void)?
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "\(SubtitleTableViewCell.self)")
        tableView.isHidden = true
        tableView.rowHeight = 60.0
        tableView.allowsSelectionDuringEditing = true
        return tableView
    }()
    
    private let noPlaylistsView : AlertLabelView = AlertLabelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
        setupNoPlaylistView()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
    }
    

     func showCreatePlaylistAlert(){
        let alert = UIAlertController(title: "New Playlists", message: "Enter information", preferredStyle: .alert)
        alert.addTextField { text in
            text.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            guard let fieldOne = alert.textFields?.first,
                  let name = fieldOne.text,
                  !name.trimmingCharacters(in: .whitespaces).isEmpty else {return}
            self?.viewModel.update = {
                HapticksManager.shared.vibrate(for: .success)
                self?.tableView.reloadData()
                
            }
            self?.viewModel.failure = {
                let alert = UIAlertController(title: "Failure", message: "Something went wrong. Please try again later", preferredStyle: .alert)
                HapticksManager.shared.vibrate(for: .warning)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(alert, animated: true)
            }
            
            self?.viewModel.createPlaylist(with: name)
            
        }))
        present(alert, animated: true)
    }
    
    
//MARK: - setupView
    private func setupView(){
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.update = updateUI
        viewModel.getCurrentUserPlaylists()
       
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonDidTap))
        }

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        tableView.addGestureRecognizer(gesture)
        
    }
    
    
    
    private func updateUI(){
        if viewModel.playlists.isEmpty{
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            tableView.isHidden = false
            noPlaylistsView.isHidden = true
        }
    }
    
    private func setupNoPlaylistView(){
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        noPlaylistsView.setup(with: AlertLabelViewViewModel(text: "You don`t have any playlists yet", actionTitle: "Create"))
    }
    

  
    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }
    
    //MARK: - didLongPress
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {return}
        let touchPoint = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: touchPoint) else {
            return
        }
        let playlist = viewModel.playlists[indexPath.row]
        showRemoveAlert(playlist: playlist, by: indexPath)
        
    }
    
    private func showRemoveAlert(playlist: Playlist, by indexPath: IndexPath){
        let actionSheet = UIAlertController(title: playlist.name, message: "Woud you like to remove this playlist?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self]  _ in
            DispatchQueue.main.async {
                self?.viewModel.update = {
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.tableView.reloadData()
                }
                
                self?.viewModel.deletePlaylist(index: indexPath.row)
            }
            
        }))
        present(actionSheet, animated: true)
    }
    
    private func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style){
         let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
         self.present(alert, animated: true)
     }
    

}

//MARK: - extension AlertLabelViewDelegate
extension LibraryPlaylistsViewController : AlertLabelViewDelegate {
    func addButtonDidTap(_ alertView: AlertLabelView) {
      showCreatePlaylistAlert()
    }
 
}

//MARK: - extension UITableViewDelegate
extension LibraryPlaylistsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticksManager.shared.vibrateForSelection()
        guard selectionHandler == nil else {
            selectionHandler?(viewModel.playlists[indexPath.row])
            dismiss(animated: true)
            return
        }
        let playlist = viewModel.playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        vc.isOwner(value: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - extension UITableViewDataSource
extension LibraryPlaylistsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SubtitleTableViewCell.self)", for: indexPath) as? SubtitleTableViewCell else {return .init()}
        
        let playlist = viewModel.playlists[indexPath.row]
        cell.configure(with: SubtitleTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.displayName, imageURL: URL(string: playlist.images?.first?.url ?? " ")))
        return cell
    }
    
    
    
  
}
