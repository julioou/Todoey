//
//  ViewController.swift
//  Todoey
//
//  Created by Treinamento on 8/29/19.
//  Copyright © 2019 trainee. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    // Localizando e definindo o local de armazenamento de dados.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    // Declarando que o context é uma referência a classe AppDelegate.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Definindo estilo da table view.
        tableView.separatorStyle = .singleLine
    
        
        loadItems()
        
    }
    
    //MARK: - Funções atreladas a Table View
    //Função para definir a quantidade de células
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Função para modificar as células
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        /* Operador ternário, onde, se a propriedade done for true então a cell recebe um checkmark, caso
         false, ele não recebe nenhum accessoryType. */
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Funções para selecionar os itens da lista
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /* A propriedade done do itemArray sera diferente da propriedade done do itemArray
         ou seja se o itemArray esta true, então ele sera o seu oposto. */
        let item = itemArray[indexPath.row]
        item.done = !item.done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItem()
        
    }
    
    //MARK: - Adicionar novos itens para lista
    @IBAction func pressedAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        //Adiciona novo item para lista
        let alertContr = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let alertAct = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.done = false
            newItem.title = textField.text!
            
            
            self.itemArray.append(newItem)
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItem()
            
        }
        
        alertContr.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alertContr.addAction(alertAct)
        self.present(alertContr, animated: true, completion: nil)
        
    }
    
    
//MARK - Métodos para tratar os dados da lista.
    
    // Função para encodar em um plist os itens do todolist.
    func saveItem(){
        //Salvando os dados no CoreData data model.
        do {
            try context.save()
        }
        catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    // Função para não perder os dados a cada vez que iniciar o app.
 
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
}
