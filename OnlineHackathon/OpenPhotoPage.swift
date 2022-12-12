//
//  OpenPhotoPage.swift
//  OnlineHackathon
//
//  Created by Ruslan Ismailov on 10/12/22.
//

import UIKit

class OpenPhotoPage: UIViewController {
    
    let photoTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 25)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .gray
        return image
    }()
    
    let photographer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 23)
        label.textColor = .darkGray
        label.textAlignment = .right
        
        return label
    }()
    
    let linkToPhotographer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica", size: 20)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(photoTitle)
        view.addSubview(image)
        view.addSubview(photographer)
        view.addSubview(linkToPhotographer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClicLabel(sender:)))
        linkToPhotographer.isUserInteractionEnabled = true
        linkToPhotographer.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        let safeArea = view.layoutMarginsGuide
        
        photoTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        photoTitle.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
        photoTitle.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0).isActive = true
        
        image.topAnchor.constraint(equalTo: photoTitle.bottomAnchor, constant: 10).isActive = true
        image.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
        image.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0).isActive = true
        image.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        photographer.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 30).isActive = true
        photographer.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
        
        linkToPhotographer.topAnchor.constraint(equalTo: photographer.bottomAnchor, constant: 10).isActive = true
        linkToPhotographer.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
        linkToPhotographer.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0).isActive = true
        
        
    }
    
    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        openUrl(urlString: linkToPhotographer.text)
    }
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
