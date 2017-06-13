//
//  NextTableViewCell.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 13/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit

class NextTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSeriesName: UILabel!
    @IBOutlet weak var labelEpisode: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.labelSeriesName.text = nil
        self.labelEpisode.text = nil
        self.labelDate.text = nil
        self.labelTitle.text = nil
        self.labelTime.text = nil
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
