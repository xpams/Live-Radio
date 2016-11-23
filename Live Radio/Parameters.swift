//
//  Parameters.swift
//  Live Radio
//
//  Created by Nikolay Khramchenko on 11/23/16.
//  Copyright © 2016 nxpams. All rights reserved.
//


class Parameters {
    static let sharedInstance = Parameters();
    
    init() {
        self.RADIO_NAME = "";
        self.RADIO_URL = "";
    }
    
    var RADIO_URL : String;
    var RADIO_NAME : String;
    
    
    
    
    
}
