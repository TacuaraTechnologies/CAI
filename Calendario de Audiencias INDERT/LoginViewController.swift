//
//  LoginViewController.swift
//  
//
//  Created by Javier Rivarola on 27/Jul/15.
//
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ingresarBtn: UIButton!
    @IBOutlet weak var recuperarPassBtn: UIButton!
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var bottomConstraintForKB: NSLayoutConstraint!
    var keyboardHeight: CGFloat!
    
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
            
            if keyboardHeight > (self.view.bounds.height/2 - 89.5) {
            UIView.animateWithDuration(0.5, animations: {
                    self.txtFieldHeightConstraint.constant = 0

            })
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        txtFieldHeightConstraint.constant = -89.5

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
  
    @IBAction func loginPressed(sender: UIButton) {
        performSegueWithIdentifier(Segues.gotoMainView, sender: self)
        
    }
    

}
