//
//  SearchPage.swift
//  OnlineHackathon
//
//  Created by Ruslan Ismailov on 12/12/22.
//

import UIKit
import Moya
import Kingfisher

class SearchPage: UIViewController {
    
    var searchPhoto: [PhotoModel] = []
    
    let requester = MoyaProvider<PixelsEnum>()
    var currentPage: Int = 1
    var textInSearchBar: String = ""
    
    var searchActive : Bool = false
    var isDone: Bool = false
    
    lazy var searchBar:UISearchBar = {
        /* add search bar*/
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width - 20, height: 50))
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.backgroundColor = .white.withAlphaComponent(0.8)
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.layer.cornerRadius = 5

        searchBar.delegate = self
        navigationItem.titleView = searchBar
        /* end*/

        return searchBar
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let countOfCell = 2
        let sizeToCell = (Int(UIScreen.main.bounds.width - 30) - (countOfCell * 10)) / countOfCell
        
        layout.itemSize = CGSize(width: sizeToCell, height: sizeToCell)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(searchBar)
        navigationItem.hidesSearchBarWhenScrolling = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.reloadData()
    }
    

    override func viewDidLayoutSubviews() {
        searchBar.becomeFirstResponder()
        
        let safeArea = view.layoutMarginsGuide
        
        searchBar.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
    }
    
    private func searchPhoto(for name: String, page: Int){
        requester.request(.search(searchRequest: name, page: page)) { result in
        switch result {
        case .success(let respond):
            let result = try! JSONSerialization.jsonObject(with: respond.data)
            guard let jsonData = result as? [String: Any] else {return}
            let photos = Photos(JSON: jsonData)
            
            for item in photos!.photos{
                self.searchPhoto.append(item)
            }
            self.collectionView.reloadData()
        case .failure(let error):
            print("search error \(error)")
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let nextPage = currentPage + 1
        searchPhoto(for: textInSearchBar, page: nextPage)
        currentPage = nextPage
        collectionView.reloadData()
    }
}


extension SearchPage: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchPhoto = []
            collectionView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.searchBar.showsCancelButton = false
        
        collectionView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        self.searchBar.showsCancelButton = true
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count > 0 {
            searchPhoto = []
            searchPhoto(for: searchBar.text!, page: currentPage)
            textInSearchBar = searchBar.text!
            collectionView.reloadData()
        }
        self.searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
}


extension SearchPage: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? FirstCollectionViewCell {
            
            DispatchQueue.main.async {
                
                let url = URL(string: self.searchPhoto[indexPath.row].photoSize!.tiny)
                
                cell.image.kf.setImage(with: url)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let openPhotoPage = OpenPhotoPage()
        
        DispatchQueue.main.async {
            openPhotoPage.photoTitle.text = self.searchPhoto[indexPath.row].title
            let url = URL(string: self.searchPhoto[indexPath.row].photoSize!.portrait)
            openPhotoPage.image.kf.setImage(with: url)
            openPhotoPage.photographer.text = self.searchPhoto[indexPath.row].photographer
            openPhotoPage.linkToPhotographer.text = self.searchPhoto[indexPath.row].linkToPhotographer
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
