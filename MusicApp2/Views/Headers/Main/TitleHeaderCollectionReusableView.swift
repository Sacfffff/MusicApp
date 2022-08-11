//
//  TitleHeaderCollectionReusableView.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 4.07.22.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    
    private var label : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 22.0, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    func setup(with title: String){
        label.text = title
    }
}
