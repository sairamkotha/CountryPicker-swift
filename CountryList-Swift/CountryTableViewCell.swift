//
//  CountryTableViewCell.swift
//  CountryList-Swift
//
//  Created by Sai Ram Kotha on 29/01/16.
//
//

import UIKit

class CountryTableViewCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
     super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier) 
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      self.accessoryType = .Checkmark
    }else{
      self.accessoryType = .None
    }
  }
  
}
