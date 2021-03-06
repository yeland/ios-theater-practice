//
//  BannerCell.swift
//  ios-theater
//
//  Created by Linxiao Wei on 2019/12/18.
//  Copyright © 2019 Linxiao Wei. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  func configure(imageName: String) {
    let image = UIImage(named: imageName)
    imageView.image = image
  }
}
