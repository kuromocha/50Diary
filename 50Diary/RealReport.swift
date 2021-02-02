//
//  RealReport.swift
//  50Diary
//
//  Created by 嘉山正太郎 on 2020/11/20.
//

import UIKit
import RealmSwift

class RealReport: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var createdAt = Date()
    @objc dynamic var postText = ""
    
    func setNewId() {
        let realm = try! Realm()
        self.id = (realm.objects(type(of: self).self).sorted(byKeyPath: "id", ascending: false).first?.id ?? 0) + 1
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
