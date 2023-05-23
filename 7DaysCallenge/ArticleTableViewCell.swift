//
//  ArticleTableViewCell.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/23.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet var contextLabel: UILabel!
    @IBOutlet var streakLabel: UILabel!
    @IBOutlet var dateLabal: UILabel!
    @IBOutlet var todayImageView: UIImageView?
    
    @IBOutlet var mainBackground: UIView!
    @IBOutlet var shadowLayer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(context: String, streak: Int, date: Date,image: UIImage) {
        contextLabel.text = context
        streakLabel.text = String(streak)
        //dateLabal.text = String(date)
        todayImageView?.image = image
    }
    
}
