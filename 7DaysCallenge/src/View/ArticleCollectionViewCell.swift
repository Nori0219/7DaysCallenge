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
        
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 3)//影の方向　width、heightを負の値にすると上の方に影が表示される
        self.layer.shadowOpacity = 0.1 //影の色の透明度
        self.layer.shadowRadius = 8 //影のぼかし
        self.layer.masksToBounds = false//影が表示されるように
        
    }
    
    func setArticleCell(context: String, date: String,image: UIImage?) {
        contextLabel.text = context
        //indexLabel.text = String(index)
        dateLabal.text = date
        //articleImageView.image = image
        
        if let image = image {
            articleImageView?.image = image
        } else {
            //articleImageView?.isHidden = true // 画像の非表示
            //print("画像は非表示デイ")
        }
    }
}
