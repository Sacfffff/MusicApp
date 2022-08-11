//
//  Player.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 14.07.22.
//

import AVFoundation

protocol PlayerDelegate : AnyObject {
    func loadingTracks()
    func loadedTracks()
    func failedLodingTracks()
    func cancelLodingTracks()
    func updateUI()
}


final class Player {
    
    weak var delegatePlayerController : PlayerDelegate?
    private var player : AVPlayer?
    private var currentPlayerItems : [AVPlayerItem] = [] {
        didSet {
            delegatePlayerController?.updateUI()
        }
    }
    private var indexTracks : Int {
       let currentAVAsset = playerQueue?.currentItem?.asset as? AVURLAsset
       return self.tracks.firstIndex(where: { URL(string: $0.previewURL ?? " ") == currentAVAsset?.url}) ?? 0
    }
    private var indexItem = 0
    private var playerQueue : AVQueuePlayer?
    private var track: AudioTrack?
    private var tracks : [AudioTrack] = []
    private var currentTrack : AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            
            return tracks[indexTracks]
        }
        
        return nil
    }
 
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.player = nil
        self.playerQueue = nil
    }
    
    func playTrack(with track: AudioTrack){
        resetPlayers()
        guard let url = URL(string: track.previewURL ?? " ") else {return}
        self.track = track
        self.tracks = []
        createPlayer(with: url)
     
    }
    
    func playTracks(with tracks : [AudioTrack]){
        resetPlayers()
        self.tracks = tracks
        self.track = nil
        createPlayerQueue(with: tracks)
    }
    
    func getCurrentTrack() -> AudioTrack? {
       
        return currentTrack
    }
    
    private func createPlayer(with url: URL){
        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(url: url)
            do {
                self?.player?.volume = 0.5
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowAirPlay,.defaultToSpeaker, .mixWithOthers, .duckOthers])
                try AVAudioSession.sharedInstance().setActive(true)
                self?.player?.play()
            } catch {
                print(error)
            }
        }

   }
    
     private func createPlayerQueue(with tracks: [AudioTrack]){
        self.playerQueue = AVQueuePlayer()
        let tracksURL = tracks.compactMap ({
           return URL(string: $0.previewURL ?? " ") })
        
        tracksURL.forEach({makeItem(url: $0)})
       

    }
    
    
    private func makeItem(url: URL){
        let avAsset = AVURLAsset(url: url)
        avAsset.loadValuesAsynchronously(forKeys: ["tracks", "duration", "playable"]) { [weak self] in
            let status = avAsset.statusOfValue(forKey: "playable", error: nil)
            switch status {
            case .loading:
                DispatchQueue.main.async {
                    self?.delegatePlayerController?.loadingTracks()
                }
                break
            case .loaded:
                DispatchQueue.main.async {
                    self?.delegatePlayerController?.loadedTracks()
                    self?.enqueue(avAsset: avAsset)
                }
                break
            case .failed:
                DispatchQueue.main.async {
                    self?.delegatePlayerController?.failedLodingTracks()
                }
                break
            case .cancelled:
                DispatchQueue.main.async {
                    self?.delegatePlayerController?.cancelLodingTracks()
                }
                break
            default:
                return
            }
            

        }
        
    }
    
    private func enqueue(avAsset: AVURLAsset){
        let item = AVPlayerItem(asset: avAsset)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        self.playerQueue?.insert(item, after: nil)
        currentPlayerItems.append(item)
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()
        
       
    }
    
    @objc private func playerDidFinishPlaying(sender: Notification){
        goForward()
    }
    
    private func resetPlayers(){
        self.player = nil
        self.playerQueue = nil
        self.currentPlayerItems = []
    }
}


//MARK: - extension PlayerViewControllerDelegate
extension Player : PlayerViewControllerDelegate {
    
    func cancelButtonDidTap() {
        resetPlayers()

    }
    
    
    func sliderDidSlide(_ value: Float) {
        player?.volume = value
        playerQueue?.volume = value
    }
    
    
    func playPauseButtonDidTap() {
        if let player = player {
            switch player.timeControlStatus {
            case .playing :
                player.pause()
            case .paused:
                player.play()
            default:
                return
            }
        } else if let player = playerQueue {
            switch player.timeControlStatus {
            case .playing :
                player.pause()
            case .paused:
                player.play()
                
            default:
               return
            }
        }
        
    }
    
    func goForward() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else if let player = playerQueue {
                player.advanceToNextItem()
                self.indexItem += self.indexItem == self.currentPlayerItems.count - 1 ? 0 : 1
                self.delegatePlayerController?.updateUI()
            
           
        }
        
    }
    
    func goBackward() {
        if tracks.isEmpty{
            player?.pause()
            player?.play()
        } else if let player = playerQueue {
               self.indexItem -= self.indexItem <= 0 ? 0 : 1
            player.advanceToPreviousItem(at: self.indexItem, with: self.currentPlayerItems)
                self.delegatePlayerController?.updateUI()
          
            }
  
    }
    


}




