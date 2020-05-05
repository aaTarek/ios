//
//  MeteoCtrl.swift
//  Meteo_P6
//
//  Created by mohammed ichou on 06/04/2020.
//  Copyright © 2020 mohammed ichou. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import SwiftyJSON

class MeteoCtrl: UIViewController {
    
    var currentid : Int?
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var Collection: UICollectionView!
    @IBOutlet weak var ViewInfo: UIView!
    @IBOutlet weak var ViewDraw: UIView!
    
    
    
    private let MyCollectionViewCellId: String = "Customcellprevision"
    
    let gradientLayer = CAGradientLayer()
    let gradientLayer2 = CAGradientLayer()
    
    var activityIndicator: NVActivityIndicatorView!
    
    var Tabprev : [Prevision] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        ViewInfo.layer.borderWidth = 1
        ViewInfo.layer.borderColor = UIColor.black.cgColor
        ViewInfo.layer.cornerRadius = 10
        ViewInfo.layer.masksToBounds = false
        
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        Collection.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        
        APIManager.shared.getcurrentdata(id: currentid!, onSuccess: { (data) in
            DispatchQueue.main.async {
                
                self.UpdateUI(data: data)
            }
            //
        }) { (Error) in
            print(Error)
        }
        
        APIManager.shared.get5daysdata(id: currentid!, onSuccess: { (JSON) in
        //print(JSON)
        
        for indice in JSON["list"].arrayValue{
            let tab = indice["dt_txt"].stringValue.split(separator: " ")
            let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let myCalendar = Calendar(identifier: .gregorian)
            let str = String((tab.first)!)
            let weekDay = myCalendar.component(.weekday, from: formatter.date(from: str)!)
            let heure = tab.last?.split(separator: ":").first!
            let iconeName = indice["weather"].array![0]["icon"].stringValue
            
            let prev1 = Prevision(jour: self.getDayOfWeekString(weekDay: weekDay), heure: String(heure!), iconeName: iconeName)
            self.Tabprev.append(prev1)
        }
            DispatchQueue.main.async {
               self.Collection.reloadData()
               self.activityIndicator.stopAnimating()
            }
            
        
        }) { (Error) in
            print(Error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    
    func setGreyGradientBackground(){
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    
    func UpdateUI(data : JSON){
            let jsonResponse = JSON(data)
            let jsonWeather = jsonResponse      
            let jsonTemp = jsonResponse["main"]
            let iconName = jsonWeather["icon"].stringValue
            let debut = jsonResponse["sys"]["sunrise"].intValue
            let fin = jsonResponse["sys"]["sunset"].intValue
        
            
            self.locationLabel.text = jsonResponse["name"].stringValue
            self.conditionImageView.image = UIImage(named: iconName)
            self.conditionLabel.text = jsonWeather["main"].stringValue
            self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            self.dayLabel.text = dateFormatter.string(from: date)
            
            let suffix = iconName.suffix(1)
            if(suffix == "n"){
                self.setGreyGradientBackground()
                ViewInfo.backgroundColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
            }else{
                self.setBlueGradientBackground()
                ViewInfo.backgroundColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0)
            }
            drawCircle(sunrise: debut, sunset: fin)
    }
    
    func getDayOfWeekString(weekDay : Int)->String? {
            switch weekDay {
            case 1:
                return "Dim"
            case 2:
                return "Lun"
            case 3:
                return "Mar"
            case 4:
                return "Mer"
            case 5:
                return "Jeu"
            case 6:
                return "Ven"
            case 7:
                return "Sam"
            default:
                print("Error fetching days")
                return "Day"
            }
    }
    
    
    @IBAction func Backpress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // id : ShowMultiMeteo
    
    
    func drawCircle(sunrise : Int, sunset: Int){
        
        
        var angle : Double = 0
        var semiCircleLayer = CAShapeLayer()
        let center = CGPoint (x: ViewDraw.frame.size.width / 2, y: ViewDraw.frame.height-70)
        let circleRadius = ViewDraw.frame.size.width / 3
        let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 2), clockwise: true)


        semiCircleLayer.path = circlePath.cgPath
        semiCircleLayer.strokeColor = UIColor.yellow.cgColor
        semiCircleLayer.lineWidth = 5
        semiCircleLayer.fillColor = UIColor.clear.cgColor
        semiCircleLayer.strokeStart = 0
        semiCircleLayer.strokeEnd  = 1
        
        ViewDraw.layer.addSublayer(semiCircleLayer)
        
        
        let x0 = ViewDraw.frame.size.width / 2
        let y0 = ViewDraw.frame.height-70
        
        var date = Int(Date().timeIntervalSince1970)
        
        //date = 1586697889
        
        print(sunset)
        print(sunrise)
        if(date > sunrise && date < sunset){
            print("soleil leve")
            let total = sunset - sunrise
            print("total :: \(total)")
            print("date :: \(date-sunrise)")
            angle = (Double(date-sunrise) * 180.0 / Double(total))
        }else{
            print("nuit")
            angle = 0
        }
        
        print("Angle :: \(angle)")
        
        
        
        
        let x = x0 + (circleRadius * CGFloat(cos((180 - angle) * M_PI / 180)))
        let y = y0 + (circleRadius * CGFloat(sin((180 - angle) * M_PI / 180)))
        
        print(x)
        print(y)
        
        let timedebut = Date(timeIntervalSince1970: TimeInterval(sunrise))
        let timefin = Date(timeIntervalSince1970: TimeInterval(sunset))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strdebut = dateFormatter.string(from: timedebut)
        let strfin = dateFormatter.string(from: timefin)
        
        
        
        
        
        
        let imageView : UIImageView
        //imageView  = UIImageView(frame:CGRect(x: x-circleRadius-20, y: y, width: 35, height: 35));
        imageView  = UIImageView(frame:CGRect(x: x-15, y: ViewDraw.frame.height - y + 150 + 5, width: 35, height: 35));
        //imageView = UIImageView(frame:CGRect(x: x0 - circleRadius - 20, y: y0 - 10, width: 35, height: 35))
        imageView.image = UIImage(named:"01d")
        
        
        let debut = UILabel(frame: CGRect(x: x0 - circleRadius - 50, y: y0 + 10, width: 100, height: 20))
        debut.textAlignment = NSTextAlignment.center
        debut.text = strdebut
        debut.textColor = .white
        
        var fin = UILabel(frame: CGRect(x: x0 + circleRadius - 50, y: y0 + 10, width: 100, height: 20))
        fin.textAlignment = NSTextAlignment.center
        fin.text = strfin
        fin.textColor = .white
        
        self.ViewDraw.addSubview(imageView)
        self.ViewDraw.addSubview(debut)
        self.ViewDraw.addSubview(fin)
        
    }

}

extension MeteoCtrl :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Tabprev.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! Customcellprevision
        cell.LabelHeure.text = "\(Tabprev[indexPath.row].heure) H"
        cell.LabelJour.text = "\(Tabprev[indexPath.row].jour)"
        cell.ImageIcone.image = UIImage(named: "\(Tabprev[indexPath.row].iconeName)")
           return cell
       }
       
       func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
           //let collectionViewWidth = collectionView.bounds.width

           return CGSize.init(width: 100, height: 120)
       }
}
