//
//  PostViewController.swift
//  50Diary
//
//  Created by 嘉山正太郎 on 2020/09/27.
//

import UIKit
import RealmSwift
import MBCircularProgressBar

class PostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var wordCountLabel: UILabel!

    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    fileprivate var maxWordCount:Int = 50
    var selectedReportId = 0
    var isEditMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.tintColor = UIColor.white
        doneButton.style = .done
        
        if isEditMode {
            doneButton.title = "編集"
            title = "編集"
            let realm = try! Realm()
            let object = realm.objects(RealReport.self).filter("id = \(selectedReportId)").first!
            postTextView.text = object.postText
            datePicker.date = object.createdAt
        }else{
            doneButton.title = "保存"
            title = "新規作成"
        }
        postTextView.delegate = self
        postTextView.layer.cornerRadius = 12
        postTextView.clipsToBounds = true
        postTextView.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            progressView.value = CGFloat(postTextView.text.count)
            progressView.maxValue = CGFloat(maxWordCount)
        }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
        UIView.animate(withDuration: 0.1, delay: 0.0) {
                self.progressView.value = CGFloat(self.postTextView.text.count)
            }
        }
    
    
    @objc func dismissKeyboard() {
            self.view.endEditing(true)
        }
    
    //分岐50字超えてるときと超えてないとき
    @IBAction func postRepost(_ sender: Any) {
        let realm = try! Realm()
        let calendar = Calendar(identifier: .gregorian)
        let isContainSameDay = !realm.objects(RealReport.self)
            .filter{ calendar.isDate(self.datePicker.date, inSameDayAs: $0.createdAt) }
            .isEmpty
        
        // 文字数エラ-チェック
        if postTextView.text.count > maxWordCount{
            overAlert()
            return
        }
        //同日判定
        if isContainSameDay {
            showSameDayErrorAlert()
        }else{
            choiceSaveEdit()
        }
        
    }
    //新しいデータをセーブする
    private func save() {
        let realm = try! Realm()
        let savedata = RealReport()
//        print(datePicker.date)
        savedata.setNewId()
        savedata.createdAt = datePicker.date
        savedata.postText = postTextView.text!
        try! realm.write {
            realm.add(savedata, update: .modified)
        }
    }
    
    //以前のデータを編集する
    private func edit(){
//        realm()はできたてほやほやのコピー品
        let realm = try! Realm()
        let savedata = RealReport()
        savedata.id = selectedReportId
        savedata.createdAt = datePicker.date
        savedata.postText = postTextView.text!
        try! realm.write {
            realm.add(savedata, update: .modified)
        }
    }
    
    // 文字数カウンターと50文字超えたら警告
    internal func textViewDidChange(_ textView: UITextView) {
//        self.wordCountLabel.text = "\(postTextView.text.count) / \(maxWordCount)"
        UIView.animate(withDuration: 1.0) {
            self.progressView.value = CGFloat(self.postTextView.text.count)
        }
        if postTextView.text.count > maxWordCount{
            wordCountLabel.text = "\(maxWordCount - postTextView.text.count)"
            wordCountLabel.textColor = UIColor.red
            self.progressView.progressColor = UIColor.red
        }else{
            if maxWordCount - postTextView.text.count <= 10{
                wordCountLabel.text = "\(maxWordCount - postTextView.text.count)"
                wordCountLabel.textColor = UIColor.orange
                self.progressView.progressColor = UIColor.orange
                }else{
                    wordCountLabel.text = ""
                    self.progressView.progressColor = UIColor(red: 56/255, green: 117/255, blue: 239/255, alpha: 1.0)
                }
        }
    }
    //50字超えてたときのアラート
    private func overAlert(){
        let dialog = UIAlertController(title: "文字数オーバー", message: "50文字を超えて入力しています。50文字に収まるように修正をしてください。", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "理解", style: .default, handler: nil))
        self.present(dialog, animated: true, completion: nil)
    }
    
    //同日判定アラート
    private func showSameDayErrorAlert() {
            let alert = UIAlertController(title: "日付が被っています", message: "はいを選ぶと同じ日付の記録が消えて、この記録が保存されます", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "はい", style: .default, handler: { (UIAlertAction) in
//                print("「はい」が選択されました！")
//                var selectedReportId = reports
                self.choiceSaveEdit()
            })
            let noAction = UIAlertAction(title: "いいえ", style: .default, handler: { (UIAlertAction) in
//                print("「いいえ」が選択されました！")
            })
        
            alert.addAction(noAction)
            alert.addAction(yesAction)
            
            present(alert, animated: true, completion: nil)
        }
    
    private func choiceSaveEdit(){
        if isEditMode {
            edit()
        }else{
            save()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

