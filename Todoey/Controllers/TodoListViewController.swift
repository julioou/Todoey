//
//  ViewController.swift
//  Todoey
//
//  Created by Treinamento on 8/29/19.
//  Copyright © 2019 trainee. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    var realm = try! Realm()
    
    // Definindo qual sera a lsita carregada com base na categoria.
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
    }
    
    //MARK: - Funções atreladas a Table View
    //Função para definir a quantidade de células
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // Função para modificar as células
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            /* Operador ternário, onde, se a propriedade done for true então a cell recebe um checkmark, caso false, ele não recebe nenhum accessoryType. */
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added."
        }
        
        return cell
    }
    
    //MARK: - Funções para selecionar os itens da lista
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving done status,\(error)")
            }
            
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Adicionar novos itens para lista
    @IBAction func pressedAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        //Adiciona novo item para lista
        let alertContr = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let alertAct = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let  currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error adding item.")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alertContr.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alertContr.addAction(alertAct)
        self.present(alertContr, animated: true, completion: nil)
        
    }
    //MARK: - Deleting Data From Realm
    override func deleteCell(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            }
            catch {
                print("Erro deleting item, \(error)")
            }
        }
    }
    
    //MARK - Métodos para tratar os dados da lista.
    
    // Função para não perder os dados a cada vez que iniciar o app.
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let keyPathSearch : String = "dateCreated"
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: keyPathSearch, ascending: true)
        
        
        tableView.reloadData()
    }
    //função para que assim que ocorra mudanças na search bar o sistema responda.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

