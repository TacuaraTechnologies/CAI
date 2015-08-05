//
//  TTUser.swift
//  Calendario de Audiencias INDERT
//
//  Created by Javier Rivarola on 4/Aug/15.
//  Copyright (c) 2015 Tacuara Technologies. All rights reserved.
//

import Foundation
import UIKit

class TTUserPreferences {
    static let SharedInstance = TTUserPreferences()
    var snoozeTime: CGFloat?
    
    var calendarEvents:[NSString] = []
    struct Keys {
        static let ArrayOfCalendarEventsSaved = "ArrayOfCalendarEventsSaved"
    }
    init(){
        
        if let events = NSUserDefaults.standardUserDefaults().objectForKey(Keys.ArrayOfCalendarEventsSaved) {
            calendarEvents = events as! [NSString]
        }

    }
    
    func save() {
        
        NSUserDefaults.standardUserDefaults().setObject(calendarEvents, forKey: Keys.ArrayOfCalendarEventsSaved)
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
}

class TTUser {
    static let SharedInstance = TTUser()
    var audiencias:[TTAudiencia]?
    var logged : Bool?
    var nombre: String?
    var id: Int?
    
}
