//
//  HapticksManager.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//
import UIKit

final class HapticksManager {
    
    static let shared = HapticksManager()
    
    
    private init(){}
    
     func vibrateForSelection(){
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
     func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
