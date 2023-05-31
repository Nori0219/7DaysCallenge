//
//  ArticleViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/23.
//

import UIKit
import RealmSwift

class ArticleViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    // Articleオブジェクトのリストを格納するプロパティ
    //var articles: Results<Article>!
    var articles: [Article] = []
    var topChallenge: Challenge!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var toDoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // RealmからArticleオブジェクトのリストを取得
        //articles = realm.objects(Article.self)
        articles = readArticles()
        navigationItem.title = topChallenge.title
        startDateLabel.text = "開始日：　\(formatDate2(topChallenge.startDate))"
        toDoLabel.text = topChallenge.toDo
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        //カスタムセルの設定
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Tableを更新する
        print("ArticleView wii Apper")
        updateArticleList()
    }
    
    //ChallegeのUIDに対応したArticleの配列を読み込む
    func readArticles() ->  [Article] {
        return Array(realm.objects(Article.self).filter("challengeID == %@", topChallenge.challengeUID).sorted(byKeyPath: "date",ascending: false))
    }
    
    // 記事一覧を更新するメソッド
    func updateArticleList() {
        //articles = realm.objects(Article.self)
        articles = readArticles()
        tableView.reloadData()
        print("ArticleViewTableをリロードしました")
    }
    
    //セルの表示する個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        return articles.count
    }
    //セルの内容を指定するメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        // セルに表示する内容を設定
        if let imageData = article.imageData {
            let image = UIImage(data: imageData)
            cell.setCell(context: article.context, date: formatDate(article.date), image: image)
        } else {
            cell.setCell(context: article.context, date: formatDate(article.date), image: nil)
        }
        //セクション内の行数
        let sectionRowCount = tableView.numberOfRows(inSection: indexPath.section)
        let rowNumber = sectionRowCount - indexPath.row
        //セルに番号を降順になるようにセット
        cell.indexLabel.text = String(rowNumber)
        
        cell.mainBackground.layer.cornerRadius = 20
        cell.mainBackground.layer.masksToBounds = true
        cell.backgroundColor = .systemGray6
        
        return cell
    }
    // 日付のフォーマットを適用するメソッド
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        formatter.dateFormat = "yyyy年MM月dd日(E)"
        return formatter.string(from: date)
    }
    
    func formatDate2(_ date: Date) -> String {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    //セルの高さ　0にすると潰れちゃうイマイチよくわかってない
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    //画面遷移でtopChallengeの値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewArticleView" {
            let newArticleViewController = segue.destination as! NewArticleViewController
            newArticleViewController.topChallenge = self.topChallenge
        }
    }
    
}


//カスタムセルの影の設定
class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    func setupShadow() {
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 0)//影の方向　width、heightを負の値にすると上の方に影が表示される
        self.layer.shadowRadius = 4//影のぼかし
        self.layer.shadowOpacity = 0.3//影の色の透明度
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

