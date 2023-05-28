//
//  NewChallengeViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/21.
//

import UIKit
import RealmSwift

class NewChallengeViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet var toDoTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var notificationLabel: UILabel!
    @IBOutlet var notificationSwich: UISwitch!
    @IBOutlet var notificarionDatePicker: UIDatePicker!
    @IBOutlet var addChallengeButton: UIButton!
    
    //challengeを入力した日付 == StartDate
    var inputedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("inputDate: \(inputedDate)")
        //NavigationBarの＜Backを非表示にする　参考：https://spinners.work/posts/ios14_blank_back_button/
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = " "
        }
        
    }
    
    
    @IBAction func addButtonTapped() {
        let newChallenge = Challenge()
        newChallenge.title = titleTextField.text!
        newChallenge.toDo = toDoTextField.text!
        newChallenge.doNotification = notificationSwich.isOn
        newChallenge.notificationTime = notificarionDatePicker.date
        newChallenge.startDate = inputedDate
        
        if titleTextField.text?.isEmpty ?? true || toDoTextField.text?.isEmpty ?? true{
            displayAlertWhenNotInput()
        } else{
            print("newChallengeをRealmへ保存可能です")
            print("newChallenge: \(newChallenge)")
            //Realmにデータを保存する
            createChallenge(charenge: newChallenge)
            //前の画面に戻る
            print("前の画面に戻る！")
            //self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
             
        }
        
    }
    
    
    func createChallenge(charenge: Challenge) {
        try! realm.write {
            realm.add(charenge)
        }
        print("RealmにChellengeを追加しました")
    }
    
    //toDo ChallengeのTitleとtoDoが未入力だとアラートが表示されるようにする
    func displayAlertWhenNotInput() {
        //alertを作成
        let alert = UIAlertController(
            title: "未入力の項目があります",
            message: "全ての項目を入力してください",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        ))
        present(alert, animated: true, completion: nil)
    }
}
