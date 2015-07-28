//
//  MainViewController.swift
//  
//
//  Created by Javier Rivarola on 27/Jul/15.
//
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    struct Constants {
        static let ReuseCellID = "AudienciaReuseCellID"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    // MARK: TableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseCellID, forIndexPath: indexPath) as! AudienciasTableViewCell
        cell.titulo.text = "Audiencia \(indexPath.row)"
        cell.descripcion.text = "Descropcion casdasd sadijasid asidasidasjda sdasdioasdoisa dasdasdasdkjasd sadko \(indexPath.row)"
        cell.fecha.text = "Fecha: 25/05/04 a las 12:30 PM"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 188
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
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar", handler: {action, ip in
            
        })
        
        let actions = [editAction]
        return actions
    }
    tab
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
//        
//    }
}
