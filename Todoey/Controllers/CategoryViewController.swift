//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Treinamento on 9/3/19.
//  Copyright © 2019 trainee. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadItems()
        
    }
    
//MARK: - Mudando entre listas
    //Função para executar a troca entre as table views
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
            
        if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
//MARK: - TableView Datasource Methods
    //Determinado a quantidade de celular com base na quantidade de itens dentro do categories.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //Determinado qual sera a célula que vai preencher a table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.colour )
            cell.textLabel?.textColor = UIColor.white
            
        }
        return cell
    }
    
//MARK: - Data Manipulation Methods
    //Função para salvar os dados.
    func saveItem(category: Category){
        //Salvando os dados no CoreData data model.
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    // Função para carregar os dados da memória.
    func loadItems() {

        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
//MARK: - Deleting Data From Realm
    //Calling fuction from our superclass
    override func deleteCell(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            }
            catch {
                print("Error deleting category, \(error)")
            }
            
        }
    }

    
//MARK: - Add New Categories
    
    @IBAction func AddCategoryButton(_ sender: UIBarButtonItem) {
        print("Button Work")
        var textField = UITextField()
        
        /* Declara o alerta na tela e determina como sera adicionado um novo item na lista de
        categorias. */
        let alertContr = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAct = UIAlertAction(title: "Add Category", style: .default) { (action) in

            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.saveItem(category: newCategory)
        }
        
        //Adiciona um campo de texto para criar uma nova célula.
        alertContr.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        //Acopla o alerta e o botão de alerta.
        alertContr.addAction(alertAct)
        
        present(alertContr, animated: true, completion: nil)
    }
}

