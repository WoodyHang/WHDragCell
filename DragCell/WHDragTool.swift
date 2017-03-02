//
//  WHDragTool.swift
//  DragCell
//
//  Created by Woodyhang on 17/2/27.
//  Copyright © 2017年 Woodyhang. All rights reserved.
//

import UIKit

class WHDragTool: NSObject {
    
    var isEditing = false
    
    

    
    static let sharedInstance = WHDragTool()
    
    class func get() -> WHDragTool {
        return sharedInstance
    }
    
    private override init() {}
    
    lazy var subscribeArray:NSMutableArray = {
        let dataArray:NSMutableArray = ["推荐","视频","军事","娱乐","问答","娱乐","汽车","段子","趣图","财经","热点","房产","社会","数码","美女","数码","文化","美文","星座","旅游","视频","军事","娱乐","问答","娱乐","汽车","段子","趣图","财经","热点","房产","社会","数码","美女","数码","文化","美文","星座","旅游"]
        return dataArray
        
    }()

}
