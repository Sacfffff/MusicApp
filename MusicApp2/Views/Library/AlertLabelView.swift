//
//  AlertView.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 16.07.22.
//

import UIKit

protocol AlertLabelViewDelegate : AnyObject {
    func addButtonDidTap(_ alertView: AlertLabelView)
}

class AlertLabelView: UIView {
    
    weak var delegate : AlertLabelViewDelegate?
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let addButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
        addSubview(addButton)
        addSubview(titleLabel)
        addButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setup(with model: AlertLabelViewViewModel){
        titleLabel.text = model.text
        addButton.setTitle(model.actionTitle, for: .normal)
    }
    
    @objc private func addButtonDidTap(){
        delegate?.addButtonDidTap(self)
    }
    
    private func setupConstraints(){
        
      
        
        NSLayoutConstraint.activate(
            [
                
                //titleLabel
                titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
                titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                titleLabel.widthAnchor.constraint(equalToConstant: self.width),
               
                
                //addButton
                addButton.widthAnchor.constraint(equalToConstant: self.width),
                addButton.heightAnchor.constraint(equalToConstant: 40.0),
                addButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            ])
    }
}
