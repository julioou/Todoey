//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Treinamento on 9/3/19.
//  Copyright © 2019 trainee. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
                destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
//MARK: - TableView Datasource Methods
    
    //Determinado a quantidade de celular com base na quantidade de itens dentro do categoryArray.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //Determinado qual sera a célula que vai preencher a table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = categoryArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = item.name
        
        return cell
    }
    
//MARK: - Data Manipulation Methods
    
    //Função para salvar os dados.
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
    
    // Função para carregar os dados da memória.
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
//MARK: - Add New Categories
    
    @IBAction func AddCategoryButton(_ sender: UIBarButtonItem) {
        print("Button Work")
        var textField = UITextField()
        
        /* Declara o alerta na tela e determina como sera adicionado um novo item na lista de
        categorias. */
        let alertContr = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAct = UIAlertAction(title: "Add Category", style: .default) { (action) in

            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!

            self.categoryArray.append(newCategory)
            
            self.saveItem()
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
