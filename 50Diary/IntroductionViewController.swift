//
//  IntroductionViewController.swift
//  50Diary
//
//  Created by 嘉山正太郎 on 2021/02/11.
//

import UIKit

class IntroductionViewController: UIViewController {

    
    @IBOutlet weak var startImage: UIImageView!
    @IBOutlet weak var diaryImage: UIImageView!
    
    var EditingMode: Bool!
    
    var img1 = UIImage(named:"IntroImage")
    var img2 = UIImage(named:"DiaryImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startImage.image = img1
        diaryImage.image = img2
     
    }
    
    @IBAction func introductionDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
