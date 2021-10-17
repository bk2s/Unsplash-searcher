//
//  LargeImageViewController.swift
//  Unsplash searcher
//
//  Created by  Stepanok Ivan on 17.10.2021.
//

import UIKit

class LargeImageViewController: UIViewController {

    var search: String?
    var page: String?
    var imgNum: Int?
    var perPage: Int?
    
    @IBOutlet weak var largeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        largeImageView.contentMode = .scaleAspectFit
        
        AFRequest.loadLargeImage(search: search!, page: page!, imgNumber: imgNum!, perPage: perPage!) { largeImage in
            DispatchQueue.main.async {
                self.largeImageView.image = largeImage
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    

}
