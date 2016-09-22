//
//  User.swift
//  UserData
//
//  Created by Denys on 9/20/16.
//  Copyright © 2016 Denys Holub. All rights reserved.
//

import Foundation


class User {
  let login: String?
  let link: String?
  let image: String?

  init(login: String?, link: String?, image: String?) {
    self.login = login
    self.link = link
    self.image = image
  }
}

