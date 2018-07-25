//
//  ViewController.swift
//  form
//
//  Created by Ali on 7/23/18.
//  Copyright © 2018 Ali. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    private var titleValueArray = [Int:NSArray]()
    private var plistPath = ""
    
    var indextPathRow = 0
    var permitToGo = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        permitToGo = false
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Copy to document directory
        let formPlistPath = Bundle.main.path(forResource: "forms", ofType: "plist") // the real path
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array
        let docpath = directories[0] as String
        plistPath = docpath.appending("/forms.plist")                            // the document path
        
        
        let dicRoot = NSDictionary.init(contentsOfFile: plistPath)
        if let root = dicRoot,root.count >= 1{
            for i in 1...(root.count){
                let ArrayFromDic: NSArray = NSArray.init(object: root.object(forKey: "\(i)") as Any)
                self.titleValueArray[i] = ArrayFromDic.object(at: 0) as? NSArray
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleValueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let array1 = titleValueArray[indexPath.row + 1]
        let cellTextLabel = "Name: \(String(describing: array1?[0] as! String)), Family: \(String(describing: array1?[1] as! String)), Gender: \(String(describing: array1?[2] as! String))"
        cell.textLabel?.text = cellTextLabel
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "addForm", let fvc = segue.destination as? FormViewController{
            fvc.pageTitle = 1
            fvc.keyValue = titleValueArray.count + 1
            fvc.plistPath = plistPath
        }else if let identifier = segue.identifier,permitToGo, identifier == "cellGoto", let fvc = segue.destination as? FormViewController{
            fvc.pageTitle = 2
            fvc.keyValue = indextPathRow
            fvc.plistPath = plistPath
        }else if let identifier = segue.identifier, identifier == "gotoWithLink", let fvc = segue.destination as? FormViewController{
            fvc.pageTitle = 3
            fvc.keyValue = titleValueArray.count + 1
            fvc.plistPath = plistPath
        }
        
    }
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, nil) in
            print("edited")
            self.indextPathRow = indexPath.row + 1
            self.permitToGo = true
            
            self.performSegue(withIdentifier: "cellGoto", sender: nil)

        }
        editAction.backgroundColor = .blue
        
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, nil) in
            print("deleted")
            let formDictionary = NSMutableDictionary.init(contentsOfFile: self.plistPath)
            formDictionary?.removeObject(forKey: "\(indexPath.row+1)")
            //formDictionary?.write(toFile: self.plistPath, atomically: true)
            
            for i in (indexPath.row+1)...(self.titleValueArray.count){
                formDictionary?.setValue(self.titleValueArray[i+1], forKey: "\(i)")
              //  formDictionary?.write(toFile: self.plistPath, atomically: true)
            }
            formDictionary?.removeObject(forKey: "\(String(describing: (formDictionary?.count)!+1))")
            formDictionary?.write(toFile: self.plistPath, atomically: true)
            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableViewController") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }

    
}

