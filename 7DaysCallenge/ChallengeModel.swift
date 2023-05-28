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
    @Persisted(primaryKey: true) var challengeUID = UUID().uuidString
    @Persisted var title: String = "" // 習慣のタイトル
    @Persisted var toDo: String = "" // 実施すること
    @Persisted var startDate: Date = Date() // 開始日
    @Persisted var doNotification: Bool = false // 通知の有無
    @Persisted var notificationTime: Date? // 通知時間
    @Persisted var streak: Int = 0// 連続日数
    
    // Relationship: ChallengeとArticleの関連付け
    let articles = List<Article>()
    
//    // Challengeクラス内のメソッドとしてstreakの更新を行うメソッドを追加する
//    func updateStreak() {
//        //let today = Date() // 今日の日付を取得
//        let calendar = Calendar.current
//
//        // チャレンジに関連する記事を日付順にソートする
//        let sortedArticles = articles.sorted(byKeyPath: "date")
//
//        var currentStreak = 0 // 現在の連続日数
//        var previousDate: Date? // 前回の記事の日付
//
//        // ソートされた記事を順に処理する
//        for article in sortedArticles {
//            let articleDate = article.date // 記事の日付を取得
//
//            // 前回の記事の日付と今回の記事の日付が連続しているかを確認
//            if let previousDate = previousDate,
//               calendar.isDate(previousDate, inSameDayAs: articleDate) ||
//                calendar.isDate(previousDate, equalTo: articleDate, toGranularity: .day) {
//                currentStreak += 1 // 連続している場合は連続日数をインクリメント
//            } else {
//                break // 連続が途切れた場合はループを終了
//            }
//
//            previousDate = articleDate // 前回の記事の日付を更新
//        }
//
//        streak = currentStreak // streakを更新
//        print("streakを更新したました streak: \(streak)")
//    }
}

class Article: Object {
    @Persisted var context: String = ""// 内容
    @Persisted var imageData: Data? // 画像（Data型）
    @Persisted var date: Date = Date()// 日付
    
    // Relationship: ArticleとChallengeの関連付け
    @Persisted var challengeID: String
    //    let parentChallenge = LinkingObjects(fromType: Challenge.self, property: "articles")//複数のChallengeオブジェクトを関連付ける時の書き方
}

