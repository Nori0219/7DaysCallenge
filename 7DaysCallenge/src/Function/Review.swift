//
//  Review.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/06/27.
//

import Foundation
import UIKit
import StoreKit

class ReviewHelper {
    
    private static let reviewRequestLimit = 3
    private static let reviewRequestKey = "ReviewRequestCount"
    
    static func showReviewDialog(from viewController: UIViewController) {
        
        let reviewRequestCount = getReviewRequestCount()
        
        guard reviewRequestCount < reviewRequestLimit else {
            // 制限に達している場合の処理（ダイアログを表示しないなど）
            return
        }
        
        let alert = UIAlertController(title: "週チャレをご利用いただきありがとうございます！", message: "アプリを気に入っていただけましたか？レビューでの応援が何よりの励みになります！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "応援する", style: .default, handler: { action in
            self.requestAppReview(from: viewController)
            print("レビューの表示")
        }))
        alert.addAction(UIAlertAction(title: "応援しない", style: .destructive, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
        
        incrementReviewRequestCount()
    }
    
    static func requestAppReview(from viewController: UIViewController) {
        //レビューダイアログを表示
        SKStoreReviewController.requestReview()
    }
    
    //UserDefaultにレビュー回数を保存
    private static func getReviewRequestCount() -> Int {
        let defaults = UserDefaults.standard
        let count = defaults.integer(forKey: reviewRequestKey)
        return count
    }
    
    private static func incrementReviewRequestCount() {
        let defaults = UserDefaults.standard
        let newCount = getReviewRequestCount() + 1
        defaults.set(newCount, forKey: reviewRequestKey)
    }
}
