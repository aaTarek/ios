//
//  City.swift
//  Meteo_P6
//
//  Created by mohammed ichou on 06/04/2020.
//  Copyright © 2020 mohammed ichou. All rights reserved.
//

import Foundation

public class City{
    var id : Int?
    var name : String?
    var country : String?
    
    init( id : Int?, name : String?, country: String?){
        self.id = id
        self.name = name
        self.country = country
    }
    
}
