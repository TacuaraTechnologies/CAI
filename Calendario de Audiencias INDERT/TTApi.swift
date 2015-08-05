//
//  TTApi.swift
//  Calendario de Audiencias INDERT
//
//  Created by Javier Rivarola on 28/Jul/15.
//  Copyright (c) 2015 Tacuara Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


class  API {
    let apiURL = "http://indert.gov.py/segdoc/index.php?o=secciones&seccion=audiencias&accionRPC=app"
    let loginURL =  "http://indert.gov.py/segdoc/index.php?o=secciones&seccion=audiencias&accionRPC=login"
    //Sesion Manager
    var mgr: Manager!
    enum Codes: String {
        case Login = "LOGIN"
        case Listar = "LISTAR"
        case AgregarAudiencia = "AGREGAR"
        case BorrarAudiencia = "BORRAR"
        case ActualizarAudiencia = "EDITAR"
        case obtenerNombreConCedula = "CEDULA"
    }
    static let apiKey = "12345"
    var stackRequest:[Request] = []
    
    static let SharedInstance = API()
    //Cookies
    var cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    init(){
        mgr = configureManager()
    }
    
    
    func request( parameters: [String : AnyObject]?, completion:(json: JSON?,error: String?) -> Void) {
    
       let request = self.mgr.request(.POST, "http://indert.gov.py/segdoc/index.php?o=secciones&seccion=audiencias&accionRPC=app", parameters: parameters, encoding: .JSON).responseSwiftyJSONRenamed { request,response,json,error in

        
        
            if (response?.statusCode >= 200 && response?.statusCode < 300)
            {
                //Response OK!
                //We pass the completion handler
                completion(json: json, error: nil)
                
            }else if response?.statusCode == 401 { //Unauthorized
                println("error 401")
                    /* OPTION 2, WE MAKE THE USER LOGIN AGAIN */
                    completion(json: json, error: "cookieExpired")
                
            }else if response?.statusCode == 400 {
                
                completion(json: json, error: error?.localizedDescription)
                
            }else{
                //handle error
                let errorString = error?.localizedDescription ?? "no error description."
                let statusCode = response?.statusCode ?? -1
                completion(json: nil , error: "Response Status Code: \(statusCode) with error: \(errorString)")
                
            }
        }
        
        stackRequest.append(request)
        
        
      
    }
    
    func login( parameters: [String : AnyObject]?, completion:(json: JSON?,error: String?) -> Void) {
        
        let request = self.mgr.request(.POST, "http://indert.gov.py/segdoc/index.php?o=secciones&seccion=audiencias&accionRPC=login", parameters: parameters, encoding: .JSON).responseSwiftyJSONRenamed { request,response,json,error in
            
            
            if (response?.statusCode >= 200 && response?.statusCode < 300)
            {
                //Response OK!
                //We pass the completion handler
                completion(json: json, error: nil)
                
            }else if response?.statusCode == 401 { //Unauthorized
                println("error 401")
                /* OPTION 2, WE MAKE THE USER LOGIN AGAIN */
                completion(json: json, error: "cookieExpired")
                
            }else if response?.statusCode == 400 {
                
                completion(json: json, error: error?.localizedDescription)
                
            }else{
                //handle error
                let errorString = error?.localizedDescription ?? "no error description."
                let statusCode = response?.statusCode ?? -1
                completion(json: nil , error: "Response Status Code: \(statusCode) with error: \(errorString)")
                
            }
        }
        
        stackRequest.append(request)
        
        
        
    }
    
    func checkCookies() {
        mgr.request(NSURLRequest(URL: NSURL(string: "http://indert.gov.py/segdoc/index.php?o=secciones&seccion=audiencias&accionRPC=login")!)).responseString {
            (_, _, response, _) in
            var resp = response // { "cookies": { "stack": "overflow" } }
            println(resp)
        }
    }

    
    
    
    
    
    private func configureManager() -> Manager {
        let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
        cfg.HTTPCookieStorage = cookies
        return Manager(configuration: cfg)
    }
    
    // Logout
    
    func logout(){
        for cookie in cookies.cookies as! [NSHTTPCookie] {
            cookies.deleteCookie(cookie)
        }
    }

    
}