//
//
//  Created by Hari Krishna Bista on 12/15/16.
//  Copyright © 2016 meroApp. All rights reserved.
//

import UIKit

class MusicListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblCollectionName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    
    weak var imgDataTask: URLSessionDataTask?
    @IBOutlet weak var viewCellContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
