
import UIKit

extension Date{
    // 表示用の文字列に変換する関数
    func toDisplayString() -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: self)
    }
    
    var calendar: Calendar {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = .current
            calendar.locale   = .current
            return calendar
        }
        
}
