
 import UIKit
 import RealmSwift
 import ChameleonFramework

 class ToDoListViewController: SwipeTableViewController  {

     @IBOutlet weak var searchBar: UISearchBar!
     
     var todoItems: Results<Item>?
     
     let realm = try! Realm()
     
     var selectedCategory: Category? {
         didSet {
            loadItems()
         }
     }

    override func viewDidLoad() {
        super.viewDidLoad()
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        }
     
     //MARK: - Nav Bar Appearance
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
                 
                 if let safeCategory = selectedCategory {
                     title = safeCategory.name
                     
                     if let categoryColor = UIColor(hexString: safeCategory.colorName) {
                         updateNavBarColor(categoryColor)
                         searchBar.barTintColor = categoryColor
                         searchBar.searchTextField.backgroundColor = categoryColor.lighten(byPercentage: 0.5)
                 }
             }
         }
     

  //MARK: - sourceData
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
    
            if let colour = UIColor(hexString: selectedCategory!.colorName)?.darken(byPercentage: CGFloat(indexPath.row)*0.5 / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
      
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
   
   //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                item.done = !item.done
              }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
         // context.delete(todoItems[indexPath.row])
       // todoItems.remove(at: indexPath.row)
        
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
  
            if let currentCategory = self.selectedCategory {
               do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
            } catch {
                print("Error saving category \(error)")
            }
        }
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
     
     
   func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
   }
     
     //MARK: - delete item
     
     override func updateModel(at indexPath: IndexPath) {
         
         if let itemForDeletion = self.todoItems?[indexPath.row] {
              do {
                  try self.realm.write {
                      self.realm.delete(itemForDeletion)
                      DispatchQueue.main.async {
                          self.tableView.reloadData()
                      }
                  }
              } catch {
                  print("Error deleting category, \(error)")
              }
          }
     }
     
}

//MARK: - searchButtonDelegate

extension ToDoListViewController: UISearchBarDelegate {
          
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
             searchBar.resignFirstResponder()
            }
        }
    }
}
