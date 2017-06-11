//
//  SeasonTableViewCell.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 11/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit

class SeasonTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSeason: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.labelSeason.text = nil
        self.labelTitle.text = nil
        self.labelOverview.text = nil
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
