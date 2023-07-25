//
//  ArticleCollectionViewCell.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/06/03.
//

import UIKit
import ImageViewer

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var contextLabel: UILabel!
    @IBOutlet var indexLabel: UILabel!
    @IBOutlet var dateLabal: UILabel!
    @IBOutlet var articleImageView: UIImageView?
    
    var imageViewTapGesture: UITapGestureRecognizer!
    
    // セルの初期設定
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
        setupTapGesture()
    }
    
    func setupCellAppearance() {
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 3)//影の方向　width、heightを負の値にすると上の方に影が表示される
        self.layer.shadowOpacity = 0.1 //影の色の透明度
        self.layer.shadowRadius = 8 //影のぼかし
        self.layer.masksToBounds = false//影が表示されるように
    }
    // セルに表示する内容を設定するメソッド
    func setArticleCell(context: String, date: String,image: UIImage?) {
        contextLabel.text = context
        //indexLabel.text = String(index)
        dateLabal.text = date
        //articleImageView.image = image
        
        if let image = image {
            articleImageView?.image = image
        } else {
        }
    }
    
    // タップジェスチャーを設定するメソッド
    func setupTapGesture() {
        // ImageViewのジェスチャーレコグナイザーを設定
        imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        articleImageView?.addGestureRecognizer(imageViewTapGesture)
        articleImageView?.isUserInteractionEnabled = true
    }
    
    // セルのImageViewがタップされた時の処理を記述するメソッド
    @objc private func imageViewTapped(_ sender: UITapGestureRecognizer) {
        // セルのImageViewがタップされた時の処理を記述する
        print("セルのImageViewがタップされました")
        imageViewerOfCell()
    }

    func imageViewerOfCell() {
        let viewController = GalleryViewController(
            startIndex: 0,
            itemsDataSource: self,
            displacedViewsDataSource: self,
            configuration: [
                .deleteButtonMode(.none),
                .thumbnailsButtonMode(.none),
                .presentationStyle(.displacement),
                .displacementDuration(0.3),
                .reverseDisplacementDuration(0.25),
                .displacementTransitionStyle(.springBounce(0.7)),
                .displacementTimingCurve(.linear),
                .overlayColor(UIColor(white: 0.035, alpha: 1)),
                .overlayBlurStyle(UIBlurEffect.Style.light),
                .blurPresentDuration(0.3),
                .overlayBlurOpacity(0.5),
                .overlayColorOpacity(0.85),
            ])
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.presentImageGallery(viewController)
    }
    
}

// GalleryItemsDataSource
extension ArticleCollectionViewCell: GalleryItemsDataSource {
    // 要素数
    func itemCount() -> Int {
        return articleImageView?.image != nil ? 1 : 0
    }
    
    // ギャラリー要素
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return GalleryItem.image { $0(self.articleImageView!.image!) }
    }
}

// GalleryDisplacedViewsDataSource
extension ArticleCollectionViewCell: GalleryDisplacedViewsDataSource {
    // 移動可能要素
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return articleImageView as? DisplaceableView
    }
}
