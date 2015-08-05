//
//  ViewController.swift
//  DishUpApp
//
//  Created by James White on 7/16/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

