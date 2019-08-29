//
//  ViewController.swift
//  Todoey
//
//  Created by Treinamento on 8/29/19.
//  Copyright © 2019 trainee. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
    var itemArray = ["Fix the car","Find the keys","Go home"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
    }
    
//MARK - Funções atreladas a Table View
//Função para definir a quantidade de células
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

// Função para modificar as células
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }

//MARK - Funções para selecionar os itens da lista
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
//Adiciona um checkmark para a célula selecionada
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            print(itemArray[indexPath.row])
        } else {
//Remove um checkmark da célula selecionada
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
    }

}

