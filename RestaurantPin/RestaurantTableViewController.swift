//
//  RestaurantTableViewController.swift
//  RestaurantPin
//
//  Created by yucian huang on 2024/3/20.
//
import UIKit

class RestaurantTableViewController: UITableViewController {
    
    var restaurantIsFavorites = Array(repeating: false, count: 21)    //Bool
    var restaurantIsVisited = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false , false]
    
    enum Section {
        case all
    }
    
    var restaurantNames = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po's Atelier", "Bourke Street Bakery", "Haigh's Chocolate", "Palomino Espresso", "Upstate", "Traif", "Graham Avenue Meats", "Waffle & Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
    
    var restaurantImages = ["cafedeadend", "homei", "teakha", "cafeloisl", "petiteoyster", "forkee", "posatelier", "bourkestreetbakery", "haigh", "palomino", "upstate", "traif", "graham", "waffleandwolf", "fiveleaves", "cafelore", "confessional", "barrafina", "donostia", "royaloak", "cask"]
    
    var restaurantLocations = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
    
    var restaurantTypes = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austrian / Causual Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American / Seafood", "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea", "Latin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]
    
    lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.separatorStyle = .none
        tableView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurantNames, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, String> {
        
        let cellIdentifier = "favcell"
        
        let dataSource = UITableViewDiffableDataSource<Section, String>(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, restaurantName in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
                
                cell.nameLabel.text = restaurantName
                cell.locationLabel.text = self.restaurantLocations[indexPath.row]
                cell.typeLabel.text = self.restaurantTypes[indexPath.row]
                
                cell.thumbnailImageView.image = UIImage(named: self.restaurantImages[indexPath.row])
                cell.accessoryType = self.restaurantIsFavorites[indexPath.row] ? .checkmark : .none
                
                return cell
            }
        )
        
        return dataSource
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // 1. Call the didselect
        // 2. Set a optionMenu constant -> UIAlertController
        // 3. Set a UIAlertAction
        // 4. optionMenu.addButton(UIAlertAction we just created)
        let optionMenu = UIAlertController(title: "Dear VIP Customer" , message: "What do you want to do?", preferredStyle: .actionSheet)
        
        //  CANCEL ACTION
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil) //display
        
        tableView.deselectRow(at: indexPath, animated: false) //cancel
        
        // BECAUSE WE NEED EXTRA CORRESAPONEDED ACTION
        // WE USE CLOSURE TO EXECUE THE ACTION WE NEED
        // create handler first before we use in inside we set the action
        
        let reserveActionHandler = { (action: UIAlertAction!) -> Void in
            
            let alertMessage = UIAlertController(title: "Not available yet", message: "Sorry this feature is not available yet. Please try later.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        // RESERVE
        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default, handler: reserveActionHandler)
        optionMenu.addAction(reserveAction)
        
        
        // FEEDBACK
        let commentActionHandler = {(action: UIAlertAction!) -> Void in
            let commentMessage = UIAlertController(title: "Rate Us", message: "Do you like today's service?", preferredStyle: .alert)
            commentMessage.addAction(UIAlertAction(title: "Sure", style: .destructive, handler: nil))
            self.present(commentMessage, animated: true, completion: nil)
        }
        let commentAction = UIAlertAction(title: "Give us feedback", style: .default, handler: commentActionHandler)
        optionMenu.addAction(commentAction)
        
        
        // FAVORITE
        // Direct declare the handler, we can directly add the action in optionMenu
        let favoriteAction = UIAlertAction(title: "Mark as favorite", style: .default, handler: {
            
            (action: UIAlertAction!) -> Void in
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            
            self.restaurantIsFavorites[indexPath.row] = true
        })
        optionMenu.addAction(favoriteAction)
        
        // MAP
        let openMapAction = UIAlertAction(title: "Open map", style: .default, handler: {
            
            (action: UIAlertAction!) -> Void in
            
            let clickedMapcell = tableView.cellForRow(at: indexPath)
            clickedMapcell?.accessoryType = .disclosureIndicator
        })
        optionMenu.addAction(openMapAction)
        
        // DONATE
        
        // String handler cant be directly into UIAlertAction completion!!
        // So need to declare the complete handler outside first
        let donateActionHandler =  {
            
            (action: UIAlertAction!) -> Void in
            
            let donateMessage = UIAlertController(title: "You're so kind!", message: "Appreciate your kindness!!", preferredStyle: .alert)
            donateMessage.addAction(UIAlertAction(title: "No problem", style: .destructive, handler: nil))
            
            // style: .destructive -> red tint/ .default -> blue
            
            self.present(donateMessage, animated: true, completion: nil)
        }
        let donateAction = UIAlertAction(title: "Donate right now", style: .default, handler: donateActionHandler)
        optionMenu.addAction(donateAction)
        
        
        
    }
    /*
     The reason you cannot directly use the `DonateAction` handler instead of individually declaring the message first is because the `UIAlertAction` initializer expects a closure (handler) as its parameter. This closure takes an `UIAlertAction` object as its parameter and returns `Void` (or `()` in Swift), indicating it doesn't return anything.

     In the case of the "Open map" action, the handler is a simple closure that just changes the accessory type of a cell. It doesn't require any additional setup or interaction with the user.

     However, for the "Donate right now" action, it seems you want to display an alert message when the action is triggered. This alert message requires a separate UIAlertController to be created with a title and a message, and then presented to the user. So you need to declare a separate handler (`donateActionHandler`) where you can set up this UIAlertController and its presentation logic.

     In summary, you cannot directly use the `DonateAction` handler because it involves more than just changing a cell accessory type; it requires displaying an alert message, which involves additional setup and interaction with the user. Therefore, you need to declare a separate handler to handle this functionality.
     */
    
 
   
}
