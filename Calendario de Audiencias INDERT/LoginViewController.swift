//
//  LoginViewController.swift
//  
//
//  Created by Javier Rivarola on 27/Jul/15.
//
//

import UIKit
import SwiftyJSON
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
let user = TTUser.SharedInstance
    @IBOutlet weak var txtFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var ingresarBtn: UIButton!
    @IBOutlet weak var recuperarPassBtn: UIButton!
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var logoIV: UIImageView!
    var blurView: DynamicBlurView?
    @IBOutlet weak var bottomConstraintForKB: NSLayoutConstraint!
    var keyboardHeight: CGFloat!
    let api = API.SharedInstance
    
    struct Segues {
        static let gotoMainView = "gotoMainView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    

 
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Segues.gotoMainView {
            
        }
    }

    
    func setupUI(){
        ingresarBtn.layer.cornerRadius = 5
        recuperarPassBtn.layer.cornerRadius = 5
        
        ingresarBtn.clipsToBounds = true
        recuperarPassBtn.clipsToBounds = true
        
        animateWelcomeScreen()
        
    }
    
    func animateWelcomeScreen(){
        logoIV.transform = CGAffineTransformMakeTranslation(0,-self.view.bounds.height/2)
        usuario.transform = CGAffineTransformMakeTranslation(0,self.view.bounds.height/2)
        logoIV.alpha = 0
        usuario.alpha = 0
        password.transform = CGAffineTransformMakeTranslation(0,self.view.bounds.height/2)
        ingresarBtn.transform = CGAffineTransformMakeTranslation(0,self.view.bounds.height/2)
        password.alpha = 0
        ingresarBtn.alpha = 0
     
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .CurveEaseIn, animations: {
            self.logoIV.transform = CGAffineTransformIdentity
            self.usuario.transform = CGAffineTransformIdentity
            self.logoIV.alpha = 1
            self.usuario.alpha = 1
            }, completion: {fin in
              

        })
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6,options: .CurveLinear , animations: {
            self.password.transform = CGAffineTransformIdentity
            self.password.alpha = 1

            }, completion:nil)
        
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .CurveLinear , animations: {
            self.ingresarBtn.transform = CGAffineTransformIdentity
            self.ingresarBtn.alpha = 1
            }, completion: nil)
    }
    
    func setupObservers(){
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
         center.addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            // ...
            keyboardHeight = keyboardSize.height
            
            if keyboardHeight > (self.view.bounds.height/2 - 50) {
            UIView.animateWithDuration(0.1, animations: {
                    self.txtFieldHeightConstraint.constant = 0

            })
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        txtFieldHeightConstraint.constant = -50

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if !loginRequestEnded {
            api.stackRequest.first?.cancel()
            UIView.animateWithDuration(0.3, animations: {
                blurView?.blurRadius = 0
                
                }, completion: {fin in
                    self.blurView?.removeFromSuperview()
                    self.blurView = nil
                    self.spinner.stopAnimating()
            })
        }
        
        self.view.endEditing(true)
    }
    
    
    var loginRequestEnded: Bool = true
  
    @IBAction func loginPressed(sender: UIButton) {
        loginRequestEnded = false
    
        usuario.resignFirstResponder()
        password.resignFirstResponder()
        blurView = DynamicBlurView(frame: self.view.frame)
        blurView?.blurRadius = 0
        self.view.insertSubview(blurView!, belowSubview: spinner)
        UIView.animateWithDuration(0.3, animations: {
            blurView?.blurRadius = 8
            
            }, completion: {fin in
                self.spinner.startAnimating()
        })
        

        
       let parameters = ["usuario":usuario.text,"clave":password.text,"codigo":API.Codes.Login.rawValue]
       //let parameters = ["usuario":"tra","clave":"sn00.pY"]

        api.login(parameters) { json, error in
            self.loginRequestEnded = true
            UIView.animateWithDuration(0.3, animations: {
                blurView?.blurRadius = 0

                }, completion: {fin in
                    self.blurView?.removeFromSuperview()
                    self.blurView = nil
                    self.spinner.stopAnimating()
            })
            if error == nil {
                if let json = json {
                    if json["loggedIn"].boolValue {
                        
                        self.usuario.text = ""
                        self.password.text = ""
                        self.user.logged = true
                    
                        
                        self.performSegueWithIdentifier(Segues.gotoMainView, sender: self)
                    }else{
                        let message = json["message"].string ?? "No hay mensaje de error"
                        self.password.text = ""

                        let alert = UIAlertController(title: "Error al iniciar sesión", message:message, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }

        
        
    }
    

}
