//
//  APIManager.swift
//  Meteo_P6
//
//  Created by mohammed ichou on 04/04/2020.
//  Copyright © 2020 mohammed ichou. All rights reserved.
//

import Foundation
import SwiftyJSON

public class APIManager{
    
    let APIKEY = "404083003168cfa69731791bce989d78"
    
    static let shared = APIManager()
    
    
    /*
     * method to find id from name city -> [JSON]
     */
    
    func findcity(value : String, onSuccess: @escaping([City]) -> Void ){
    
    var currentrow : [City] = []
        if let path : String = Bundle.main.path(forResource: "city.list.min", ofType: "json") {
        if let data = NSData(contentsOfFile: path) {
            print("ICI")
            do {
                let json = try JSON(data: data as Data)
                let array = json.arrayValue
                if let object : [JSON] = array.filter({ ($0["name"].string?.contains(value))!  && $0["country"].string == "FR" }) {
                        print("found")
                        for obj in object{
                            currentrow.append(City(id: obj["id"].int, name: obj["name"].string , country: obj["country"].string))
                        }
                        onSuccess(currentrow)
                    } else {
                        print("not found")
                        onSuccess(currentrow)
                    }
                } catch  {
                       print(error)
                   }
                   

               }
           }
    }
    
    /*
     * method to get data meteo from id
     */
    
    func getcurrentdata(id:Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
           let baseURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?id=\(id)&appid=\(APIKEY)&units=metric")!
           print(baseURL.absoluteString)
           let request: NSMutableURLRequest = NSMutableURLRequest(url: baseURL)
           request.httpMethod = "GET"
           let session = URLSession.shared
           let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
               if(error != nil){
                   onFailure(error!)
               } else{
                   do {
                       let result = try JSON(data: data!)
                       onSuccess(result)
                   }catch{
                       
                   }
                   
               }
           })
           task.resume()
           print("done")
       }
    
    
    func get5daysdata(id:Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
           let baseURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast?id=\(id)&appid=\(APIKEY)&units=metric")!
           let request: NSMutableURLRequest = NSMutableURLRequest(url: baseURL)
           request.httpMethod = "GET"
           let session = URLSession.shared
           let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
               if(error != nil){
                   onFailure(error!)
               } else{
                   do {
                       let result = try JSON(data: data!)
                       onSuccess(result)
                   }catch{
                       
                   }
                   
               }
           })
           task.resume()
           print("done")
       }
}
