import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ToDoを格納する配列
    var todoList = [Todo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // 編集ボタン
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 編集モード時にセルを選択可能にする
        tableView.allowsSelectionDuringEditing = true
        
        // 保存したToDoの取得
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.object(forKey: "todoList") as? Data {
            do {
                if let unarchivedData = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Todo.self], from: data) as? [Todo] {
                    // 配列に反映
                    todoList.append(contentsOf: unarchivedData)
                }
            } catch {
            }
        }
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
                
                // Todoクラスのオブジェクト
                let todo = Todo()
                todo.todoTitle = textField.text!
                // 配列の先頭に挿入
                self.todoList.insert(todo, at: 0)
                
                // テーブルに行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                
                // 保存
                self.storeTodoListData()
            }
        }
        alertController.addAction(okAction)
        
        // キャンセルボタン
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
    }
    
    // 編集ボタンをタップした時の処理
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        // セルを編集モードにする
        if tableView.isEditing {
            tableView.isEditing = false
            editButton.title = "Edit"
        } else {
            tableView.isEditing = true
            editButton.title = "Done"
        }
    }
    
    // Todoリストデータの保存
    func storeTodoListData() {
        // 保存
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.todoList, requiringSecureCoding: true)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        } catch {
            // エラー処理なし
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 識別子を利用して再利用可能なセルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        // ラベルにタイトルをセット
        let todo = todoList[indexPath.row]
        cell.textLabel?.text = todo.todoTitle
        
        // チェックマーク
        if todo.todoDone {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    // セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 編集モードのとき
        if tableView.isEditing {
            // タイトルの変更
            let editAlert = UIAlertController(title: "ToDo編集", message: nil, preferredStyle: UIAlertController.Style.alert)
            editAlert.addTextField { (textField: UITextField) in
                // 編集前のタイトル
                textField.text = self.todoList[indexPath.row].todoTitle
            }
            // OKボタン
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
                guard let textField = editAlert.textFields?.first else {
                    // フィールドに文字がない
                    return
                }
                if textField.text == self.todoList[indexPath.row].todoTitle {
                    // 変更なし
                    return
                }
                self.todoList[indexPath.row].todoTitle = textField.text!
                // セルの状態を変更
                tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                // 保存
                self.storeTodoListData()
            }
            editAlert.addAction(okAction)
            present(editAlert, animated: true, completion: nil)
            
        } else {
            // チェックマーク
            let todo = todoList[indexPath.row]
            if todo.todoDone {
                todo.todoDone = false
            } else {
                todo.todoDone = true
            }
            // セルの状態を変更
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            // 保存
            storeTodoListData()
        }
    }
    
    // セルが編集可能かどうか設定する
    // falseにした場合はeditingStyleプロパティを無視する
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // セルを移動可能にする
    // tableView moveRowAtメソッドを実装している場合は、デフォルトでtrueになる
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // データソースに指定のセルの挿入や削除を要求する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除処理かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete {
            // 配列から削除
            todoList.remove(at: indexPath.row)
            // セルの削除
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            // 保存
            storeTodoListData()
        }
    }
    
    /*
    // 指定のセルの編集スタイルを設定する (none, delete, insert)
    // セルが編集可能で、このメソッドが実装されていない場合は、EditingStyle.deleteが設定されている
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // セルに対して編集操作したくない場合は、noneにする
        return UITableViewCell.EditingStyle.none
    }
    */
    
    // セルを移動させた後の処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // リスト内の並べ替え
        let todo = todoList[sourceIndexPath.row]
        todoList.remove(at: sourceIndexPath.row)
        todoList.insert(todo, at: destinationIndexPath.row)
        // 保存
        storeTodoListData()
    }
}

