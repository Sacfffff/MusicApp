//
//  PlayerControlsView.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 11.07.22.
//

import UIKit
import MarqueeLabel

protocol PlayerControlsViewDelegate : AnyObject {
    func playPauseDidTapInViewControllers(_ playerControlsView : PlayerControlsView)
    func nextButtonDidTapInViewControllers(_ playerControlsView : PlayerControlsView)
    func backwardButtonDidTapInViewControllers(_ playerControlsView : PlayerControlsView)
    func playerControlsView(_ playerControlsView : PlayerControlsView, didUpdateVolume value: Float)
    func addToPlaylistButtonDidTap(_ playerControlsView : PlayerControlsView)
    
}

final class PlayerControlsView : UIView {
    
    weak var delegate : PlayerControlsViewDelegate?
    
    private var isPlaying : Bool = true
    
    private let volumeSlider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let titleLabel : UILabel = {
        let label = MarqueeLabel(frame: .zero, duration: 14.0, fadeLength: 10.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22.0, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backwardButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34.0, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34.0, weight: .regular))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34.0, weight: .regular))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let addToPlaylistButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34.0, weight: .regular))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      setup()
  setupButtons()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()

        
        
    }
    
    func configure(with model: PlayerControlsViewViewModel){
        titleLabel.text = "\(model.title ?? " ") "
        subtitleLabel.text = model.subtitle
    }
    
    private func setup(){
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        addSubview(subtitleLabel)
        addSubview(backwardButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        addSubview(addToPlaylistButton)
        clipsToBounds = true
       

    }
    
    private func setupButtons(){
        backwardButton.addTarget(self, action: #selector(backwardButtonDidTap), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonDidTap), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        addToPlaylistButton.addTarget(self, action: #selector(addToPlaylistButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func backwardButtonDidTap(){
        delegate?.backwardButtonDidTapInViewControllers(self)
    }
    
    @objc private func playPauseButtonDidTap(){
        self.isPlaying = !isPlaying
        updatePlayPauseButton()
        delegate?.playPauseDidTapInViewControllers(self)
        
    }
    
    @objc private func nextButtonDidTap(){
        delegate?.nextButtonDidTapInViewControllers(self)
        
    }
    
    @objc private func didSlideSlider(_ slider: UISlider){
        delegate?.playerControlsView(self, didUpdateVolume: slider.value)
    }
    
    @objc private func addToPlaylistButtonDidTap(){
        delegate?.addToPlaylistButtonDidTap(self)
    }
    
    private func updatePlayPauseButton(){
        let pause = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34.0, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34.0, weight: .regular))
        
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    
    private func setupConstraints(){
      
        NSLayoutConstraint.activate(
            [
                
                //addToPlaylist
                addToPlaylistButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 60.0),
               addToPlaylistButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30.0),
                
                //titleLabel
                titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
                titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5.0),
                titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0),
                titleLabel.heightAnchor.constraint(equalToConstant: 44.0),
                

                //subtitleLabel
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
                subtitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5.0),
                subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0),
                subtitleLabel.heightAnchor.constraint(equalToConstant: 44.0),
                
                
                //volumeSlider
                volumeSlider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20.0),
                volumeSlider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0),
                volumeSlider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0),
                volumeSlider.heightAnchor.constraint(equalToConstant: 44.0),
                
                
                
                //playPauseButton
                playPauseButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 20.0),
                playPauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                playPauseButton.heightAnchor.constraint(equalToConstant: 60.0),
                playPauseButton.widthAnchor.constraint(equalToConstant: 60.0),
                
                //backwardButton
                backwardButton.topAnchor.constraint(equalTo: playPauseButton.topAnchor),
                backwardButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0),
                backwardButton.widthAnchor.constraint(equalToConstant: 60.0),
                backwardButton.heightAnchor.constraint(equalToConstant: 60.0),
                
                //nextButton
                nextButton.topAnchor.constraint(equalTo: playPauseButton.topAnchor),
                nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20.0),
                nextButton.widthAnchor.constraint(equalToConstant: 60),
                nextButton.heightAnchor.constraint(equalToConstant: 60.0),
                
                
                
            ])
   }
}
