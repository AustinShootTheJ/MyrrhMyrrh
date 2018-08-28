//
//  PrayerViewController.swift
//  MyrrhMyrrh
//
//  Created by Austin McCune on 8/18/18.
//  Copyright © 2018 Austin McCune. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PrayerViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var prayButton: UIBarButtonItem!
    
    @IBOutlet weak var prayerTextView: UITextView!
    
    var dbRef:DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("prayers")
        // add observers to move prayer view up when keyboard is opened and down when it is closed.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // set placeholder text and border
        prayerTextView.delegate = self
        prayerTextView.layer.borderWidth = 1
        prayerTextView.layer.borderColor = UIColor.black.cgColor
        prayerTextView.text = "What should we pray for?"
        prayerTextView.textColor = UIColor.black
        
   
    }
    
    deinit {
        // clean up listners and remove observers.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }




    @IBAction func cancelPressed(_ sender: Any) {
       
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func prayButtonPressed(_ sender: Any) {
        if let prayerContent = prayerTextView.text{
        let user = Auth.auth().currentUser
        let prayer = Prayer(content: prayerContent, addedByUser: user?.email ?? "Anon")
        let prayerRef = self.dbRef.child(prayerContent.lowercased())
            
        prayerRef.setValue(prayer.toAnyObject()){
        (error:Error?, dbRef:DatabaseReference) in
        if let error = error{
        print ("Data could not be saved: \(error).")
        }else{
            print("Data saved successfully!")
            }
        }
            
       
        self.dismiss(animated: true, completion: nil)
    }
    
}
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y = 0
        }
        
    }

    // functions for placeholder text
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.black {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What should we pray for?"
            textView.textColor = UIColor.black
        }
    }

    
}
