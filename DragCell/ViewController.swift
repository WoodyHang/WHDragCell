//
//  ViewController.swift
//  DragCell
//
//  Created by Woodyhang on 17/2/27.
//  Copyright © 2017年 Woodyhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dragView = WHDragView(frame: self.view.bounds)
        self.view.addSubview(dragView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

