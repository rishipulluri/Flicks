//
//  MovieCell.swift
//  Flicks
//
//  Created by saritha on 1/10/16.
//  Copyright © 2016 saritha. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var imagenew: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var overviewlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
