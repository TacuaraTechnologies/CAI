//
//  VerAudienciaViewController.swift
//  
//
//  Created by Javier Rivarola on 28/Jul/15.
//
//

import UIKit

class VerAudienciaViewController: UIViewController {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var estado: UIButton!
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var telefono: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var notifySwitch: UISwitch!
    
    var audiencia: TTAudiencia?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let audiencia = audiencia {
        titulo.text = audiencia.titulo
        descripcion.text = audiencia.descripcion ?? "Sin Datos"
        estado.setTitle(audiencia.estado?.rawValue, forState: .Normal)
        estado.setTitle(audiencia.estado?.rawValue, forState: .Highlighted)
             notifySwitch.setOn(audiencia.notify, animated: false)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:MM"
            
            fecha.text = dateFormatter.stringFromDate(audiencia.fecha!)
            telefono.text = audiencia.telefono
        }
        
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

    @IBAction func cambiarEstado(sender: UIButton) {
        
        let alert = UIAlertController(title: "Cambiar Estado de Audiencia", message: "Por favor ingrese el nuevo estado para la audiencia.", preferredStyle: .Alert)
        let enProceso = UIAlertAction(title: TTAudiencia.Estados.EnProceso.rawValue, style: .Default){ action in
            self.updateAudiencia(0)
    
        }
        
        let Postergado = UIAlertAction(title: TTAudiencia.Estados.Postergado.rawValue, style: .Default){ action in
            //self.audiencia?.estado = .Postergado
           // self.updateAudiencia(1)

            
        }
        let Concretado = UIAlertAction(title: TTAudiencia.Estados.Concretado.rawValue, style: .Default){ action in
            self.updateAudiencia(1)

        }
        
        let Denegado = UIAlertAction(title: TTAudiencia.Estados.Denegado.rawValue, style: .Default){ action in
            self.updateAudiencia(2)

        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .Default, handler: nil)
        
        alert.addAction(enProceso)
        alert.addAction(Postergado)
        alert.addAction(Concretado)
        alert.addAction(Denegado)
        alert.addAction(cancelar)
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    func updateAudiencia(estado:Int){
        let api = API.SharedInstance
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ES_es")
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.stringFromDate(audiencia!.fecha!)
        formatter.dateFormat = "HH:MM"
        
        let hora = formatter.stringFromDate(audiencia!.fecha!)
         let parameters = ["codigo":API.Codes.ActualizarAudiencia.rawValue,"fecha":"\(date)","hora":"\(hora)","nombre":"\(audiencia!.titulo!)","motivo":"\(audiencia!.descripcion!)","lugar":"\(audiencia!.lugar!)","telefono":"\(audiencia!.telefono!)","cedula":"\(audiencia!.ciSolicitante!)","estado":"\(estado)","id_audiencia": "\(audiencia!.id!)"]
        print(parameters, terminator: "")

        let blurView = DynamicBlurView(frame: self.view.frame)
        blurView.blurRadius = 0
        blurView.userInteractionEnabled = false
        self.view.insertSubview(blurView, belowSubview: spinner)
        
        UIView.animateWithDuration(0.3, animations: {
        blurView.blurRadius = 8
            }, completion: {fin in
                self.spinner.startAnimating()
        })
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
                
                let success = json!["Success"].string
                let message = json!["message"].string
                if success == "true"{
                    if estado == 0 {
                       self.audiencia?.estado = TTAudiencia.Estados.EnProceso
                    }
                    if estado == 1{
                        self.audiencia?.estado = TTAudiencia.Estados.Concretado
                    }
                    if estado == 2 {
                        self.audiencia?.estado =  TTAudiencia.Estados.Denegado
                    }
                    self.estado.setTitle(self.audiencia?.estado?.rawValue, forState: .Normal)
                    self.estado.setTitle(self.audiencia?.estado?.rawValue, forState: .Highlighted)
                let alert = UIAlertController(title: "Datos Actualizados con Exito!", message:message, preferredStyle: .Alert)
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
    }
    
    
}
