//
//  Challenge.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/24.
//

import Foundation
import UIKit
import RealmSwift

//@Persistedをつけていないプロパティは保存されない

class Challenge: Object {
    //@Persisted(primaryKey: true) var UID = UUID().uuidString
    @Persisted var title: String = "" // 習慣のタイトル
    @Persisted var toDo: String = "" // 実施すること
    @Persisted var startDate: Date = Date() // 開始日
    @Persisted var doNotification: Bool = false // 通知の有無
    @Persisted var notificationTime: Date? // 通知時間
    @Persisted var streak: Int = 0// Articleの個数
    
    // Relationship: ChallengeとArticleの関連付け
    let articles = List<Article>()
}

class Article: Object {
    @Persisted var context: String = ""// 内容
    @Persisted var imageData: Data? // 画像（Data型）
    @Persisted var date: Date = Date()// 日付
    
    // Relationship: ArticleとChallengeの関連付け
    let parentChallenge = LinkingObjects(fromType: Challenge.self, property: "articles")
}

