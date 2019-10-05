//
//  NewTaskView.swift
//  ToDoList
//
//  Created by Ishaq Shafiq on 11/09/2017.
//  Copyright © 2017 Ishaq Shafiq. All rights reserved.
//

import UIKit

protocol NewTaskViewDelegate: class {
    func newTaskViewCancelPressed(sender: NewTaskView)
    func newTaskViewDonePressed(sender: NewTaskView)
}


class NewTaskView: UIView {

    weak var delegate:NewTaskViewDelegate?
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtTaskName: UITextField!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.txtTaskName.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // Performs the initial setup.
    fileprivate func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    fileprivate func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // MARK: IBActions
    
    @IBAction func doneClicked(_ sender: UIButton) {
        
        if self.txtTaskName.text?.count == 0{
            self.lblError.isHidden = false
            return
        }
        
        CoreDataManager.sharedInstance.addTask(name:self.txtTaskName.text!)
        delegate?.newTaskViewDonePressed(sender: self)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        delegate?.newTaskViewCancelPressed(sender: self)
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
