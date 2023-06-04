//
//  Message.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/06/04.
//

import Foundation

//通知メッセージ
struct ChallengeMessage {
    static func message(for streak: Int, challenge: Challenge) -> String {
        switch streak {
        case 0:
            return "\(challenge.toDo)\nさあ、新たなチャレンジの幕開けです！今日から頑張りましょう！"
        case 1:
            return "素晴らしい！連続\(challenge.streak)日目です。まだまだこれからですよ！"
        case 2:
            return "オオ、見事な連続達成！\(challenge.streak)日間継続です。驚きの才能を感じますね！"
        case 3:
            return "\(challenge.streak)日連続達成です！まさに挑戦のマスター！もうやめられませんね！"
        case 4:
            return "すごい！連続\(challenge.streak)日間の偉業です。あなたはチャレンジのプロですね！"
        case 5:
            return "ワオ！もう止められません！連続\(challenge.streak)日間の快挙です！目指せ、世界新記録！"
        case 6:
            return "\(challenge.toDo)\nなんとついに連続\(challenge.streak)日間も継続できました！いよいよ今日で最終日、ファイト🔥！"
        case 7:
            return "すごい！連続\(challenge.streak)日間の偉業です。あなたはチャレンジのプロですね！"
            
        default:
            return "順調ですね！連続\(challenge.streak)日目です。もっと続けましょう！"
        }
    }
}






