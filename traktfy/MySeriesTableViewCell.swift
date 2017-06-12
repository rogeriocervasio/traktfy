//
//  MySeriesTableViewCell.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 11/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit

class MySeriesTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.labelTitle.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
