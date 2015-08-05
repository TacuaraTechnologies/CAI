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
                //set event
                
                
            }else{
                //disable this notification
                disableNotification(self.id)
            }
        }
    }// defaults always alert
    
    
    private func disableNotification(notificationID : String?) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
            if (notification.userInfo!["id_audiencia"] as? String == notificationID) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                println("notification disabled for \(self.titulo!)")
                break
            }
        }
    }
    
    
    func setNotification() -> Bool{
        if self.notify {
            if self.fecha != nil {
                var notification =  UILocalNotification()
                notification.fireDate = self.fecha
                notification.alertBody = self.titulo
                notification.alertTitle = "Tienes una audiencia!"
                notification.alertAction = "Ver Detalles"
                notification.category = "audienciasNotificationsCategoryIdentifier"
                var idInfo = ["id_audiencia":self.id!]
                notification.userInfo = idInfo
                
                for noti in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
                    if notification.userInfo!["id_audiencia"] as? String == self.id {
                        println("notification already set for \(self.titulo!)")
                        return false
                    }
                }
                println("notification Enabled for \(self.titulo!)")

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
                
               
                    
                    var event = EKEvent(eventStore: eventStore)
                    event.title = self.titulo
                    
                    event.startDate = self.fecha
                    event.endDate = self.fecha?.dateByAddingTimeInterval(30.0*15)
                    event.notes = self.descripcion
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    var alarm:EKAlarm = EKAlarm(relativeOffset: -60*15)
                    event.alarms = [alarm]
                    
                    eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                    
                    
                
            }
        }
    }
    
    var userEvents:[String] = []
    
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
    
    func fetchEvents(completed: (NSMutableArray) -> ()) {
        var eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccessToEntityType(EKEntityType()) { [weak self]
            granted, error in
            if let strongSelf = self {
                let endDate = NSDate(timeIntervalSinceNow: 604800*10);   //This is 10 weeks in seconds
                let predicate = eventStore.predicateForEventsWithStartDate(NSDate(), endDate: NSDate(), calendars: nil)
                let events = NSMutableArray(array: eventStore.eventsMatchingPredicate(predicate))
                completed(events)
            }
        }
    }
    
}


