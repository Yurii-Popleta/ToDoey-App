//  SwipeTableViewController.swift
//  Todoey
//  Created by Admin on 15/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.


import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func updateNavBarColor(_ backgroundColor: UIColor) {
            guard let navBar = navigationController?.navigationBar else { fatalError("NavigationController does not exist") }
            
            let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.backgroundColor = backgroundColor
        
            let contrastOfBackgroundColor = ContrastColorOf(backgroundColor, returnFlat: true)
        
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastOfBackgroundColor]
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastOfBackgroundColor]
            
            navBar.standardAppearance = navBarAppearance
            navBar.scrollEdgeAppearance = navBarAppearance
            navBar.tintColor = contrastOfBackgroundColor
        
        }
    
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
             
                self.updateModel(at: indexPath)
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")

            return [deleteAction]
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }
    
    func updateModel(at indexPath: IndexPath) {
   
    }
    
}
