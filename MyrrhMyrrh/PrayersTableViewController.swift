//
//  PrayersTableViewController.swift
//  MyrrhMyrrh
//
//  Created by Austin McCune on 8/16/18.
//  Copyright © 2018 Austin McCune. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PrayersTableViewController: UITableViewController , UITextFieldDelegate{
    
    @IBOutlet weak var loginLogoutButton: UIBarButtonItem!
    @IBOutlet weak var addPrayerButton: UIBarButtonItem!
    var dbRef:DatabaseReference!
    var prayers = [Prayer]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // gives url to the root of the JSON tree
        dbRef = Database.database().reference().child("prayers")
        
        // populates the cells from ObservingDB
        //startObservingDB()
      
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener({(auth:Auth,user:User?) in
            if let user = user{
            print("Welcome \(user.email)")
             self.login()
                
                
            }else{
                print("you need to sign up or login first")
            }
        })
    }

    @IBAction func loginSignup(_ sender: Any) {
        if(self.loginLogoutButton.title == "Logout"){
          self.logout()
        }else{
        
            let userAlert = UIAlertController(title: "Login/Signup", message: "Enter email and password", preferredStyle: .alert)
            userAlert.addTextField(configurationHandler: {(textField:UITextField) in
                textField.placeholder = "email"
                
            })
            userAlert.addTextField(configurationHandler: {(textField:UITextField) in
                textField.isSecureTextEntry = true
                textField.placeholder = "password"
                
            })
            
            userAlert.addAction(UIAlertAction(title: "Sign in", style: .default, handler: {(action:UIAlertAction) in
                let emailTextField = userAlert.textFields!.first!
                let passwordtextField = userAlert.textFields!.last!
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordtextField.text!, completion: {(user, error) in
                    if error != nil{
                        print(error?.localizedDescription ?? "Error signing in user.")
                    }
                })
                
            }))
            userAlert.addAction(UIAlertAction(title: "Sign up", style: .default, handler: {(action:UIAlertAction) in
                let emailTextField = userAlert.textFields!.first!
                let passwordtextField = userAlert.textFields!.last!
                
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordtextField.text!, completion: {(user,error) in
                    if error != nil{
                        print(error?.localizedDescription ?? "Error creating user.")
                    }
                })
                
            }))
            
            self.present(userAlert, animated: true, completion: nil)
        }
            }
        
    
        

        
        
    
    
    func startObservingDB(){
        dbRef.observe(.value, with: {(snapshot:DataSnapshot) in
            var newPrayers = [Prayer]()
            for prayer in snapshot.children{
                let prayerObject = Prayer(snapshot: prayer as! DataSnapshot)
                newPrayers.append(prayerObject)
            }
            self.prayers = newPrayers
            self.tableView.reloadData()
            
        }){(error:Error) in
            print(error.localizedDescription)
            
        }
    }
    
    func stopObservingDB(){
        dbRef.removeAllObservers()
        self.prayers = []
        self.tableView.reloadData()
    }
    
    func login(){
        
        self.loginLogoutButton.title = "Logout"
        self.addPrayerButton.isEnabled = true
        self.startObservingDB()
    }
    
    func logout(){
        print("Log out here")
        try?Auth.auth().signOut()
        self.loginLogoutButton.title = "Login"
        self.addPrayerButton.isEnabled = false
        self.stopObservingDB()
    }
    

    @IBAction func addPrayer(_ sender: Any) {
        
        
        
//        let prayerAlert = UIAlertController(title: "New Prayer", message: "What should we pray for?", preferredStyle: .alert)
//        prayerAlert.addTextField(configurationHandler: {(textField:UITextField) in
//            textField.placeholder = "Prayer Request..."
//
//
//        })
//        prayerAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: {(action:UIAlertAction) in
//
//            if let prayerContent = prayerAlert.textFields?.first?.text{
//                let user = Auth.auth().currentUser
//                let prayer = Prayer(content: prayerContent, addedByUser: user?.email ?? "Anon")
//                let prayerRef = self.dbRef.child(prayerContent.lowercased())
//
//                prayerRef.setValue(prayer.toAnyObject()){
//                    (error:Error?, dbRef:DatabaseReference) in
//                    if let error = error{
//                        print ("Data could not be saved: \(error).")
//                    }else{
//                        print("Data saved successfully!")
//                    }
//                }
//
//            }
//        }))
//
//        prayerAlert.actions[0].isEnabled = false
//        self.present(prayerAlert, animated: true, completion: nil)
        
  
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return prayers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let prayer = prayers[indexPath.row]
        cell.textLabel?.text = prayer.content
        cell.detailTextLabel?.text = prayer.addedByUser

        return cell
    }
    

    
  

}
