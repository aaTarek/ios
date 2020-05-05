//
//  Prevision.swift
//  Meteo_P6
//
//  Created by mohammed ichou on 11/04/2020.
//  Copyright © 2020 mohammed ichou. All rights reserved.
//

import Foundation

public class Prevision{
    
    var jour : String
    var heure : String
    var iconeName : String
    
    
    init( jour : String?, heure : String?, iconeName: String?){
        self.jour = jour!
        self.heure = heure!
        self.iconeName = iconeName!
    }
    
    func show(){
        print("Jour :: \(jour)\nHeure :: \(heure)\nIconeName :: \(iconeName)")
    }
    
        
}
