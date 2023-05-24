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
    @Persisted var title: String = ""
    @Persisted var toDo: String = ""
    @Persisted var startDate: Date = Date()
    @Persisted var doNotification: Bool = false
    @Persisted var streak: Int = 0
    let articles = List<Article>()
}

class Article: Object {
    @Persisted var context: String = ""
    var image: UIImage?
    @Persisted var date: Date = Date()
    //@Persisted(primaryKey: true) var id = UUID().uuidString
}


//class Challenge {
//    //@Persisted(primaryKey: true) var UID = UUID().uuidString
//     var title: String = ""
//    var toDo: String = ""
//    var startDate: Date = Date()
//    var doNotification: Bool = false
//    var streak: Int = 0
//    let articles = List<Article>()
//}
//
//class Article {
//     var context: String = ""
//    var image: UIImage?
//    var date: Date = Date()
//    //@Persisted(primaryKey: true) var id = UUID().uuidString
//}
