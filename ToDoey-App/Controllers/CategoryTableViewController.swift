
import UIKit
import RealmSwift
import ChameleonFramework

 class CategoryTableViewController: SwipeTableViewController {

     let realm = try! Realm()
     var categories: Results<Category>?
     
     override func viewDidLoad() {
        super.viewDidLoad()
         loadCategories()
      }

//MARK: - Nav Bar Appearance
     
     override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
                
              if let navBarBackgroundColor = UIColor(hexString: "1D9BF6") {
                    updateNavBarColor(navBarBackgroundColor)
                }
          }
     
     
     //MARK: - TableView Datasource Methods
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         return categories?.count ?? 1
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
         let cell = super.tableView(tableView, cellForRowAt: indexPath)

         let category = categories?[indexPath.row]
         
         cell.textLabel?.text = category?.name ?? "No Categories Added Yet"
         
         if let colour = category?.colorName  {
             
           cell.backgroundColor = UIColor(hexString: colour)
           cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: colour)!, returnFlat: true)
             
         }
    
         return cell
     }
     
     //MARK: - TableView Delegate Method
     
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         if categories != nil {
             performSegue(withIdentifier: "goToItems", sender: self)
         }
         tableView.deselectRow(at: indexPath, animated: true)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
         let destinationVC = segue.destination as! ToDoListViewController
         
         if let indexPath = tableView.indexPathForSelectedRow {
            
             destinationVC.selectedCategory = categories?[indexPath.row]
         }
     }
     
     

     //MARK: - Data manipulator Methods
     
     func save(category: Category) {
         do {
             try realm.write {
                 realm.add(category)
             }
         } catch {
             print("Error saving category \(error)")
         }
         self.tableView.reloadData()
     }
     
     func loadCategories() {
         categories = realm.objects(Category.self)
         self.tableView.reloadData()
     }
     
     //MARK: - delete category
     
     override func updateModel(at indexPath: IndexPath) {
         
         if let categoryForDeletion = self.categories?[indexPath.row] {
              do {
                  try self.realm.write {
                      self.realm.delete(categoryForDeletion)
                  }
              } catch {
                  print("Error deleting category, \(error)")
              }
          }
     }
     
     //MARK: - add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colorName = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

