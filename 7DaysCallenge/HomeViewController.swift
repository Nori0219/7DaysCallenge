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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
