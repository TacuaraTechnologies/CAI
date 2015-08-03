//
//  TTAudiencia.swift
//  Calendario de Audiencias INDERT
//
//  Created by Javier Rivarola on 28/Jul/15.
//  Copyright (c) 2015 Tacuara Technologies. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class TTAudiencia {
    var id: String?
    var titulo: String?
    var fecha: NSDate?
    var fechaJson: String?
    var descripcion: String?
    var ciSolicitante: String?
    var lugar: String?
    var telefono: String?
    var estado: Estados?
    
    enum Estados: String {
        case Concretado = "Concretado"
        case EnProceso = "En Proceso"
        case Denegado = "Denegado"
        case Postergado = "Postergado"
    }
    
    
    var notify: Bool = true  {
        didSet {
            if notify {
                //set notification
                setNotification()
                println("notification Enabled at \(self.fecha)")

            }else{
                //disable this notification
                disableNotification(self.id)
                println("notification disabled")
            }
        }
    }// defaults always alert
    
    
    private func disableNotification(notificationID : String?) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
            if (notification.userInfo!["id_audiencia"] as? String == notificationID) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
    }
    
    
    func setNotification() -> Bool{
        if self.notify {
        if self.fecha != nil {
            var notification =  UILocalNotification()
            setAsEventInCalendar()
            notification.fireDate = self.fecha
            notification.alertBody = self.titulo
            notification.alertTitle = "Tienes una audiencia!"
            notification.alertAction = "Ver Detalles"
            notification.category = "audienciasNotificationsCategoryIdentifier"
            var idInfo = ["id_audiencia":self.id!]
            notification.userInfo = idInfo
            
            for noti in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
                if notification.userInfo!["id_audiencia"] as? String == self.id {
                    println("notification already set")
                    return false
                }
            }
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            return true
        }else{
            return false
        }
        }
        return false
    }
    
    func snooze(time: NSDate) {
        
    }
    
    
   func setAsEventInCalendar(){
    var eventStore: EKEventStore = EKEventStore()
    eventStore.requestAccessToEntityType(EKEntityTypeEvent) { granted, error in
        if granted && error == nil {
            
            var userEvents = TTUserPreferences.SharedInstance.calendarEvents
            if !contains(userEvents, self.titulo!) {
                
        
            userEvents.append(self.titulo!)
            var event = EKEvent(eventStore: eventStore)
            event.title = self.titulo
            event.startDate = self.fecha
            event.endDate = self.fecha
            event.notes = self.descripcion
            event.calendar = eventStore.defaultCalendarForNewEvents
            var alarm:EKAlarm = EKAlarm(relativeOffset: -60*15)
            event.alarms = [alarm]
            
            eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
            
            TTUserPreferences.SharedInstance.save()
                
            }
        }
        }
    }
    
    convenience init(id: String, titulo: String, fecha: NSDate, descripcion:String?, notify: Bool){
        self.init()
        self.id = id
        self.titulo = titulo
        self.fecha = fixNotificationDate(fecha)
        self.descripcion = descripcion
        self.notify = notify
        
    }
    
    private func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        var dateComponents : NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute, fromDate: dateToFix)
        dateComponents.second = 50 + Int(arc4random()%5)
        var fixedDate: NSDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
        return fixedDate
    }
    
}

class TTUserPreferences {
    static let SharedInstance = TTUserPreferences()
    var snoozeTime: CGFloat?
    
    var calendarEvents:[String] = []
    struct Keys {
    static let ArrayOfCalendarEventsSaved = "ArrayOfCalendarEventsSaved"
    }
    init(){
        calendarEvents = NSUserDefaults.standardUserDefaults().valueForKey(Keys.ArrayOfCalendarEventsSaved) as? [String] ?? []
    }
    
    func save() {
        
        NSUserDefaults.standardUserDefaults().setValue(calendarEvents, forKey: Keys.ArrayOfCalendarEventsSaved)
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

