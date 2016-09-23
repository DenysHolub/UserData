//
//  UserTableViewController.swift
//  UserData
//
//  Created by Denys on 9/20/16.
//  Copyright © 2016 Denys Holub. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController, UISearchResultsUpdating {

  // 1
  let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
  // 2
  var dataTask: URLSessionDataTask?
  
  var user = [User]()
  
  var searchController: UISearchController!
  var searchResultsArray: [User] = []
  
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      sendUrlRequest()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
      
      searchController = UISearchController(searchResultsController: nil)
      searchController.searchBar.sizeToFit()
      tableView.tableHeaderView = searchController.searchBar
      
      definesPresentationContext = true
      
      searchController.searchResultsUpdater = self
      searchController.dimsBackgroundDuringPresentation = false
      
      searchController.searchBar.tintColor = UIColor.white
    }
  
  func updateResults(data: Data?) {
    do {
      if let data = data, let response = try JSONSerialization.jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [AnyObject] {
        
        // Get the results array
        if let array: AnyObject = response as AnyObject? {
          for dictonary in array as! [AnyObject] {
            if let dictonary = dictonary as? [String: AnyObject] {
              // Parse the search result
              let login = dictonary["login"] as? String
              let link = dictonary["html_url"] as? String
              let image = dictonary["avatar_url"] as? String
              user.append(User(login: login, link: link, image: image))
            } else {
              print("Not a dictionary")
            }
          }
        } else {
          print("Results key not found in dictionary")
        }
      } else {
        print("JSON Error")
      }
    } catch let error as NSError {
      print("Error parsing results: \(error.localizedDescription)")
    }
    
    DispatchQueue.main.async(execute:{
      self.tableView.reloadData()
      //self.tableView.setContentOffset(CGPoint.zero, animated: false)
    })
  }
  
  func sendUrlRequest() {
    
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    // 3
    // 4
    let url = NSURL(string: "https://api.github.com/users?since=0&per_page=80")
    // 5
    dataTask = defaultSession.dataTask(with: url! as URL) {
      data, response, error in
      // 6
      DispatchQueue.main.async(execute:{
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      })
      // 7
      if let error = error {
        print(error.localizedDescription)
      } else if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          self.updateResults(data: data)
        }
      }
    }
    // 8
    dataTask?.resume()
  }
  
  
  func filterContentFor(searchText: String) {
    searchResultsArray = user.filter({ (users: User) -> Bool in
      let machedName = users.login?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
        
      return machedName != nil
    })
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    
    let searchText = searchController.searchBar.text
    filterContentFor(searchText: searchText!)
    
    tableView.reloadData()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      if searchController.isActive {
        return searchResultsArray.count
      } else {
        return user.count
      }
    }

  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    print("You selected cell #\(indexPath.row)!")
  }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cellIdentifier = "Cell"
      
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell

        // Configure the cell...
      
      let users = (searchController.isActive) ? searchResultsArray[indexPath.row] : user[indexPath.row]
      let url = NSURL(string: users.image!)
      let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
      cell.thumbnailImageView.image = UIImage(data: data! as Data)
      
      //cell.thumbnailImageView.image = UIImage(named: user[indexPath.row].image!)
      
      cell.loginLabel.text = users.login
      cell.linkLabel.text = users.link
      cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.height / 2
      cell.thumbnailImageView.clipsToBounds = true

      return cell
    }
  
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
      if searchController.isActive {
        return false
      } else {
        return true
      }
    }
  

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showImageSegue" {
        if let indexPath = self.tableView.indexPathForSelectedRow {
          let detinationVC = segue.destination as! ImageViewController
          detinationVC.user = (searchController.isActive) ? searchResultsArray[indexPath.row] : user[indexPath.row]
        }
      }
    }

}
