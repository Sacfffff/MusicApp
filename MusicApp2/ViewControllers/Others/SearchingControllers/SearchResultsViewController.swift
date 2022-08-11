//
//  SearchResultViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

protocol SearchResultsViewControllerDelegate : AnyObject {
    func resultSectionDidTap(_ resultSection: SearchResult)
}

class SearchResultsViewController: UIViewController {
    

    private var viewModel : SearchResultViewModelProtocol = SearchResultViewModel()
    
    private let tableView : UITableView = {
        let tableView =  UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: "\(SearchResultDefaultTableViewCell.self)")
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "\(SubtitleTableViewCell.self)")
        tableView.isHidden = true
        return tableView
    }()
    
    weak var delegate : SearchResultsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
  
    func configure(with results: [SearchResult]){
        viewModel.update = tableView.reloadData
        viewModel.configure(with: results)
        tableView.isHidden = viewModel.isHidden
    }
    
    func setupView(){
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = viewModel.isHidden
        addLongTypeGesture()
    }
    
    private func addLongTypeGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        tableView.addGestureRecognizer(gesture)
    }
    
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else {return}
        let touchPoint = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: touchPoint), indexPath.section == 0 else {return}
        let result = viewModel.sections[indexPath.section].results[indexPath.row]
        switch result {
        case .track( let model):
            viewModel.addTrack(track: model, self)
        default: return
        }
       
        
    }
  
  
}


//MARK: - extension UITableViewDataSource
extension SearchResultsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let results = viewModel.sections[indexPath.section].results[indexPath.row]
        switch results {
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchResultDefaultTableViewCell.self)", for: indexPath) as? SearchResultDefaultTableViewCell else {return .init()}
            cell.configure(with: SearchResultDefaultTableCellViewModel(title: artist.name, imageURL: URL(string: artist.images?.first?.url ?? " ")))
            return cell
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SubtitleTableViewCell.self)", for: indexPath) as? SubtitleTableViewCell else {return .init()}
            cell.configure(with: SubtitleTableViewCellViewModel(title: album.name, subtitle: album.artists.first?.name ?? "-", imageURL: URL(string: album.images.first?.url ?? " ")))
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SubtitleTableViewCell.self)", for: indexPath) as? SubtitleTableViewCell else {return .init()}
            cell.configure(with: SubtitleTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.displayName, imageURL: URL(string: playlist.images?.first?.url ?? " ")))
            return cell
        case .track(let song):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SubtitleTableViewCell.self)", for: indexPath) as? SubtitleTableViewCell else {return .init()}
            cell.configure(with: SubtitleTableViewCellViewModel(title: song.name, subtitle: song.artists.first?.name ?? "-", imageURL: URL(string: song.album?.images.first?.url ?? " ")))
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
}


//MARK: - extension UITableViewDelegate
extension SearchResultsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let results = viewModel.sections[indexPath.section].results[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.resultSectionDidTap(results)
        
    }
}
