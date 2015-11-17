//
//  MainViewController.swift
//
//
//  Created by Javier Rivarola on 27/Jul/15.
//
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var audienciasProximas: [TTAudiencia] = []
    var audienciasPasadas: [TTAudiencia] = []
    var audiencias:[[TTAudiencia]] = []
    var refreshControl: UIRefreshControl?
    var oldTV: UIView?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let api = API.SharedInstance
    var filteredAudiencias: [[TTAudiencia]] = []
    var searchActive: Bool = false
    struct Constants {
        static let ReuseCellID = "AudienciaReuseCellID"
    }
    struct Segues {
        static let verAudiencia = "verAudiencia"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNotificationObservers()
        
        setupUI()
        spinner.startAnimating()
        listarAudiencias()
    }
    

    
    
    func setupUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: Selector("listarAudiencias"), forControlEvents: .ValueChanged)
        
        tableView.addSubview(refreshControl!)
        
    }
    
  
    
    func listarAudiencias(){
        let parameters = ["codigo":API.Codes.Listar.rawValue]
        api.request(parameters) { (json, error) -> Void in
            self.spinner.stopAnimating()
            self.audiencias = []
            self.audienciasPasadas = []
            self.audienciasProximas = []
            if error == nil {
                
                    if let audiencias = json!["audiencias"].array {
                 

                        for audiencia in audiencias {
                            print(audiencia)
                            let newAudiencia = TTAudiencia()
                          newAudiencia.id = audiencia["id_audiencia"].string
                            newAudiencia.titulo = audiencia["nombre"].string ?? "Sin datos"
                            
                            let fechaFromJson = audiencia["fecha"].string
                            newAudiencia.fechaJson = fechaFromJson
                            print(newAudiencia.fechaJson)
                            let formatter = NSDateFormatter()
                            //formatter.locale = NSLocale(localeIdentifier: "ES_es")
                            formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
                            if let date = formatter.dateFromString(fechaFromJson!) {
                                newAudiencia.fecha = date
                                
                                let currentDate = NSDate()

                                let compare = date.compare(currentDate)
                                switch compare {
                                case .OrderedDescending: // Audiencia proxima
                                    self.audienciasProximas.append(newAudiencia)
                                case .OrderedSame:
                                    self.audienciasProximas.append(newAudiencia)
                                case .OrderedAscending: //audiencia ya paso
                                    self.audienciasPasadas.append(newAudiencia)
                                    
                                    
                                }

                            }
                            newAudiencia.lugar = audiencia["lugar"].string ?? "-1"
                            newAudiencia.ciSolicitante = audiencia["cedula"].string ?? "0000"
                            newAudiencia.telefono = audiencia["telefono"].string ?? "0"
                        

                            
                            
                            
                            
                            newAudiencia.descripcion = audiencia["motivo"].string
                            let estado = audiencia["estado"].string
                            if estado ==
                            "0" {
                                newAudiencia.estado = .EnProceso
                            }
                            if estado == "1" {
                                newAudiencia.estado = .Concretado
                            }
                            if estado == "2" {
                                newAudiencia.estado = .Denegado
                            }
                            newAudiencia.notify = true
                            
                        
                                                   }
                    }else{
                        //failure
                }
                
                
                self.audiencias.append(self.audienciasProximas)
                self.audiencias.append(self.audienciasPasadas)
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                
                self.addCalendarEvents()
                
            }else{
                //connection error
                print(error)
            }
            }
        
    }
    
    
    func addCalendarEvents(){
        var events = TTUserPreferences.SharedInstance.calendarEvents
        for au in audiencias {
            for aud in au {
            if !events.contains((aud.id!)) {
                aud.setAsEventInCalendar()
                events.append(aud.id!)
            }
            }
        }
        TTUserPreferences.SharedInstance.calendarEvents = events
        TTUserPreferences.SharedInstance.save()
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
          
                UIView.animateWithDuration(0.5, animations: {
                    self.bottomConstraint.constant = keyboardSize.height
                    
                })
            
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        bottomConstraint.constant = 0
    }

    
    
    func setNotificationObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleInformarAudiencia"), name: "InformarAudienciaNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleSnoozeAudiencia:"), name: "SnoozeAudienciaNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleDeleteAudiencia:"), name: "DeleteAudienciaNotification", object: nil)
        
        
        
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
         center.addObserver(self, selector: Selector("listarAudiencias"), name: "kShouldReloadAudiencias", object: nil)
        
    }
    
    func handleInformarAudiencia(){
        
    }
    
    func handleSnoozeAudiencia(notification: NSNotification){
        let userInfo = notification.userInfo as! [String:Int]
        
    }
    
    func handleDeleteAudiencia(notification: NSNotification){
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Segues.verAudiencia {
            let dvc = segue.destinationViewController as! VerAudienciaViewController
            let audienciaCell = sender as! AudienciasTableViewCell
            let ip = tableView.indexPathForCell(audienciaCell)!
            var selectedAudiencia: TTAudiencia!
            if searchActive {
                selectedAudiencia = filteredAudiencias[ip.section][ip.row]
            }else{
                selectedAudiencia = audiencias[ip.section][ip.row]
            }
            dvc.audiencia = selectedAudiencia
            
        }
    }
    
    
    // MARK: TableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return audiencias.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseCellID, forIndexPath: indexPath) as! AudienciasTableViewCell
        
        var audienciasForDisplay:[TTAudiencia] = []
        
        if searchActive {
            audienciasForDisplay = filteredAudiencias[indexPath.section]
        }else{
            audienciasForDisplay = audiencias[indexPath.section]
        }
        
        cell.titulo.text = audienciasForDisplay[indexPath.row].titulo
        cell.descripcion.text =  audienciasForDisplay[indexPath.row].descripcion ?? "Sin datos"
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ES_es")
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm"
        
        cell.fecha.text = dateFormatter.stringFromDate(audienciasForDisplay[indexPath.row].fecha!)
        cell.notifySwitch.on = audienciasForDisplay[indexPath.row].notify
        cell.notifySwitch.addTarget(self, action: Selector("notifySwitchChanged:"), forControlEvents: .ValueChanged)
        cell.estado.text = audienciasForDisplay[indexPath.row].estado?.rawValue
        cell.notifySwitch.on = true
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
         return filteredAudiencias[section].count
        }
        
        return audiencias[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 216
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Próximas Audiencias"
        }else{
            return "Audiencias Pasadas"
        }
    }
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar", handler: {action, ip in
            self.tableView.editing = false
            self.borrarAudiencia(ip)
            
        })
        let posponeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Posponer", handler: {action, ip in
            
        })

        let actions = [editAction] // add postpone action later on
        return actions
    }
    
    func borrarAudiencia(indexPath: NSIndexPath){
        
        let blurView = DynamicBlurView(frame: self.view.frame)
        blurView.blurRadius = 0
        oldTV = self.navigationItem.titleView
        self.navigationItem.titleView = spinner
        self.view.insertSubview(blurView, belowSubview: spinner)
        UIView.animateWithDuration(0.3, animations: {
            blurView.blurRadius = 8
            }, completion: {fin in
                self.spinner.startAnimating()
        })

        
        
        var audiencia: TTAudiencia!
        if !searchActive {
         audiencia = audiencias[indexPath.section][indexPath.row]
        }else{
             audiencia = filteredAudiencias[indexPath.section][indexPath.row]
        }
        let parameters = ["codigo":API.Codes.BorrarAudiencia.rawValue,"id_audiencia":"\(audiencia.id!)"]
        
        api.request(parameters){json, error in
            
            UIView.animateWithDuration(0.3, animations: {
                blurView.blurRadius = 0
                }, completion: {fin in
                    blurView.removeFromSuperview()
                    self.spinner.stopAnimating()
                    self.navigationItem.titleView = self.oldTV

            })
            
            self.listarAudiencias()

            if error == nil {
                let success = json!["Success"].string
                let message = json!["message"].string
                if success == "true" {
                    let alert = UIAlertController(title: "Datos Actualizados con Exito!", message: "Se borro la audiencia con exito", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
               
                    
                }else{
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }else{
            let alert = UIAlertController(title: "Ha ocurrido un error ", message: error, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }

        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: AudienciasTableViewCell!
        
        if searchActive {
            
        }
         cell = tableView.cellForRowAtIndexPath(indexPath) as! AudienciasTableViewCell
        performSegueWithIdentifier(Segues.verAudiencia, sender: cell)
    }
    
    
    
    @IBAction func agregarAudiencia(sender: UIBarButtonItem) {
        
    }
    
    //    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    //
    //    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //search for audiencia
        
        filteredAudiencias[0] = audienciasProximas.filter({ (data) -> Bool in
        
            let tmp: NSString = data.titulo!
            let range = tmp.rangeOfString(searchText, options: [NSStringCompareOptions.CaseInsensitiveSearch, NSStringCompareOptions.DiacriticInsensitiveSearch])
            return range.location != NSNotFound
            
        })
        filteredAudiencias[1] = audienciasPasadas.filter({ (data) -> Bool in
            
            let tmp: NSString = data.titulo!
            let range = tmp.rangeOfString(searchText, options: [NSStringCompareOptions.CaseInsensitiveSearch, NSStringCompareOptions.DiacriticInsensitiveSearch])
            return range.location != NSNotFound
            
        })
        tableView.reloadData()
        

    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismissSearchBar()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        activateSearchBar()
        return true
    }
    
    func dismissSearchBar(){
        searchBar.text = ""
        searchActive = false
        tableView.reloadData()
    }
    
    func activateSearchBar(){
        filteredAudiencias = audiencias
        searchActive = true
    }
    
    func notifySwitchChanged(sender: UISwitch){
        let switchPos = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(switchPos)
        if indexPath != nil {
            if indexPath?.section == 0 {
                let audiencia = audienciasProximas[indexPath!.row]
                audiencia.notify = sender.on
            }
        }
    }
    
    
    // MARK: BarButtons
    
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        
        //handle logout
        api.logout()
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    
    
    
    
    
}
