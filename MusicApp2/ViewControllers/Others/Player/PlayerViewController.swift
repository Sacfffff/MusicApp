//
//  PlayerViewController.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit
import SDWebImage


protocol PlayerViewControllerDelegate : AnyObject {
    func playPauseButtonDidTap()
    func goForward()
    func goBackward()
    func sliderDidSlide(_ value: Float)
    func cancelButtonDidTap()
    
}

class PlayerViewController: UIViewController {
    
    private var viewModel : PlayerViewModelProtocol = PlayerViewModel()
    
    weak var dataSource : PlayerPresenterDataSource?
    weak var delegate : PlayerViewControllerDelegate?
    
  
   
    
    private let imageView : UIImageView = {
        let imageView  = UIImageView(image: UIImage(systemName: "photo"))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let controlsView : PlayerControlsView = {
        let view = PlayerControlsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureBarButtons()
        configure()

      
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
       

    }
  

    private func setupView(){
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        view.addSubview(spinner)
        controlsView.delegate = self
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        

    }
    
    
    private func configure(){
        imageView.sd_setImage(with: URL(string: dataSource?.track?.album?.images.first?.url ?? " "))
        controlsView.configure(with: PlayerControlsViewViewModel(title: dataSource?.track?.name, subtitle: dataSource?.track?.artists.first?.name))
    }
    
    private func configureBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonDidtap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonDidTap))
        navigationItem.rightBarButtonItem?.tintColor = .secondaryLabel
    }
    
    
    private func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style){
         let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
         self.present(alert, animated: true)
     }
    
    @objc private func didSwipe(_ recognizer: UIGestureRecognizer){
        guard let swipe = recognizer as? UISwipeGestureRecognizer else {return}
        switch swipe.direction {
        case .right:
          delegate?.goBackward()
        case .left:
        delegate?.goForward()
        default:
            return
        }
    }
    
    @objc private func closeButtonDidtap(){
        dismiss(animated: true)
        delegate?.cancelButtonDidTap()
    }
    
    @objc private func actionButtonDidTap(){
        guard let url = URL(string: dataSource?.track?.externalURLs["spotify"] ?? " ") else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [url],
                                                  applicationActivities: [])
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true)
    }
    
    private func setupConstraints(){
      
        NSLayoutConstraint.activate(
            [
                //imageView
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
                imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
                imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: view.widthAnchor),
                
                //controlsView
                controlsView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.0),
                controlsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5.0),
                controlsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5.0),
                controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
                
                //spinner
                spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),

        ])
   }
}

//MARK: - extension PlayerControlsViewDelegate
extension PlayerViewController : PlayerControlsViewDelegate {
    func addToPlaylistButtonDidTap(_ playerControlsView: PlayerControlsView) {
        guard let track = dataSource?.track else { return}
        viewModel.addTrack(track: track, self)
    }
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didUpdateVolume value: Float) {
       delegate?.sliderDidSlide(value)
    }
    
    func playPauseDidTapInViewControllers(_ playerControlsView: PlayerControlsView) {
        delegate?.playPauseButtonDidTap()
    }
    
    func nextButtonDidTapInViewControllers(_ playerControlsView: PlayerControlsView) {
        delegate?.goForward()
    }
    
    func backwardButtonDidTapInViewControllers(_ playerControlsView: PlayerControlsView) {
        
        delegate?.goBackward()
    }
    
    
}

//MARK: - extension PlayerDelegate
extension PlayerViewController : PlayerDelegate {
    func loadedTracks() {
        spinner.stopAnimating()
    }
    
    func loadingTracks() {
        spinner.startAnimating()
    }
    
    func failedLodingTracks() {
        alert(title: "Error", message: "Oops, something went wrong. Please, try again", preferredStyle: .alert)
    }
    
    func cancelLodingTracks() {
        alert(title: "Error", message: "Loading had been canseled", preferredStyle: .alert)
    }
    
    func updateUI() {
        configure()
    }
    
    
}
