//
//  Favoris.swift
//  Meteo_P6
//
//  Created by mohammed ichou on 11/04/2020.
//  Copyright © 2020 mohammed ichou. All rights reserved.
//

import Foundation

class Favori{
    
    var id : Int?
    var city : String?
    var country : String?
    
    init(id : Int?, city : String?, country: String?) {
        self.id = id
        self.city = city
        self.country = country
    }
}
