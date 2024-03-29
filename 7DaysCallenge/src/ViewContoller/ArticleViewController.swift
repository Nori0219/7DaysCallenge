//
//  ArticleViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/23.
//

import UIKit
import RealmSwift
import GoogleMobileAds

//class ArticleViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
class ArticleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAdaptivePresentationControllerDelegate{
   
    
    
    let realm = try! Realm()
    // Articleオブジェクトのリストを格納するプロパティ
    var articles: [Article] = []
    var topChallenge: Challenge!
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var toDoLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //テスト用のバナー広告ID
    //let adBannerID = "ca-app-pub-3940256099942544/2934735716"
    //本番用のバナー広告ID
    let adBannerID = "ca-app-pub-2758102039369928/1406452290"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TabBarを非表示
        self.tabBarController?.tabBar.isHidden = true
        
        // RealmからArticleオブジェクトのリストを取得
        articles = readArticles() ?? []
        //TopChallegneが存在しない場合に備える
        if let topChallenge = topChallenge {
            navigationItem.title = topChallenge.title
            startDateLabel.text = "開始日：\(formatDate(topChallenge.startDate))"
            toDoLabel.text = topChallenge.toDo
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        //カスタムセルの設定
        collectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCell")
        
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = adBannerID
        bannerView.rootViewController = self
        
        // 広告読み込み
        bannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //ChallegeのUIDに対応したArticleの配列を読み込む
    func readArticles() -> [Article]? {
        guard let challengeUID = topChallenge?.challengeUID else {
            return nil
        }
        return Array(realm.objects(Article.self).filter("challengeID == %@", challengeUID).sorted(byKeyPath: "date",ascending: false))
    }
    
    // 記事一覧を更新するメソッド
    func updateArticleList() {
        //articles = realm.objects(Article.self)
        articles = readArticles() ?? []
        collectionView.reloadData()
        print("ArticleViewTableをリロードしました")
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("モーダルが閉じられたことを検知しました！")
        updateArticleList()
    }
    
    // セルの表示する個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    // セルの内容を指定するメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCollectionViewCell
        
        let article = articles[indexPath.item]
        // セルに表示する内容を設定
        if let imageData = article.imageData {
            let image = UIImage(data: imageData)
            cell.setArticleCell(context: article.context, date: formatDate(article.date), image: image)
        } else {
            cell.setArticleCell(context: article.context, date: formatDate(article.date), image: nil)
        }
        // セルに番号を降順になるようにセット
        cell.indexLabel.text = String(articles.count - indexPath.item)
        
        
        return cell
    }
    
    // セルが選択された時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // セルのImageViewをタップしたかどうかを判定
//                //let cell = collectionView.cellForItem(at: indexPath) as? ArticleCollectionViewCell
//                if let tapGesture = cell?.imageViewTapGesture, tapGesture.state == .ended {
//
//                } else {
//                    // セルのImageView以外をタップしていた場合の処理（必要ならここに記述）
//                    print("セルのImageView以外をタップしていた場合")
//                }
    }
    
    // 日付のフォーマットを適用するメソッド
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日(E)"
        return formatter.string(from: date)
    }
    
    
    //画面遷移でtopChallengeの値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewArticleView" {
            let newArticleViewController = segue.destination as! NewArticleViewController
            newArticleViewController.presentationController?.delegate = self
            newArticleViewController.topChallenge = self.topChallenge
        }
    }
    
    //**************************************************
    // UICollectionViewDelegateFlowLayout
    //**************************************************
    
    // UICollectionViewの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    //Cellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 240)
    }
    
    
    // 行の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    // 列の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
