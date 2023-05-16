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
    
    var pinchGesture = UIPinchGestureRecognizer()
    
    let margin: CGFloat = 5
    var cellsPerRow = 3
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showStatusAlert()
        //add collection view
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //end
        
//        view.backgroundColor = .white
        
        pinchGesture.delegate = self
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchStart(sender:)))
        view.addGestureRecognizer(pinchGesture)

        collectionView.reloadData()
    }
    
    @objc private func pinchStart(sender: UIPinchGestureRecognizer){
        var pinchScale = pinchGesture.scale
        pinchScale = round(pinchScale * 1000) / 1000
        
        if pinchGesture.state == .ended {
            if pinchScale > 1 {
                cellsPerRow < 2 ? (cellsPerRow = 1) : (cellsPerRow -= 1)
                flowLayout(cellsPerRow)
                collectionView.reloadData()
            }else{
                cellsPerRow > 3 ? (cellsPerRow = 4) : (cellsPerRow += 1)
                flowLayout(cellsPerRow)
                collectionView.reloadData()
            }
            
        }
    }
    
    private func showStatusAlert(){
        let alert = UIAlertController(title: "Pinch mode", message: "You can use in photo stock", preferredStyle: .alert)
        
        let image = UIImageView(frame: CGRect(x: 10, y: 70, width: 200, height: 200))
        image.image = UIImage(named: "Pinch_zoom")
        alert.view.addSubview(image)
        
        image.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -10).isActive = true

        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
            
        }
    
    
    override func viewDidLayoutSubviews() {
        let safeArea = view.layoutMarginsGuide
        //add item size to collection view
        flowLayout(cellsPerRow)
        //end
        
        requestApi(currentPage: currentPage)
        
        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
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


extension FirstPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        print("++ scroll")
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

extension FirstPage: UIGestureRecognizerDelegate{
    func flowLayout (_ perColumn: Int) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        let marginAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginAndInsets) / CGFloat(perColumn)).rounded(.down)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
}
