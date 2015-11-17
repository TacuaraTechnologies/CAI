//
//  NuevaAudienciaViewController.swift
//  
//
//  Created by Javier Rivarola on 28/Jul/15.
//
//

import UIKit

class NuevaAudienciaViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var fecha: UITextField!
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var lugar: UITextField!
    
    @IBOutlet weak var agregarBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var txtFieldHeightConstraint: NSLayoutConstraint!
    
    func setupObservers(){
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            // ...
           let keyboardHeight = keyboardSize.height
            if lugar.isFirstResponder(){
                UIView.animateWithDuration(0.5, animations: {
                    self.txtFieldHeightConstraint.constant = keyboardHeight*(-1)/2
                    
                })
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        UIView.animateWithDuration(0.5, animations: {
            self.txtFieldHeightConstraint.constant = 0
            
        })
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    }
    var datePicker: UIDatePicker!
    func setupUI(){
        datePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        datePicker.backgroundColor = UIColor(red: 114/255, green: 177/255, blue: 4/255, alpha: 1)
        datePicker.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: .ValueChanged)
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        inputView.addSubview(datePicker)
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Listo", forState: .Normal)
        doneButton.setTitle("Listo", forState: .Highlighted)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: Selector("doneFechaPressed"), forControlEvents: .TouchUpInside)
        fecha.inputView = inputView
        
        agregarBtn.layer.cornerRadius = 5
        agregarBtn.clipsToBounds = true
        
    }
    func doneFechaPressed(){
        self.view.endEditing(true)
    }
    func datePickerValueChanged(datePicker: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:MM"
        fecha.text =  dateFormatter.stringFromDate(datePicker.date)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: TextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBAction func agregarAudienciaPressed(sender: UIButton) {
        
        //handle new audiencia

        
        let api = API.SharedInstance
    let blurView = DynamicBlurView(frame: self.view.frame)
        blurView.blurRadius = 0
        
        self.view.insertSubview(blurView, belowSubview: spinner)
        UIView.animateWithDuration(0.3, animations: {
            blurView.blurRadius = 8
            }, completion: {fin in
                self.spinner.startAnimating()
        })
        //let parameters = ["request":API.Codes.AgregarAudiencia.rawValue,"fecha":fecha.text,"nombre":titulo.text,"motivo":descripcion.text,"lugar":lugar.text,"telefono":"234","cedula":"0","estado":"0"]
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
    
        let fechaFromDate = dateFormatter.stringFromDate(datePicker.date)
        dateFormatter.dateFormat = "HH:MM"

        let hora = dateFormatter.stringFromDate(datePicker.date)
          let parameters = ["codigo":API.Codes.AgregarAudiencia.rawValue,"fecha":"\(fechaFromDate)","nombre":"\(titulo.text)","motivo":"\(descripcion.text)","lugar":"\(lugar.text)","telefono":"0","cedula":"0","estado":"0","hora":"\(hora)"]
        print(parameters)
        api.request(parameters){ json, error in
            
            
            self.spinner.stopAnimating()
            
            UIView.animateWithDuration(0.3, animations: {
                blurView.blurRadius = 0
                }, completion: {fin in
                    blurView.removeFromSuperview()
            })
            
            
            if error == nil {
                
                let center = NSNotificationCenter.defaultCenter()
                
                center.postNotificationName("kShouldReloadAudiencias", object: nil)
                
                let alert = UIAlertController(title: "Datos Actualizados con Exito!", message: "Se agrego la audiencia con exito", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            
        }

        
        
        
    }
}
