import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ToDoを格納する配列
    var todoList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 追加ボタンをタップした時の処理
    @IBAction func tapAddButton(_ sender: Any) {
        // アラートダイアログ
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してください", preferredStyle: UIAlertController.Style.alert)
        
        // テキストエリア追加
        alertController.addTextField(configurationHandler: nil)
        
        // OKボタン
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            // タップされたときの処理
            if let textField = alertController.textFields?.first {
                // 配列の先頭に挿入
                self.todoList.insert(textField.text!, at: 0)
                // テーブルに行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            }
        }
        alertController.addAction(okAction)
        
        // キャンセルボタン
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 識別子を利用して再利用可能なセルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        // ラベルにタイトルをセット
        let todoTitle = todoList[indexPath.row]
        cell.textLabel?.text = todoTitle
        return cell
    }
    

}

