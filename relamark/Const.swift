//
//  Const.swift
//  relamark
//
//  Created by mac on 2015/06/20.
//  Copyright (c) 2015年 AtsushiKawasaki. All rights reserved.
//

import Foundation

class Const : NSObject {
    #if DEBUG
    let URL_API = "http://localhost:3000/"
    
    #elseif STAGING
    let URL_API = "fuga"
    
    #else
    
    let URL_API = "http://relamark.link"
    #endif
}