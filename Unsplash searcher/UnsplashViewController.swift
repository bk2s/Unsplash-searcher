//
//  UnsplashViewController.swift
//  Unsplash searcher
//
//  Created by ┬áStepanok Ivan on 15.10.2021.
//

import UIKit
import SwiftyJSON
import Alamofire


class UnsplashViewController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, PinterestLayoutDelegate {
    
    var perPage: Int = 16
    
    @IBOutlet weak var loadingProgress: UIProgressView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var result: [UIImage]?
    var arrayOfHeight: [CGFloat]?
    var search = "wallpaper 4k"
    var selected = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.delegate = self
        
        loadingProgress.isHidden = true
        
        
        loadData(searchRequest: search)

        
    }
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
         super.awakeFromNib()

        

     }
    
    override func viewDidLayoutSubviews() {
        print("111")
        if let layount =  collectionView.collectionViewLayout as? PinterestLayout {
            layount.delegate = self
            layount.collectionView?.collectionViewLayout.invalidateLayout()
////            //collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    
    func loadData(searchRequest: String) {
        
        DispatchQueue.global().sync {
            AFRequest.heightRequest(search: searchRequest, page: "1", perPage: self.perPage) { arrayOfHeight in
                self.arrayOfHeight = arrayOfHeight
                print(arrayOfHeight)
            }
        }
        
        DispatchQueue.global().sync {
            AFRequest.sendUnsplashRequest(search: searchRequest, page: "1", perPage: self.perPage) { unsplashJSON in
                self.result = unsplashJSON
                
                DispatchQueue.main.async {
                    self.loadingProgress.isHidden = false
                    self.loadingProgress.progress = Float(Double(unsplashJSON.count) / Double(self.perPage))
                    
                    if unsplashJSON.count >= self.perPage - 1 {
                        self.loadingProgress.isHidden = true
                    }
                    
                }
                
                
                DispatchQueue.main.async {
                    print("đčđ░đ╗đ╗ĐâđŻđ┤ĐÇđ░đ░đ░đ░!!!")
                   // self.collectionView.reloadItems(at: [IndexPath(item: self.result!.count, section: 0)])
                   // print(self.result?[0].size)
                    self.collectionView.reloadData()
                    
                }
            }
        }
        
        
        
    }
    
    
    
    
    @IBAction func reloadPressed(_ sender: UIBarButtonItem) {
        
        
        
    }
    
    
    


     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
         print("đíđÁđ╣Đçđ░Đü ĐĆ đĚđŻđ░ĐÄ đ┐ĐÇđż")
         print(result?.count)
         return result?.count ?? perPage - 1
    }

    
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! imageCell
             if let result = self.result {
                 print("đčđżđ┤đ│ĐÇĐâđĚđ║đ░ đ║đ░ĐÇĐéđŞđŻđ║đŞ đŞđĚ đ║đÁĐłđ░ Ôäľ\(indexPath.row)")
                 DispatchQueue.main.async {
                     cell.thumbnailCell.image = result[indexPath.row]
                 }
             }
        cell.layer.cornerRadius = 14
        cell.clipsToBounds = true
        // đĹđÁđĚ ĐŹĐéđżđ│đż ÔÇô Đüđ║ĐÇĐâđ│đ╗đÁđŻđŞĐĆ đ▒Đâđ┤ĐâĐé đŻđÁ đżĐçđÁđŻĐî
        cell.thumbnailCell.contentMode = .scaleAspectFill
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.row
        print("đóđź đŁđÉđľđÉđŤ đŁđÉ \(indexPath.row)")
        performSegue(withIdentifier: "goImage", sender: nil)
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! LargeImageViewController
        destinationVC.page = "1"
        destinationVC.search = search
        destinationVC.imgNum = selected
        destinationVC.perPage = perPage
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {

//        if let arrayOfHeight = arrayOfHeight {
//            return arrayOfHeight[indexPath.row]  / 20
//        } else {
//            return 0
//        }
        
        if let result = result {
            return result[indexPath.row].size.height / 2
        } else {
            return 0
        }
        
        
        
    }
    
    
    
}



extension UnsplashViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Hello")
        
        if searchBar.text != "" {
        
        result = []
        arrayOfHeight = []
        
            search = searchBar.text!
            title = searchBar.text!
            
        
            self.loadData(searchRequest: searchBar.text!)
        } else {
            
        }
        
        DispatchQueue.main.async {
            // đúđ▒đŞĐÇđ░đÁĐé đ║đ╗đ░đ▓đŞđ░ĐéĐâĐÇĐâ Đâđ▒đŞĐÇđ░ĐĆ đ┐đżđŞĐüđ║ Đü đ┐đÁĐÇđ▓đżđ│đż đ╝đÁĐüĐéđ░. đÜđ░đ║ đ▒Đő Đüđ▓đÁĐÇđ│đ░ĐĆ đÁđ│đż đ▓đ╗đ░ĐüĐéĐî))
            searchBar.resignFirstResponder()
        }
        
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text == ""{

            collectionView.reloadData()
            
            // đŚđ░đ┐ĐâĐüđ║đ░đÁđ╝ đ║đżđ╝đ░đŻđ┤Đâ đ▓ đżĐüđŻđżđ▓đŻđżđ╝ đ┐đżĐéđżđ║đÁ.
            DispatchQueue.main.async {
                // đúđ▒đŞĐÇđ░đÁĐé đ║đ╗đ░đ▓đŞđ░ĐéĐâĐÇĐâ Đâđ▒đŞĐÇđ░ĐĆ đ┐đżđŞĐüđ║ Đü đ┐đÁĐÇđ▓đżđ│đż đ╝đÁĐüĐéđ░. đÜđ░đ║ đ▒Đő Đüđ▓đÁĐÇđ│đ░ĐĆ đÁđ│đż đ▓đ╗đ░ĐüĐéĐî))
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
}
