//
//  RoommateViewController.swift
//  Roomie
//
//  Created by Muhaamed Drammeh on 5/18/17.
//  Copyright © 2017 Muhaamed Drammeh. All rights reserved.
//

import UIKit
import Firebase

class RoommateViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let rootRef = Database.database().reference()
    let storageRef = Storage.storage(url: "gs://checkmateios-d1800.appspot.com").reference()
    let sessionManager = SessionManager()
    
    // Array to the users in a group
    var roommate: [Dictionary<String,String>] = []
    //["name":"Mo","email":"nvkf@gmail.com","profileImage":"jklfckedc"],["name":"quan","email":"nvkf@gmail.com","profileImage":"jklfckedc"],["name":"fan","email":"nvkf@gmail.com","profileImage":"jklfckedc"],["name":"victoria","email":"nvkf@gmail.com","profileImage":"jklfckedc"],["name":"sam","email":"nvkf@gmail.com","profileImage":"jklfckedc"]
    
    // Table view to display roommates
    let roommateTableView:UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func constrainRoommateTableView() {
        roommateTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        roommateTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        roommateTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //    // table view setup
    //
    //
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roommate.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //image view for email
        let emailImageView:UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.clear
            imageView.layer.cornerRadius = 5
            //imageView.layer.borderWidth = 1
            //imageView.layer.borderColor = UIColor.white.cgColor
            imageView.contentMode = .scaleAspectFit
            //imageView.image = UIImage(named: "Email.png")
            imageView.image = imageWithImage(image: UIImage(named: "Email.png")!, scaledToSize: CGSize(width: 30, height: 30))
            //imageView.image?.withRenderingMode(.alwaysOriginal)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        let cell = RoommateTableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = roommate[indexPath.row]["name"] ?? ""
        cell.configImage(userID: roommate[indexPath.row]["id"]!)
//        cell.imageView?.image = imageWithImage(image: UIImage(named: "User.png")!, scaledToSize: CGSize(width: 30, height: 30))
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.white.cgColor
        cell.imageView?.layer.cornerRadius = 5
        cell.detailTextLabel?.text = roommate[indexPath.row]["email"] ?? ""
        cell.addSubview(emailImageView)
        // constrain email image view
        
        //emailImageView.heightAnchor.constraint(equalTo: (cell.imageView?.heightAnchor)!).isActive = true
        //emailImageView.widthAnchor.constraint(equalTo: (cell.imageView?.widthAnchor)!).isActive = true
        emailImageView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -10).isActive = true
        emailImageView.centerYAnchor.constraint(equalTo: (cell.centerYAnchor)).isActive = true
        //emailImageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: -5).isActive = true
        
        return cell
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        view.backgroundColor = UIColor(red: 242/255.0, green:206/255.0 , blue: 176/255.0 ,alpha:1)
        // Do any additional setup after loading the view.
        initData()
        view.addSubview(roommateTableView)
        constrainRoommateTableView()
        roommateTableView.tableFooterView = UIView()
        roommateTableView.delegate = self
        roommateTableView.dataSource = self
        self.roommateTableView.backgroundColor = UIColor(red: 201/255.0, green:198/255.0 , blue: 170/255.0 ,alpha:1)

    }
    
    func initData() {
        let groupRef = rootRef.child("groups/\(sessionManager.getUserDetails()["groupName"]!)")
        
        // fetch user data
        groupRef.child("users").observeSingleEvent(of: .value, with: { (snap) in
            if let values = snap.value as? NSDictionary {
                self.roommate.removeAll()
                // ["name":"Mo","email":"nvkf@gmail.com","profileImage":"jklfckedc"]
                for key in values.allKeys{
                    if let value = values[key] as? NSDictionary {
                        let dict = ["name":"\(value["name"]!)","email":"\(value["email"]!)", "id": key as! String]
                        self.roommate.append(dict)
                    }
                }
                self.roommateTableView.reloadData()
            }
            else {
                print("user list is empty!")
                return
            }
        })
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
