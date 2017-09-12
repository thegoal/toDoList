//
//  FirstViewController.swift
//  ToDoList
//
//  Created by Ishaq Shafiq on 11/09/2017.
//  Copyright © 2017 Ishaq Shafiq. All rights reserved.
//

import UIKit

class PendingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewTaskViewDelegate {

    // Table contains pending tasks list
    @IBOutlet weak var pendingTable: UITableView!
    
    // Label wil shown when there is no pending task list
    @IBOutlet weak var noTaskLabel: UILabel!
    
    // Contains all pending task
    var pendingTaskArray: [ToDoTask] = []

    // View wil shown when there user click +
    var viewNewTask: NewTaskView!
    
    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    
     // MARK: ViewController FLow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.pendingTable?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        pendingTable.register(UINib(nibName: "PendingTableCell", bundle: Bundle.main), forCellReuseIdentifier: "pendingTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.loadPendingTasks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    
    func loadPendingTasks(){
        pendingTaskArray = CoreDataManager.sharedInstance.getTaskForTab(pending: false)
        if self.pendingTaskArray.count == 0 {
            self.showNoPendingTaskLabel()
        }else{
            self.pendingTable?.isHidden = false
            self.noTaskLabel?.isHidden = true
            self.pendingTable.reloadData()
        }
    }
    
    func showNoPendingTaskLabel(){
        self.pendingTable?.isHidden = true
        self.noTaskLabel?.isHidden = false
    }
    
    // MARK: IBActions
    
    @IBAction func creatTaskClicked(_ sender: AnyObject){
        
//         We can use UIAlertView controler too , But i used this because in case of error user would have to tap again to show alert   
        
        if (viewNewTask == nil) {
            viewNewTask = NewTaskView.init(frame: CGRect (x:0 , y:0 ,width:self.view.frame.size.width,height:self.view.frame.size.height))
            viewNewTask.delegate = self
            AppSupport.addAnimation(toView: viewNewTask, withDuration: 0.5)
            let window = UIApplication.shared.keyWindow!
            window.addSubview(self.viewNewTask)
        }
    }
    
    // MARK: UITableView Delegates and DataSource
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingTaskArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "pendingTableCell",
            for: indexPath) as! PendingTableCell
        let pendingTask = self.pendingTaskArray[indexPath.row]
        cell.taskName.text = pendingTask.taskName

        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = pendingTaskArray[indexPath.row]
        task.taskDone = true
        CoreDataManager.sharedInstance.saveTask()
        pendingTaskArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        if self.pendingTaskArray.count == 0 {
            self.showNoPendingTaskLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = pendingTaskArray[indexPath.row]
            context.delete(task)
            CoreDataManager.sharedInstance.saveTask()
            self.pendingTaskArray.remove(at:indexPath.row)
            if self.pendingTaskArray.count == 0 {
                self.showNoPendingTaskLabel()
            }else{
                tableView.reloadData()
            }
        }
    }
    
    // MARK: NewTaskView Delegates
    
    func newTaskViewCancelPressed(sender: NewTaskView) {
        self.viewNewTask.removeFromSuperview()
        self.viewNewTask = nil
    }
    
    func newTaskViewDonePressed(sender: NewTaskView){
        AppSupport.addAnimation(toView: viewNewTask, withDuration: 0.5)
        self.viewNewTask.removeFromSuperview()
        self.viewNewTask = nil
        self.loadPendingTasks()
    }
}

