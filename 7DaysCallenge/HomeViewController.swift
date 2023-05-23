//
//  HomeViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var container: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.layer.cornerRadius = 20
        container.layer.shadowColor = UIColor.black.cgColor //影の色を決める
        container.layer.shadowOpacity = 1 //影の色の透明度
        container.layer.shadowRadius = 0 //影のぼかし
        container.layer.shadowOffset = CGSize(width: 6, height: 9) //影の方向　width、heightを負の値にすると上の方に影が表示される
        
        
        //NavigationBarの＜Backを非表示にする　参考：https://spinners.work/posts/ios14_blank_back_button/
        if #available(iOS 14.0, *) {
          navigationItem.backButtonDisplayMode = .minimal
        } else {
          navigationItem.backButtonTitle = " "
        }
        
    }
    

   

}


