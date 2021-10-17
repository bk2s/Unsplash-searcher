//
//  AFRequest.swift
//
//
//  Created by  Stepanok Ivan on 16.10.2021.
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
                print("Массив ссылок получен, и состоит из \(arrayOfUrls.count) ссылок")
                print(arrayOfUrls)
                var arrayOfImages: [UIImage] = []
                DispatchQueue.global().async {
                    
                    for link in 0...arrayOfUrls.count - 1 {
                        if let url = URL(string: arrayOfUrls[link]) {
                            print("Загрузил картинку № \(arrayOfImages.count)")
                            let data = try? Data(contentsOf: url)
                            
                                
                                print("добавил в коллекцию")
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
                    
                    print("Вывел тебе картинку с номером \(imgNumber), проверяй!")
                    let image = UIImage(data: data!)!
                    completion(image)
                }
                
                
            case .failure(let error): print(error)
            }
        }
    }
    
    
    
    
    
    
    
    
}
