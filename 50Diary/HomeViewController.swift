//
//  HomeViewController.swift
//  50Diary
//
//  Created by 嘉山正太郎 on 2020/09/27.
//

import UIKit
import RealmSwift
import MBCircularProgressBar

class HomeViewController: UIViewController,
                          UITableViewDataSource, UITableViewDelegate {
 
    private var posts:Results<RealReport>? = nil
    
    @IBOutlet weak var postTableView: UITableView!
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.dataSource = self
        postTableView.delegate = self
        let realm = try! Realm()
        posts = realm.objects(RealReport.self)
        
        createButton.style = .done
    }
    

    
    //ViewControllerが開いた時にデータを更新する
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        posts = realm.objects(RealReport.self)
        // reloadDate()は、tableviewに対してデータが新しくなったから更新しろの意
        postTableView.reloadData()
    }
    
    func tableView(_ table: UITableView,
                  numberOfRowsInSection section: Int) -> Int {
        // countが0
        return posts?.count ?? 0
   }
    
    func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    }
    
    //記録データのセルを配置する
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //日付に昇順
        let realm = try! Realm()
        posts = realm.objects(RealReport.self).sorted(byKeyPath: "createdAt", ascending: false)
        let cell = table.dequeueReusableCell(withIdentifier: "postCell",for: indexPath) as! PostTableViewCell
        if posts != nil{
            let post = posts![indexPath.row]
            let f = DateFormatter()
            f.dateFormat = "MM/dd"
            let dateData = post.createdAt
            cell.postedLabel.text = post.postText
            cell.dayLabel.text = "\(f.string(from: dateData))"
        }
        cell.backgroundColor = .clear
        return cell
    }
    //セルを消す処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let realm = try! Realm()
            try! realm.write {
                realm.delete(posts![indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //セルタップして編集に飛ばす処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        secondViewController.selectedReportId = posts![indexPath.row].id
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    @IBAction func newPost(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        secondViewController.isEditMode = false
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
}
