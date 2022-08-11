//
//  AddTracksControls.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 25.07.22.
//

import UIKit

final class AddTracksControls {
    
    private let fetchServicePlaylist : FetchDataServicePlaylist = FetchDataServicePlaylist()
    private var vc : UIViewController?
    
   
    
    func showAlertSheetForChosenTrack(track: AudioTrack, vc: UIViewController){
        self.vc = vc
        let actionSheet = UIAlertController(title: track.name, message: "Would you like to add this to a playlist?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Add to playlist", style: .default, handler: { [weak self]  _ in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistsViewController()
                vc.selectionHandler = { playlist in

                    self?.addTrack(track: track, to: playlist)
                    
                    
                }
                vc.title = "Select Playlist"
                self?.vc?.present(UINavigationController(rootViewController: vc), animated: true)
                
                
            }
        }))
        self.vc?.present(actionSheet, animated: true)
    }
    
    private func alert(title: String?, message: String?, preferredStyle: UIAlertController.Style){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.vc?.present(alert, animated: true)
        }

        
    }
    
   private func addTrack(track: AudioTrack, to playlist: Playlist) {
       fetchServicePlaylist.isExistedCurrentTrack(track: track, to: playlist) { [weak self] isExisted in
           if isExisted {
               HapticksManager.shared.vibrate(for: .warning)
               self?.alert(title: "Failure", message:  "Maybe you`ve already added this track to your playlist?", preferredStyle: .alert)
               return
           } else {
               self?.fetchServicePlaylist.fetchDataAddTrackToPlaylist(track: track, playlist: playlist) { [weak self] success in
                   if !success {
                       HapticksManager.shared.vibrate(for: .warning)
                       self?.alert(title: "Failure", message:  "Something went wrong. Try again later.", preferredStyle: .alert)
                   }

               }

           }
       }
        
    }
    
}
