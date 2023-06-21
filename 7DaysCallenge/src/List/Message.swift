//
//  Message.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/06/04.
//

import Foundation


//通知メッセージ
struct ChallengeMessage {
    static func normal(for streak: Int, challenge: Challenge) -> String {
        switch streak {
        case 0:
            return "さあ、新たなチャレンジの幕開けです！今日から頑張りましょう！🔥"
        case 1:
            return "素晴らしい！連続\(challenge.streak)日目です。まだまだこれからですよ！🛵"
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
    
    static func passion(for streak: Int, challenge: Challenge) -> String {
        switch streak {
        case 0:
            return "さあ、新たなチャレンジの幕開だ！今日から全力でぶっ飛ばしていこうぜ！🔥🚀"
        case 1:
            return "イェーイ！もう連続\(challenge.streak)日目だぜ！まだまだ序の口だ！気合を入れて突き進もうぜ！💪🔥💥"
        case 2:
            return "ガッツ！見事な連続達成だ！\(challenge.streak)日間継続とかマジで燃えるぜ！お前はまさに無敵のチャレンジャーだ！🔥👊💥"
        case 3:
            return "ヤバいぜ！\(challenge.streak)日連続達成だ！お前のチャレンジ魂は炎上し続けているな！さらなる高みを目指して突き進め！💥🔥🚀"
        case 4:
            return "オーマイガー！連続\(challenge.streak)日間の偉業に舌を巻くぜ！お前はまさに伝説のチャレンジャーだ！継続の魔術師として世界に名を轟かせろ！🔥🌟💪"
        case 5:
            return "キャッホー！もう止まらねぇぜ！連続\(challenge.streak)日間の快挙を達成したんだ！お前の情熱が宇宙を揺るがすぜ！世界記録を目指してもっと燃え上がれ！🔥🌍💥"
        case 6:
            return "なんとついに連続\(challenge.streak)日間も継続できたぜ！いよいよ今日で最終日、最後の戦いだ！気合を入れて一気にゴールを目指せ！🔥💯🚀"
        case 7:
            return "伝説だぜ！お前は連続\(challenge.streak)日間の偉業を達成したんだ！超絶チャレンジャーとして尊敬に値するぜ！これからも燃え続けて、さらなる高みを目指せ！🔥🏆💪"
            
        default:
            return "ブッチギリだぜ！もう連続\(challenge.streak)日目だ！まだまだ足りねぇぜ！今日も全力で突き進め！お前ならできる！💥🔥💪"
        }
    }
    
    static func hero(for streak: Int, challenge: Challenge) -> String {
        switch streak {
        case 0:
            return "新たなる挑戦の始まりだ！勇者よ、勇気を持って立ち向かえ。未知なる力がお前を待っているぞ！⚔️"
        case 1:
            return "おお、勇者よ。\(challenge.streak)日目を迎えたか。\nまだまだ道のりは長いぞ、さらなる高みへと駆け上がれ！"
        case 2:
            return "偉大なる勇者よ、連続\(challenge.streak)日間の挑戦を果たしたことに感嘆せざるを得ん。その剣の輝きはますます増しているな！🌟⚔️"
        case 3:
            return "連続\(challenge.streak)日目も果たした勇者よ。お前の勇気と覚悟は並々ならぬものだ。さらなる冒険が待っているぞ！⚔️💪"
        case 4:
            return "立派じゃ！連続\(challenge.streak)日間の偉業を成し遂げし勇者よ。お前は真の戦士として称えられるに相応しい！さらなる困難に立ち向かおう！🌟⚔️"
        case 5:
            return "驚異じゃ！\(challenge.streak)日間の連続挑戦達成を果たした勇者よ。その勇姿は世界に轟き渡るだろう！新たなる伝説を刻もう！🌍⚔️"
        case 6:
            return "勇者よ、遂に連続\(challenge.streak)日間の挑戦を成し遂げた。本日は最後の日、その剣の力を存分に発揮せよ！🔥⚔️"
        case 7:
            return "壮絶じゃ！連続\(challenge.streak)日間の偉業を達成した勇者よ。お前の勇気と闘志に、世界中の人々が感動せざるを得ん！さらなる勇躍を目指し、進み続けよう！🌟⚔️"
            
        default:
            return "勇者よ、順調に\(challenge.streak)日目を迎えた。我らの冒険はまだ続く。新たなる試練に立ち向かおう！⚔️💂"
        }
    }
    
    
    static func cheer(for streak: Int, challenge: Challenge) -> String {
        switch streak {
        case 0:
            return "新しいチャレンジの始まりだよ！応援するから一緒に最後まで走り切ろう！頑張ればきっと素晴らしい結果が待ってるよ！"
        case 1:
            return "すごいね！もう連続\(challenge.streak)日目だよ。続けてる姿、本当に頼もしいよ。これからも一緒に楽しく頑張っていこう！"
        case 2:
            return "ヤッホー！連続\(challenge.streak)日間の達成だよ。あなたの努力は着実に実を結んでるね。さらなる成長を楽しみながら、一緒に頑張ろう！"
        case 3:
            return "\(challenge.streak)日連続達成だね！めっちゃ凄いよ！君の成長、本当に見逃せないよ！一緒に頑張って、次のステップに進もう！💪🎉"
        case 4:
            return "ウオオオ！連続\(challenge.streak)日間のチャレンジ成功だね。その努力と継続への意志すごく尊敬できる！これからも一緒に頑張っていこう！"
        case 5:
            return "ワォー！もう連続\(challenge.streak)日間も継続してるんだね。君の頑張りめちゃくちゃ感動するよ！最後まで頑張って目標を達成してね！💪"
        case 6:
            return "なんと連続\(challenge.streak)日間も継続できたよ！最終日まであと少し！一緒に最後までファイトだ！🔥💪"
        case 7:
            return "イェーイ！連続\(challenge.streak)日間のチャレンジ達成だよ。君の努力と忍耐力、超素晴らしい！1週間お疲れさま！🎉🌈"
            
        default:
            return "順調だね！\(challenge.streak)日連続達成だよ！"
            
            
        }
    }
    
}







