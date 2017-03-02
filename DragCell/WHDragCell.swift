//
//  WHDragCell.swift
//  DragCell
//
//  Created by Woodyhang on 17/2/28.
//  Copyright © 2017年 Woodyhang. All rights reserved.
//

import UIKit

protocol WHDragDelegate {
    
    func WHDragCellGestureAction(gesture:UIGestureRecognizer)
    
    func WHDragCellCancelTheme(themeCell:WHDragCell)
    
}

class WHDragCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate:WHDragDelegate!
    
    
    var isEditing:Bool = true{
        didSet {
            if isEditing{
                self.deleteButton.isHidden = false
            }else {
                self.deleteButton.isHidden = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.label.layer.borderWidth = 1
        
        setUp()
    }
    
    @IBAction func deleteCell(_ sender: UIButton) {
        
        self.delegate.WHDragCellCancelTheme(themeCell: self)
    }
    
    func setUp(){
        
        //给cell添加一个长按手势
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(WHDragCell.clicked))
        //创建一个拖动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(WHDragCell.clicked))
        self.addGestureRecognizer(longGesture)
        self.addGestureRecognizer(panGesture)
        
        longGesture.delegate = self
        panGesture.delegate = self
        
        
        
    }
    
    func clicked(sender:UIGestureRecognizer){
        
        self.delegate.WHDragCellGestureAction(gesture: sender)
    }
    
}

extension WHDragCell:UIGestureRecognizerDelegate{
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self){
            if WHDragTool.get().isEditing {
                return false
            }else {
                return true
            }
            
        }else {
            if WHDragTool.get().isEditing {
                return true
            }else {
                return false
            }
        }
    }
}





