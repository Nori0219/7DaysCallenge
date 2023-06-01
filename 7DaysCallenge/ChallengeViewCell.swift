//
//  ArchiveCollectionViewCell.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/31.
//

import UIKit


protocol ChallengeViewCellDelegate: AnyObject {
    func challengeCellDidTapButton(cell: ChallengeViewCell)
}

class ChallengeViewCell:
    UICollectionViewCell {
    
    weak var delegate: ChallengeViewCellDelegate?
    
    @IBOutlet var container: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var toDoLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var streakLabel: UILabel!
    @IBOutlet var streakView1: UIView!
    @IBOutlet var streakView2: UIView!
    @IBOutlet var streakView3: UIView!
    @IBOutlet var streakView4: UIView!
    @IBOutlet var streakView5: UIView!
    @IBOutlet var streakView6: UIView!
    @IBOutlet var streakView7: UIView!
    @IBOutlet var articleButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //cellにChallengeの内容をセットする
    func setChallengeCell(title: String, toDo: String, startDate:Date, streak:Int) {
        titleLabel.text = title
        toDoLabel.text = toDo
        startDateLabel.text = formatDate(startDate)
        streakLabel.text = String(streak)
    }
    
    // 日付のフォーマットを適用するメソッド
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func updateStreakView(challenge: Challenge) {
        let streak = challenge.streak
        // Uidで紐づいたArticleの日付のみを取得した配列
        let completedDates = challenge.articles.filter({ $0.challengeID == challenge.challengeUID }).map({ $0.date })

        let streakViews = [streakView1, streakView2, streakView3, streakView4, streakView5, streakView6, streakView7]
        let startDate = Calendar.current.startOfDay(for: challenge.startDate)//開始日を日本のタイムに変更
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate) ?? startDate
        let datesInRange = generateDates(from: startDate, to: endDate)
        
        // ストリークのviewの表示色を更新するメソッド
        for (index, view) in streakViews.enumerated() {
            if index < streak {
                //連続日数未達の日付に対応するView
                view?.backgroundColor = UIColor.green
            } else {
                let dateToCheck = Calendar.current.startOfDay(for: datesInRange[index])
                if completedDates.contains(where: { Calendar.current.startOfDay(for: $0) == dateToCheck }) {
                    view?.backgroundColor = UIColor.green // 連続日数の範囲内は緑色に設定
                } else {
                    view?.backgroundColor =  UIColor.lightGray // 連続日数の範囲外はグレー色に設定
                }
            }
        }
    }
    
    //チャレンジ開始日からの一週間の配列を返す
    func generateDates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates = [Date]()
        var currentDate = startDate
        //開始日から終了日までのDateを配列にセット
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    @IBAction func tappedButton() {
        delegate?.challengeCellDidTapButton(cell: self)
        print("tappedButton")
    }
    
}