//
//  AVQueuePlayer+ PreviousItem.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.07.22.
//

import AVFoundation

extension AVQueuePlayer {
    func advanceToPreviousItem(at currentIndex: Int, with initialItems: [AVPlayerItem]){
        self.removeAllItems()
        for i in currentIndex..<initialItems.count - 1 {
            let item : AVPlayerItem? = initialItems[i]
            if let item = item {
                if self.items().contains(item) {
                    
                    continue
                    
                } 
                
                self.insert(item, after: nil)
                
            }
            
        }
       
    }
}
