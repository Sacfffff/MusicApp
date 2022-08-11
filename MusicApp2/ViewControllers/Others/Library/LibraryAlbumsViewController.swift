//
//  LibraryAlbumsViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 15.07.22.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    private var viewModel : LibraryAlbumViewModelProtocol = LibraryAlbumViewModel()
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "\(SubtitleTableViewCell.self)")
        tableView.isHidden = true
        tableView.rowHeight = 60.0
        tableView.allowsSelectionDuringEditing = true
        return tableView
    }()
    
    private let noAlbumsView : AlertLabelView = AlertLabelView()
    

    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupView()
        setupNoAlbumsView()
        addGesture()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        noAlbumsView.frame = CGRect(x: (view.width - 150)/2, y: (view.height - 150)/2, width: 150, height: 150)
    }
    
 //MARK: - setupView
    private func setupView(){
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.update = updateUI
       viewModel.getCurrentUserAlbums()
        viewModel.observer = NotificationCenter.default.addObserver(forName: .albumChangedNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.viewModel.update = self?.updateUI
            self?.viewModel.getCurrentUserAlbums()
        })
        
      
        
     
    }
    
    private func updateUI(){
        if viewModel.albums.isEmpty{
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            tableView.isHidden = false
            noAlbumsView.isHidden = true
        }
    }
    
    private func setupNoAlbumsView(){
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.setup(with: AlertLabelViewViewModel(text: "You have not saved any albums yet.", actionTitle: "Browse"))
    }
    

    //MARK: - addGesture
    private func addGesture(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        tableView.addGestureRecognizer(gesture)
    }
    
   
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {return}
        let touchPoint = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: touchPoint) else {
            return
        }
        let album = viewModel.albums[indexPath.row]
        showRemoveAlert(album: album, by: indexPath)
        
    }
    
    @objc private func closeButtonDidTap() {
        dismiss(animated: true)
    }
    

    //MARK: - showRemoveAlert
    
    private func showRemoveAlert(album: Album, by indexPath: IndexPath){
        let actionSheet = UIAlertController(title: album.name, message: "Woud you like to remove this album?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self]  _ in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                strongSelf.viewModel.update = {
                    HapticksManager.shared.vibrate(for: .success)
                    self?.viewModel.albums.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.tableView.reloadData()
                }
                strongSelf.viewModel.failure = {
                    HapticksManager.shared.vibrate(for: .warning)
                    strongSelf.alert(title: "Failure", message: "Something went wrong. Please try again later", preferredStyle: .alert)
                }
                self?.viewModel.deleteAlbum(album: album)
               
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
extension LibraryAlbumsViewController : AlertLabelViewDelegate {
    func addButtonDidTap(_ alertView: AlertLabelView) {
        tabBarController?.selectedIndex = 0
    }
 
}

//MARK: - extension UITableViewDelegate
extension LibraryAlbumsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticksManager.shared.vibrateForSelection()
        let album = viewModel.albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - extension UITableViewDataSource
extension LibraryAlbumsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SubtitleTableViewCell.self)", for: indexPath) as? SubtitleTableViewCell else {return .init()}
        
        let album = viewModel.albums[indexPath.row]
        cell.configure(with: SubtitleTableViewCellViewModel(title: album.name, subtitle: album.artists.first?.name ?? "--", imageURL: URL(string: album.images.first?.url ?? " ")))
        return cell
    }
    
    
    
  
}

    
    

