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
    //親チャレンジ
    var topChallenge: Challenge!
    
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
        //DatePicerで選択した日付を代入
        selectedDate = datePicker.date
        print("selectedDate: \(selectedDate)")
        // 新しいArticleオブジェクトを作成し、入力された内容を設定
        let newArticle = Article()
        newArticle.challengeID = topChallenge.challengeUID
        newArticle.date = selectedDate
        newArticle.context = contextTextView.text
        // 画像データをData型に変換して保存
        if let image = articleImageView.image {
            //newArticle.imageData = image.pngData()
            // 画像の圧縮率を下げる（例: 0.8）
            let compressedImage = image.jpegData(compressionQuality: 0.2)
            newArticle.imageData = compressedImage
        }
        
        if contextTextView.text.isEmpty {
            displayAlertWhenNotInput()
        } else {
            print("newArticleをRealmへ保存可能です")
            print("newArticle: \(newArticle)")
            //Realmに保存
            createArticle(article: newArticle)
            //streakを計算して更新
            calculateAndSaveStreak(challenge: topChallenge)
            //前の画面に戻る
            self.dismiss(animated: true)
        }
    }
    
    //articleをRealmに追加するメソッド
    func createArticle(article: Article) {
        try! realm.write {
            realm.add(article)
        }
        print("RealmにArticleを追加しました")
        reloadTable()
    }
    
    func reloadTable() {
        //遷移先画面が閉じる直前のタイミングで、遷移元画面のViewWillAppear()を呼び出すつまり、tableをリロードできる
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: true)
        }
        print("アナログでリロード")
    }
    
    func calculateAndSaveStreak(challenge: Challenge) {
        //ChallegeのUIDに対応したArticle
        let sortedArticles =  realm.objects(Article.self)
            .filter(NSPredicate(format: "challengeID == %@", challenge.challengeUID))
            .sorted(byKeyPath: "date")
        
        var streakCount = 0
        
        print("sortedArticles: \(sortedArticles)")
        
        var startDate = Date()
        // 最初の記事の日付を取得して、startDateに設定
        if let firstArticle = sortedArticles.first {
            startDate = Calendar.current.startOfDay(for: firstArticle.date)
        } else {
            // 記事が存在しない場合は、処理を中断して関数を終了
            return
        }
        
        var currentDate = startDate
        
        for article in sortedArticles {
            let articleDate = Calendar.current.startOfDay(for: article.date)
            
            print("articleDate: \(articleDate)")
            print("currentDate: \(currentDate)")
            print("---------")
            if articleDate == currentDate {
                // 記事の日付が現在の日付と一致している場合
                streakCount += 1
                // 現在の日付を1日進める
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                print("streakCout増加：streakCout: \(streakCount)")
            } else {
                // 記事の日付が現在の日付と一致しない場合、ループを終了
                break
            }
        }
        
        try! realm.write {
            challenge.streak = streakCount
        }
        print("RealmにChellenge.streakを追加しました")
    }
    //toDo Articleのcontextとimageが未入力だとアラートを表示
    func displayAlertWhenNotInput() {
        //alertを作成
        let alert = UIAlertController(
            title: "未入力の項目があります",
            message: "記録を入力してください",
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
