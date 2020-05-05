//
//  MainMenuCtrl.swift
//  Meteo_P6
//
//  Created by mohammed ichou on 11/04/2020.
//  Copyright © 2020 mohammed ichou. All rights reserved.
//

import UIKit
import SwiftyPlistManager
import SwiftyJSON

class MainMenuCtrl: UIViewController {

    @IBOutlet weak var Collection: UICollectionView!
    var keys : [String] = [""]
    var Favoris : [Favori] = []
    private let MyCollectionViewCellId: String = "CustomCellMainMenu"
    var currentid = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Collection.delegate = self
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        Collection.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        let allkey = getAllKey(fromPlistWithName: "Favoris")
        
        for key in allkey{
            //SwiftyPlistManager.shared.
            SwiftyPlistManager.shared.getValue(for: key, fromPlistWithName: "Favoris") { (Result, Error) in
                if(Error == nil){
                    let data = Result as! NSDictionary
                    let Fav = Favori(id: Int(key), city: data["name"] as! String, country: data["Country"] as! String)
                    Favoris.append(Fav)
                }
            }
        }
        
        print(Favoris)
        Collection.reloadData()
        

        
       

        // Do any additional setup after loading the view.
    }
    
    func getAllKey( fromPlistWithName: String) -> [String] {
        print("Function get All Key ::")
        var keys : [String] = [""]
        if let plist = Plist(name: fromPlistWithName) {
            guard let dict = plist.getMutablePlistFile() else {
                print("ici1")
                return [""]
            }
            keys = Array(dict.allKeys) as! [String]
        }
        return keys
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowMeteo"){
            let destination = segue.destination as! MeteoCtrl
            destination.currentid = currentid
        }
    }
    
    
    
        

}

struct Plist {
    let name:String
    
    var sourcePath:String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return .none }
        return path
    }
    
    var destPath:String? {
        guard sourcePath != .none else { return .none }
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return (dir as NSString).appendingPathComponent("\(name).plist")
    }
    
    init?(name:String) {
        self.name = name
        
        let fileManager = FileManager.default
        
        guard let source = sourcePath else {
           print("WARNING: The \(name).plist could not be initialized because it does not exist in the main bundle. Unable to copy file into the Document Directory of the app. Please add a plist file named \(name).plist into the main bundle (your project).")
            return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExists(atPath: source) else {
            print("The \(name).plist already exist.")
            return nil }
        
        if !fileManager.fileExists(atPath: destination) {
            do {
                try fileManager.copyItem(atPath: source, toPath: destination)
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func getMutablePlistFile() -> NSMutableDictionary? {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .none }
            return dict
        } else {
            return .none
        }
    }
}

extension MainMenuCtrl : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Favoris.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! CustomCellMainMenu
        print(cell.bounds.height)
        if(indexPath.row == Favoris.count){
            cell.LabelCountry.text = ""
            cell.Image.image = UIImage(named: "Logo_Api")
        }else{
            
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = .gray
            }else{
                cell.backgroundColor = .white
            }
            cell.LabelCountry.text = "\(Favoris[indexPath.row].city!)"
            
        }
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width , height: collectionView.frame.height/8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(Favoris[indexPath.row].id)
        currentid = Favoris[indexPath.row].id!
        performSegue(withIdentifier: "ShowMeteo", sender: nil)
    }
    
    
    
    
    
    
    
    
    

    
    
}


