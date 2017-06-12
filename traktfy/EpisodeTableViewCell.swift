//
//  EpisodeTableViewCell.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 12/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelEpisode: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonWatched: UIButton!
    @IBOutlet weak var labelOverview: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.labelEpisode.text = nil
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
