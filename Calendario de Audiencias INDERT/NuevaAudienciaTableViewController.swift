//
//  NuevaAudienciaTableViewController.swift
//
//
//  Created by Javier Rivarola on 4/Aug/15.
//
//

import UIKit

class NuevaAudienciaTableViewController: UITableViewController {
    var oldTV: UIView?
    @IBOutlet var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.detailTextLabel?.text != "Sin Datos" {
            
        }
        
        switch row {
        case 0:
            let alert = UIAlertController(title: "Audiencia nueva", message: "Ingrese un nombre para la audiencia", preferredStyle: .Alert)
            
            
            
            alert.addTextFieldWithConfigurationHandler { text in
                if cell?.detailTextLabel?.text != "Sin Datos" {
                    text.text = cell?.detailTextLabel?.text
                }else{
                    text.placeholder = "Nombre..."
                }
            }
            let ok = UIAlertAction(title: "Ok", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = textField.text
                
            }
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = "Sin Datos"
            }
            
            
            alert.addAction(ok)
            alert.addAction(cancelar)
            self.presentViewController(alert, animated: true, completion: nil)
            
        case 1:
            let alert = UIAlertController(title: "Audiencia nueva", message: "Ingrese un numero de cedula para que el sistema agregue el nombre automaticamente. Ingrese 0 para no utilizar numero de cedula", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler { text in
                if cell?.detailTextLabel?.text != "Sin Datos" {
                    text.text = cell?.detailTextLabel?.text
                }else{
                    text.placeholder = "Cedula..."
                }
            }
            let ok = UIAlertAction(title: "Ok", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = textField.text
                if textField.text != "0"{
                    self.searchForName(textField.text)
                }
                
            }
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = "Sin Datos"
            }
            
            
            alert.addAction(ok)
            alert.addAction(cancelar)
            self.presentViewController(alert, animated: true, completion: nil)
        case 2:
            let alert = UIAlertController(title: "Audiencia nueva", message: "Ingrese un motivo para la audiencia", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler { text in
                if cell?.detailTextLabel?.text != "Sin Datos" {
                    text.text = cell?.detailTextLabel?.text
                }else{
                    text.placeholder = "Motivo..."
                }
            }
            let ok = UIAlertAction(title: "Ok", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = textField.text
                
            }
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = "Sin Datos"
            }
            
            
            alert.addAction(ok)
            alert.addAction(cancelar)
            self.presentViewController(alert, animated: true, completion: nil)
            
        case 3:
            let alert = UIAlertController(title: "Audiencia nueva", message: "Ingrese un teléfono para la audiencia", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler { text in
                if cell?.detailTextLabel?.text != "Sin Datos" {
                    text.text = cell?.detailTextLabel?.text
                }else{
                    text.placeholder = "Teléfono..."
                }
            }
            let ok = UIAlertAction(title: "Ok", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = textField.text
                
            }
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = "Sin Datos"
            }
            
            
            alert.addAction(ok)
            alert.addAction(cancelar)
            self.presentViewController(alert, animated: true, completion: nil)
        case 4:
            let alert = UIAlertController(title: "Audiencia nueva", message: "Ingrese un lugar para la audiencia", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler { text in
                if cell?.detailTextLabel?.text != "Sin Datos" {
                    text.text = cell?.detailTextLabel?.text
                }else{
                    text.placeholder = "Lugar..."
                }
            }
            let ok = UIAlertAction(title: "Ok", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = textField.text
                
            }
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .Default){ action in
                let textField = alert.textFields?.first as! UITextField
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = "Sin Datos"
            }
            
            
            alert.addAction(ok)
            alert.addAction(cancelar)
            self.presentViewController(alert, animated: true, completion: nil)
        case 5:
            let alert = UIAlertController(title: "Audiencia nueva", message: "Ingrese un nombre para la audiencia", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler { text in
                if cell?.detailTextLabel?.text != "Sin Datos" {
                    text.text = cell?.detailTextLabel?.text
                }
                self.datePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
                
                let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
                inputView.addSubview(self.datePicker)
                text.placeholder = "fecha..."
                self.datePicker.datePickerMode = UIDatePickerMode.DateAndTime
                self.datePicker.backgroundColor = UIColor(red: 114/255, green: 177/255, blue: 4/255, alpha: 1)
                self.datePicker.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: .ValueChanged)
                let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
                doneButton.setTitle("Listo", forState: .Normal)
                doneButton.setTitle("Listo", forState: .Highlighted)
                doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                doneButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
                inputView.addSubview(doneButton)
                doneButton.addTarget(self, action: Selector("doneFechaPressed"), forControlEvents: .TouchUpInside)
                text.inputView = inputView
                
                
                
            }
            let ok = UIAlertAction(title: "Ok", style: .Default){ action in
                
            }
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .Default){ action in
                
            }
            
            
            alert.addAction(ok)
            alert.addAction(cancelar)
            self.presentViewController(alert, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    var datePicker: UIDatePicker!
    
    func doneFechaPressed(){
        self.view.endEditing(true)
    }
    func datePickerValueChanged(datePicker: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:MM"
        let fechaCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 0))
        fechaCell?.detailTextLabel?.text =  dateFormatter.stringFromDate(datePicker.date)
    }
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    func searchForName(cedula: String){
        let api = API.SharedInstance
        oldTV = navigationItem.titleView
        navigationItem.titleView = spinner
        spinner.startAnimating()
        let parameters = ["codigo":API.Codes.obtenerNombreConCedula.rawValue,"cedula":"\(cedula)"]
        println(parameters)
        api.request(parameters, completion: { (json, error) -> Void in
         
            self.spinner.stopAnimating()
            self.navigationItem.titleView = self.oldTV
            if error == nil {
                if let success = json?["success"].string {
                    println("entre")
                    println(success)
                    if success == "true" {
                        println("entre")
                        if let nombre = json?["nombre"].string {
                            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                            cell?.detailTextLabel?.text = nombre
                        }
                    }else{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let alert = UIAlertController(title: "Error", message: "No existe registros de la cedula ingresada en la base de datos", preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "Aceptar", style: .Default, handler: nil)
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            
                            
                        })
                        
                    }
                }
            }
        })
    }
    
    @IBAction func agregarAudiencia(sender: UIBarButtonItem) {
        
        var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        let titulo = cell?.detailTextLabel!.text
        cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
        let descripcion = cell?.detailTextLabel!.text
        cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0))
        let lugar = cell?.detailTextLabel?.text
        cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))
        let telefono = cell?.detailTextLabel!.text
        cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
        let cedula = cell?.detailTextLabel!.text

        
        
        if datePicker != nil && titulo != "Sin Datos" && cedula != "Sin Datos"  {
        let api = API.SharedInstance
        let blurView = DynamicBlurView(frame: self.view.frame)
        blurView.blurRadius = 0
        self.navigationItem.titleView = spinner
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
        
        
        let parameters = ["codigo":API.Codes.AgregarAudiencia.rawValue,"fecha":"\(fechaFromDate)","nombre":"\(titulo!)","motivo":"\(descripcion!)","lugar":"\(lugar!)","telefono":"\(telefono!)","cedula":"\(cedula!)","estado":"0","hora":"\(hora)"]
        println(parameters)
        api.request(parameters){ json, error in
            
            self.navigationItem.titleView = self.oldTV

            self.spinner.stopAnimating()
            
            UIView.animateWithDuration(0.3, animations: {
                blurView.blurRadius = 0
                }, completion: {fin in
                    blurView.removeFromSuperview()
            })
            
            
            if error == nil {
                
                let center = NSNotificationCenter.defaultCenter()
                
                center.postNotificationName("kShouldReloadAudiencias", object: nil)
                let success = json?["Success"].string ?? "false"
                let message = json?["message"].string ?? "no message"
                if success == "true"{
                let alert = UIAlertController(title: "Datos Actualizados con Exito!", message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            
        }
        
        }else{
            let alert = UIAlertController(title: "Complete los datos necesarios", message: "Complete todos los datos para agregar una audiencia", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }

    
}
