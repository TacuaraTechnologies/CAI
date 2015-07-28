//
//  RecuperarPassViewController.swift
//  
//
//  Created by Javier Rivarola on 27/Jul/15.
//
//

import UIKit

class RecuperarPassViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var recuperarBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        recuperarBtn.layer.cornerRadius = 5
        recuperarBtn.clipsToBounds = true
        setupObservers()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func recuperarPressed(sender: UIButton) {
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func setupObservers(){
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    var keyboardHeight: CGFloat!
    
    func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            // ...
            keyboardHeight = keyboardSize.height
            
            if keyboardHeight > (self.view.bounds.height/2 - 50) {
                UIView.animateWithDuration(0.5, animations: {
                    self.heightConstraint.constant = 0
                    
                })
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        heightConstraint.constant = -50
        
    }

}
