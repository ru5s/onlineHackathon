//
//  FirstCollectionViewCell.swift
//  OnlineHackathon
//
//  Created by Ruslan Ismailov on 09/12/22.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(image)
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        image.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        
        contentView.backgroundColor = .blue.withAlphaComponent(0.25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
