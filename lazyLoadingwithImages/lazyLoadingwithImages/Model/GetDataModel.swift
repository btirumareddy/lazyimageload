//
//  GetDataModel.swift
//  lazyLoadingwithImages
//
//  Created by Bhanuja Tirumareddy on 02/07/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//

import Foundation.NSURL
class GetDataModel {
  let dateTime: String
  let id: Int
let size : String
  let status: String
  let thumbnail: URL
  // MARK: - Variables And Properties
  
  // MARK: - Initialization
  //
    init(dateTime: String, status: String, thumbnail: URL, id: Int, size: String) {
    self.dateTime = dateTime
    self.status = status
    self.thumbnail = thumbnail
    self.size = size
    self.id = id
  }
}
