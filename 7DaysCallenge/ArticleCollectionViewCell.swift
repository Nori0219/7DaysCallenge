//
//  ArticleCollectionViewCell.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/06/03.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet var contextLabel: UILabel!
    @IBOutlet var indexLabel: UILabel!
    @IBOutlet var dateLabal: UILabel!
    @IBOutlet var articleImageView: UIImageView?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
