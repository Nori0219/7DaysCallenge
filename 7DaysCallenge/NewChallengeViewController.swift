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
        
    }
    

    func addButtonTapped() {
        let newChallenge = Challenge()
        newChallenge.title = titleTextField.text!
        newChallenge.toDo = toDoTextField.text!
        newChallenge.doNotification = notificationSwich.isOn
        newChallenge.notificationTime = notificarionDatePicker.date
        newChallenge.startDate = inputedDate
        
        createChallenge(charenge: newChallenge)
        
        //前の画面に戻る
        self.dismiss(animated: true)
        
    }
    
    
    func createChallenge(charenge: Challenge) {
        try! realm.write {
            realm.add(charenge)
        }
        print("RealmにChellengeを追加しました")
    }
    //toDo ChallengeのTitleとtoDoが未入力だとアラートが表示されるようにする
}
