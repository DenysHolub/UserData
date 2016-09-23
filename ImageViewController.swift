//
//  ImageViewController.swift
//  UserData
//
//  Created by Denys on 9/23/16.
//  Copyright © 2016 Denys Holub. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

  @IBOutlet weak var userImageView: UIImageView!
  
  var user: User!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      let url = NSURL(string: user.image!)
      let data = NSData(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
      self.userImageView.image = UIImage(data: data! as Data)
      
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
