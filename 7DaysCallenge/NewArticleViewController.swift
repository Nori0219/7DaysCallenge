//
//  NewArticleViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/24.
//

import UIKit
import RealmSwift

class NewArticleViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let realm = try! Realm()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //遷移先画面が閉じる直前のタイミングで、遷移元画面のViewWillAppear()を呼び出すつまり、tableをリロードできる
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
        }
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
    
    
    // 保存ボタンがタップされた時の処理
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // 新しいArticleオブジェクトを作成し、入力された内容を設定
        let newArticle = Article()
        newArticle.date = selectedDate
        newArticle.context = contextTextView.text
        // 画像データをData型に変換して保存
        if let image = articleImageView.image {
            //newArticle.imageData = image.pngData()
            // 画像の圧縮率を下げる（例: 0.8）
            let compressedImage = image.jpegData(compressionQuality: 0.2)
            newArticle.imageData = compressedImage
        }
        //Realmに保存
        createArticle(article: newArticle)
        //前の画面に戻る
        self.dismiss(animated: true)
    }
    
    //articleをRealmに追加するメソッド
    func createArticle(article: Article) {
        try! realm.write {
            realm.add(article)
        }
        print("RealmにArticleを追加しました")
    }
    //toDo Articleのcontextとimageが未入力だとアラートが表示されるようにする
    
}
