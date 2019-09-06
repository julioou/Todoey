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
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    var realm = try! Realm()
    @IBOutlet var searchBar: UISearchBar!
    
    // Definindo qual sera a lsita carregada com base na categoria.
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Definindo o título da lista.
        title = selectedCategory!.name
        //Inicializando as cores do cabeçalho conforme sua categoria.
        guard let colourHex = selectedCategory?.colour else {fatalError()}
        updateBarColour(withHexCode: colourHex)
    }
    
    //Ao voltar para tela de categorias, o cabeçalho devera mudar para sua cor original.
    override func viewWillDisappear(_ animated: Bool) {
        updateBarColour(withHexCode: "1D9BF6")
    }
    
    //MARK: - Funções atreladas a Table View
    //Função para definir a quantidade de células
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //Definindo as cores do cabeçalho da lista conforme a sua categoria.
    //Definindo as cores da barra de pesquisa.
    func updateBarColour(withHexCode hexColourCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        navBar.barTintColor = UIColor(hexString: hexColourCode)
        searchBar.barTintColor = UIColor(hexString: hexColourCode)
    }
    
    // Função para modificar as células
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Chamando a super classe.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            //Definindo texto e cor da lista.
            cell.textLabel?.text = item.title
            cell.textLabel?.textColor = UIColor.white
            
            //Definido as cores das listas, conforme a cor da sua categoria.
            if let colour = selectedCategory?.colour {
                cell.backgroundColor = UIColor(hexString: colour)
            }

            /* Operador ternário, onde, se a propriedade done for true então a cell recebe um checkmark, caso false, ele não recebe nenhum accessoryType. */
            cell.accessoryType = item.done == true ? .checkmark : .none
        }
        else {
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

