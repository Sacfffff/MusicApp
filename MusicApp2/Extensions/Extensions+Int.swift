//
//  Extensions+Int.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 20.09.22.
//

import Foundation

extension Int {
    
    func milisecondsToString() -> String {
       let seconds = self % 60
       let minutes = (self / 60) % 60
        return "\(minutes.correctFormatStrings()):\(seconds.correctFormatStrings())"
    }
    
    func correctFormatStrings() -> String {
        return self >= 10 ? "\(self)" : "0\(self)"
    }
}
