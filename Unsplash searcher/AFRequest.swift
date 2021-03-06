//
//  AFRequest.swift
//
//
//  Created by ┬áStepanok Ivan on 16.10.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class AFRequest {
    
    
    static func heightRequest(search: String, page: String, perPage: Int, completion: @escaping (_ arrayOfHeight: [CGFloat])->()) {
        
        
        
        let url = "https://api.unsplash.com/search/photos"
        let urlParams = [
            "client_id":"pU8BLIUc1CAVNEC1ni4KZPML0wlVO6zefkwvLTRrmFs",
            "query":search,
            "page":page,
            "per_page":"\(perPage)",
        ]
        AF.request(url, method: .get, parameters: urlParams).validate().responseJSON { (responce) in
            switch responce.result {
            case .success(let value):
                let unsplashJSON = JSON(responce.value as Any)
                var arrayOfHeight: [CGFloat] = []
                for img in 0...unsplashJSON["results"].count - 1 {
                    arrayOfHeight.append(CGFloat(unsplashJSON["results"][img]["height"].double!))
                }
                
                completion(arrayOfHeight)
                
            case .failure(let error): print(error)
            }
        }
    }
    
    
    
    
    
    
    
    static func sendUnsplashRequest(search: String, page: String, perPage: Int, completion: @escaping (_ arrayOfImages: [UIImage])->()) {
        
        let url = "https://api.unsplash.com/search/photos"
        let urlParams = [
            "client_id":"pU8BLIUc1CAVNEC1ni4KZPML0wlVO6zefkwvLTRrmFs",
            "query":search,
            "page":page,
            "per_page":"\(perPage)",
        ]
        AF.request(url, method: .get, parameters: urlParams).validate().responseJSON { (responce) in
            switch responce.result {
            case .success(let value):
                //print(value)
                let unsplashJSON = JSON(responce.value as Any)
                var arrayOfUrls: [String] = []
                for img in 0...unsplashJSON["results"].count - 1 {
                    arrayOfUrls.append((unsplashJSON["results"][img]["urls"]["small"].string)!)
                }
                print("đťđ░ĐüĐüđŞđ▓ ĐüĐüĐőđ╗đżđ║ đ┐đżđ╗ĐâĐçđÁđŻ, đŞ ĐüđżĐüĐéđżđŞĐé đŞđĚ \(arrayOfUrls.count) ĐüĐüĐőđ╗đżđ║")
                print(arrayOfUrls)
                var arrayOfImages: [UIImage] = []
                DispatchQueue.global().async {
                    
                    for link in 0...arrayOfUrls.count - 1 {
                        if let url = URL(string: arrayOfUrls[link]) {
                            print("đŚđ░đ│ĐÇĐâđĚđŞđ╗ đ║đ░ĐÇĐéđŞđŻđ║Đâ Ôäľ \(arrayOfImages.count)")
                            let data = try? Data(contentsOf: url)
                            
                                
                                print("đ┤đżđ▒đ░đ▓đŞđ╗ đ▓ đ║đżđ╗đ╗đÁđ║ĐćđŞĐÄ")
                                arrayOfImages.append(UIImage(data: data!)!)
                                completion(arrayOfImages)
                            
                        }
                    }
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    
    
    static func loadLargeImage(search: String, page: String, imgNumber: Int, perPage: Int, completion: @escaping (_ largeImage: UIImage)->()) {
        
        let url = "https://api.unsplash.com/search/photos"
        let urlParams = [
            "client_id":"pU8BLIUc1CAVNEC1ni4KZPML0wlVO6zefkwvLTRrmFs",
            "query":search,
            "page":page,
            "per_page":"\(perPage)",
        ]
        AF.request(url, method: .get, parameters: urlParams).validate().responseJSON { (responce) in
            switch responce.result {
            case .success(let value):
                //print(value)
                let unsplashJSON = JSON(responce.value as Any)
                let imgUrl = unsplashJSON["results"][imgNumber]["urls"]["regular"].url
             
                let data = try? Data(contentsOf: imgUrl!)
                DispatchQueue.global().sync {
                    
                    print("đĺĐőđ▓đÁđ╗ ĐéđÁđ▒đÁ đ║đ░ĐÇĐéđŞđŻđ║Đâ Đü đŻđżđ╝đÁĐÇđżđ╝ \(imgNumber), đ┐ĐÇđżđ▓đÁĐÇĐĆđ╣!")
                    let image = UIImage(data: data!)!
                    completion(image)
                }
                
                
            case .failure(let error): print(error)
            }
        }
    }
    
    
    
    
    
    
    
    
}
