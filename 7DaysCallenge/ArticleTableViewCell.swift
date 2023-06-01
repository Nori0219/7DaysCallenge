//
//  ArticleTableViewCell.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/23.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet var contextLabel: UILabel!
    @IBOutlet var indexLabel: UILabel!
    @IBOutlet var dateLabal: UILabel!
    @IBOutlet var articleImageView: UIImageView?
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
    
    func setArticleCell(context: String, date: String,image: UIImage?) {
        contextLabel.text = context
        //indexLabel.text = String(index)
        dateLabal.text = date
        //articleImageView.image = image
        
        if let image = image {
            articleImageView?.image = image
        } else {
            articleImageView?.image = UIImage(named: "placeholder") // プレースホルダー画像などのデフォルトの画像を表示する
        }
    }
}
