
import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    //    var messages: [Message] = [
    //        Message(sender: "n@gmail.com", body: "Hello!"),
    //        Message(sender: "a@gmail.com", body: "Hey!"),
    //        Message(sender: "s@gmail.com", body: "Whats up?")
    //    ]
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //title
        title = K.flashChat
        //hide button back
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages() // عندما يتم قراءة البيانات بدي احملها في الشاشة
        
    }
    
    
    func loadMessages() {
        
        
        
        //getDocuments استدعاء البيانات مرخ واحده
        //addSnapshotListener استدعاء البيانات في الوقت الغعلي
        //orderBy طلب البيانات بناء على
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            self.messages = []
            if let e = error {
                print("There is error \(e)")
            }else {
                if let snapshotDocument = querySnapshot?.documents {
                    for snapDoc in snapshotDocument {
                        let data = snapDoc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        // اول شي بري اخزن قيمة التيكست فيلد
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                //استخدمنا هان الوقت عشان ارتب الداتا
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { err in
                if let e = err {
                    print("There is error \(e)")
                }else {
                    print("Successfully saved data.")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        
        do{
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            
        }catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        //cell.textLabel?.text = messages[indexPath.row].body
        return cell
    }
    
}
