//
//  FirstPage.swift
//  OnlineHackathon
//
//  Created by Ruslan Ismailov on 07/12/22.
//

import UIKit
import Moya
import Kingfisher


class FirstPage: UIViewController {
    
    var allPhoto: [PhotoModel] = []
    
    var currentPage: Int = 1
    
    let requester = MoyaProvider<PixelsEnum>()
    
    var numOfColumn: Int = 0
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let countOfCell = 2
        let sizeToCell = (Int(UIScreen.main.bounds.width - 30) - (countOfCell * 10)) / countOfCell
        
        layout.itemSize = CGSize(width: sizeToCell, height: sizeToCell)
        
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
//        cv.backgroundColor = .systemIndigo
        
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        view.backgroundColor = .white
        
//        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchStart(sender:)))
        
//        searchPhoto(for: "Ocean")
        collectionView.reloadData()
    }
    
//    @objc private func pinchStart(sender: UIPinchGestureRecognizer){
//        var current: CGFloat = 0
//        if (sender.state == .began){
//            current = sender.scale
//        }
//        if (sender.state == .ended){
//            let changedScale = sender.scale
////            current > changedScale ? numOfColumn + 1 : numOfColumn - 1
//        }
//    }
    
    override func viewDidLayoutSubviews() {
        let safeArea = view.layoutMarginsGuide
        
        requestApi(currentPage: currentPage)
        
        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
    }
    
    private func requestApi(currentPage: Int){
        requester.request(.getPhoto(perPage: 30, page: currentPage)) { result in
            switch result{
            case .success(let respond):
                let result = try! JSONSerialization.jsonObject(with: respond.data, options: [])
                guard let jsonData = result as? [String:Any] else {return}
                
                let photos = Photos(JSON: jsonData)
                
                for item in photos!.photos{
                    self.allPhoto.append(item)
                }
                self.collectionView.reloadData()
                
            case .failure(let error):
                print("request error \(error)")
            }
        }
    }
    
}


extension FirstPage: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? FirstCollectionViewCell {
            
            DispatchQueue.main.async {
                
                let url = URL(string: self.allPhoto[indexPath.row].photoSize!.tiny)
                
                cell.image.kf.setImage(with: url)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let nextPage = currentPage + 1
        requestApi(currentPage: nextPage)
        currentPage = nextPage
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let openPhotoPage = OpenPhotoPage()
        
        DispatchQueue.main.async {
            openPhotoPage.photoTitle.text = self.allPhoto[indexPath.row].title
            let url = URL(string: self.allPhoto[indexPath.row].photoSize!.portrait)
            openPhotoPage.image.kf.setImage(with: url)
            openPhotoPage.photographer.text = self.allPhoto[indexPath.row].photographer
            openPhotoPage.linkToPhotographer.text = self.allPhoto[indexPath.row].linkToPhotographer
        }
        
        openPhotoPage.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(backBtn))
        
        let navBar = UINavigationController(rootViewController: openPhotoPage)
        navBar.modalTransitionStyle = .crossDissolve
        navBar.modalPresentationStyle = .fullScreen
        
        present(navBar, animated: true)
        
        collectionView.reloadData()
    }
    
    @objc private func backBtn(){
        //TabBar took over all the actions
    }
    
}
