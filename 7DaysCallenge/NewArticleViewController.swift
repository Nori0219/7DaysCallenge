//
//  NewArticleViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/24.
//

import UIKit
import RealmSwift

class NewArticleViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //let realm = try! Realm()
    
    @IBOutlet var contextTextView: UITextView!
    @IBOutlet var articleImageView: UIImageView!
    @IBOutlet var saveButon: UIButton!
    @IBOutlet var AlbumButton: UIButton!
    @IBOutlet var datePicker: UIDatePicker!
    
    // 選択された日付を保持する変数
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIDatePickerの設定
        datePicker.datePickerMode = .date
    }
    
    @IBAction func onTappedAlbumButton() {
        presentPickConroller(sourceType: .photoLibrary)
    }
    
    //カメラ、アルバムの呼び出しメソッド（カメラorアルバムのソースタイプが引数）
    func presentPickConroller(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    //写真が選択された時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        //画像を出力
        articleImageView.image = info[.originalImage] as? UIImage
    }
    
    //    // DateのフォーマットをStringで設定
    //    func updateDateLabel(with date: Date) {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "yyyy/MM/dd"
    //        let dateString = formatter.string(from: date)
    //    }
    
    
    // 保存ボタンがタップされた時の処理
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // 新しいArticleオブジェクトを作成し、入力された内容を設定
        let newArticle = Article()
        newArticle.date = selectedDate
        newArticle.context = contextTextView.text
        newArticle.image = articleImageView.image
        
        // RealmにArticleオブジェクトを保存
        //        try! realm.write {
        //            realm.add(newArticle)
        //        }
        
        // データの保存が完了したら、前の画面に戻るなどの処理を行う
        //前の画面に戻る
        self.dismiss(animated: true)
    }
    
}
