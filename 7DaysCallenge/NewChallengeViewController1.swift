//
//  NewArticleViewController1.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/06/06.
//

import UIKit

class NewChallengeViewController1: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var exampleLabel1: UILabel!
    @IBOutlet var exampleLabel2: UILabel!
    @IBOutlet var exampleLabel3: UILabel!
    @IBOutlet var exampleLabel4: UILabel!
    @IBOutlet var shuffleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TabBarを非表示
        self.tabBarController?.tabBar.isHidden = true
        //NavigationBarの＜Backを非表示にする　参考：https://spinners.work/posts/ios14_blank_back_button/
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = " "
        }
        
    }
    
    //入力画面ないしkeyboardの外を押したら、キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.titleTextField.isFirstResponder) {
            self.titleTextField.resignFirstResponder()
        }
    }
    
    @IBAction func tappedNextButton() {
        if titleTextField.text?.isEmpty ?? true {
            //アラートを表示する
            displayAlertWhenNotInput()
        }
        print("NewChallengeTitle: \(String(describing: titleTextField.text))")
        // 画面遷移の処理を実装する
        performSegue(withIdentifier: "toNewChallengeView2", sender: nil)
    }
    
    //Titleが未入力だとアラートが表示されるようにする
    func displayAlertWhenNotInput() {
        //alertを作成
        let alert = UIAlertController(
            title: "未入力の項目があります",
            message: "タイトルを入力してください",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        ))
        present(alert, animated: true, completion: nil)
    }
    
    //画面遷移Titleを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewChallengeView2" {
            let newChallengeViewController2 = segue.destination as! NewChallengeViewController2
            newChallengeViewController2.presentationController?.delegate = self
            newChallengeViewController2.ChallengeTitle = self.titleTextField.text!
        }
    }

}






