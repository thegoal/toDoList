//
//  SecondViewController.swift
//  ToDoList
//
//  Created by Ishaq Shafiq on 11/09/2017.
//  Copyright © 2017 Ishaq Shafiq. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    // Table contains pending tasks list
    @IBOutlet weak var doneTable: UITableView!
    
    // Label wil shown when there is no pending task list
    @IBOutlet weak var noTaskLabel: UILabel!
    
    // Contains all pending task
    var doneTaskArray : [ToDoTask] = []
    
    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    
    // MARK: ViewController FLow

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.doneTable?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        doneTable.register(UINib(nibName: "DoneTableCell", bundle: Bundle.main), forCellReuseIdentifier: "doneTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.loadDoneTasks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Methods
    
    func loadDoneTasks(){
        doneTaskArray = CoreDataManager.sharedInstance.getTaskForTab(pending: true)
        if self.doneTaskArray.count == 0 {
            self.showNoDoneTaskLabel()
        }else{
            self.doneTable?.isHidden = false
            self.noTaskLabel?.isHidden = true
            self.doneTable.reloadData()
        }
    }
    
    func showNoDoneTaskLabel(){
        self.doneTable?.isHidden = true
        self.noTaskLabel?.isHidden = false
    }
    
    // MARK: UITableView Delegates and DataSource
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doneTaskArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // We can use same cell for completed task too but in future if there is differnt design than changeings can be tough in big proejct 
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "doneTableCell",
            for: indexPath) as! DoneTableCell
        let doneTask = self.doneTaskArray[indexPath.row]
        cell.taskName.text = doneTask.taskName
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = doneTaskArray[indexPath.row]
        task.taskDone = false
        CoreDataManager.sharedInstance.saveTask()
        doneTaskArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        if self.doneTaskArray.count == 0 {
            self.showNoDoneTaskLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = doneTaskArray[indexPath.row]
            context.delete(task)
            CoreDataManager.sharedInstance.saveTask()
            self.doneTaskArray.remove(at:indexPath.row)
            if self.doneTaskArray.count == 0 {
                self.showNoDoneTaskLabel()
            }else{
                tableView.reloadData()
            }
        }
    }
}

