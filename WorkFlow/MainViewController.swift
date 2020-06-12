//
//  MainViewController.swift
//  WorkFlow
//
//  Created by PND_HCMUS on 6/12/20.
//  Copyright © 2020 PND_HCMUS. All rights reserved.
//

import UIKit
import CoreData

class task: NSObject, NSCoding {
    let projectName: String
    let content: String
    let priority: Int
    
    init(projectName: String, content: String, priority: Int) {
        self.projectName = projectName
        self.content = content
        self.priority = priority

    }

    required convenience init(coder aDecoder: NSCoder) {
        let projectName = aDecoder.decodeInteger(forKey: "projectName" as! String)
        let content = aDecoder.decodeObject(forKey: "content") as! String
        let priority = aDecoder.decodeObject(forKey: "priority") as! Int
        self.init(projectName: projectName, content: content, priority: priority)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(shortname, forKey: "shortname")
    }
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var listTaskTableView: UITableView!
    @IBOutlet weak var sortProjectButton: UIButton!
    @IBOutlet weak var sortPriorityButton: UIButton!
    @IBOutlet weak var addTaskButton: UIButton!
    
    var taskArr:[task] = [task.init(projectName: "A", content: "test1", priority: 2),
                          task.init(projectName: "C", content: "test2", priority: 1),
                          task.init(projectName: "B", content: "test3", priority: 3),
                          task.init(projectName: "A", content: "test5", priority: 1)]
    
    var sortProject = false
    var sortPriority = false
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.listTaskTableView.separatorColor = UIColor.clear
        self.listTaskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "taskTableCell")
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: taskArr)
        userDefaults.set(encodedData, forKey: "taskArr")
        userDefaults.synchronize()
    }

    @IBAction func addTaskBtn(_ sender: Any) {
        
//        let detailVC = DetailTaskViewController()
//        present(detailVC, animated: true)
        let newTask: task = task.init(projectName: "new", content: "test8", priority: 3)
        taskArr.append(newTask)
        print(encodedData)
        
//        listTaskTableView.reloadData()
    }
    
    // Sort task array follow project name
    @IBAction func sortProjectBtn(_ sender: Any) {
        if sortProject {
            self.taskArr = self.taskArr.sorted(by: {
                $0.projectName > $1.projectName
            })
        } else {
            self.taskArr = self.taskArr.sorted(by: {
                $0.projectName < $1.projectName
            })
        }

        DispatchQueue.main.async {
            self.listTaskTableView.reloadData();
        }
        sortProject = !sortProject
    }
    
    // Sort task array follow priority level
    @IBAction func sortPriorityBtn(_ sender: Any) {
        if sortPriority {
            self.taskArr = self.taskArr.sorted(by: {
                $0.priority > $1.priority
            })
        } else {
            self.taskArr = self.taskArr.sorted(by: {
                $0.priority < $1.priority
            })
        }

        DispatchQueue.main.async {
            self.listTaskTableView.reloadData();
        }
        sortPriority = !sortPriority
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskTableCell", for: indexPath) as! TaskTableViewCell
        cell.projectNameLabel.text = taskArr[indexPath.row].projectName
        cell.taskDescriptionLabel.text = taskArr[indexPath.row].content
        cell.priorityLevelLabel.text = String(taskArr[indexPath.row].priority)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailTaskViewController()
        present(detailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskArr.remove(at: indexPath.row)
        
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height / 12
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArr.count
    }
}
