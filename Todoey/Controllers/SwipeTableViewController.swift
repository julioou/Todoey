//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Treinamento on 9/5/19.
//  Copyright © 2019 trainee. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

//I atribute the Swipe class as a UITableVC, because I will can innherite all
//the methods and atributes it into another class child.
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    //MARK:- Função para adicionar animações e opção para deletar células.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Delete cell")
            
            self.deleteCell(at: indexPath)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func deleteCell(at indexPath: IndexPath) {
    //Delete each type of Realm Object in the current file.
        print("Delete Cell Worked")
    }
    
    //Função que habilita remover a célula ao puxar lá toda.
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
