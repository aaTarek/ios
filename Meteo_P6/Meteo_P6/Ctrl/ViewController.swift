//
//  ViewController.swift
//  Meteo_P6
//
//  Created by mohammed ichou on 04/04/2020.
//  Copyright © 2020 mohammed ichou. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import SwiftyPlistManager

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    

    @IBOutlet weak var SeachBar: UISearchBar!
    @IBOutlet weak var TableCity: UITableView!
    
    var CurrentCity : [City] = []
    var currentid : Int?
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SeachBar.placeholder = "Entrez votre ville"
        SeachBar.delegate = self
        TableCity.delegate = self
        TableCity.dataSource = self
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        

        
        /*
         Test Create Table de Prevision
         */
        
       
        
        //activityIndicator.startAnimating()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("ICI")
        view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        self.CurrentCity.removeAll()
        self.TableCity.reloadData()
        APIManager.shared.findcity(value: searchBar.text!) { (citys) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                print(citys)
                self.CurrentCity = citys
                self.TableCity.reloadData()
            }
            
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(CurrentCity[indexPath.row].name!), \(CurrentCity[indexPath.row].country!)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(CurrentCity[indexPath.row].id)
        currentid = CurrentCity[indexPath.row].id
        SwiftyPlistManager.shared.addNew(["name" : CurrentCity[indexPath.row].name, "Country": CurrentCity[indexPath.row].country] , key: String(CurrentCity[indexPath.row].id!), toPlistWithName: "Favoris") { (Error) in
            if(Error == nil){
                print("Ajout Favoris Reussis ::")
            }
        }
        performSegue(withIdentifier: "Segue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Segue"){
            if let second = segue.destination as? MeteoCtrl{
                second.currentid = currentid
            }
        }
        
    }
    

    
    


}

