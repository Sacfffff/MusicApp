//
//  Extensions+ UIView.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 13.06.22.
//

import UIKit

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height : CGFloat {
        return frame.self.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right : CGFloat {
        return left + width
    }
    
    var top : CGFloat {
        return frame.origin.y
    }
    
    var bottom : CGFloat {
        return top + height
    }
}
