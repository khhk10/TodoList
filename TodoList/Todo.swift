import Foundation

class Todo: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    // ToDoのタイトル
    var todoTitle: String?
    // ToDoを完了したかどうか
    var todoDone: Bool = false
    
    // コンストラクタ
    override init() {
    }
    
    // エンコード（NSCodingのメソッド）
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
    
    // デコード（NSCodingのメソッド）
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
}
