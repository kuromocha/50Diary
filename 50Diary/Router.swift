//
//  Router.swift
//  50Diary
//
//  Created by 嘉山正太郎 on 2021/02/11.
//

import UIKit

class Router{
    static func getIntroductionView(Editingmode: Bool) -> IntroductionViewController{
        let vc =  UIStoryboard(name: "IntroductionView", bundle: nil).instantiateViewController(withIdentifier: "Introduction_View") as! IntroductionViewController
        vc.modalPresentationStyle = .fullScreen
        vc.EditingMode = Editingmode
        return vc
    }

}
