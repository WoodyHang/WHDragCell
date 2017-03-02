//
//  WHDragView.swift
//  DragCell
//
//  Created by Woodyhang on 17/2/27.
//  Copyright © 2017年 Woodyhang. All rights reserved.
//

import UIKit

class WHDragView: UIView {
    
    var collectionView:UICollectionView!
    
    var switchButton:UIButton!
    
    static var cellIdentify = "WHCell"
    
    var screenShotView:UIView! //截屏得到的cell
    
    struct WHConst {
        static var startPoint = CGPoint(x: 0, y: 0)
    }
    
    var firstIndexPath:IndexPath? = IndexPath(row: 0, section: 0)
    
    var nextIndexPath = IndexPath(row: 0, section: 0)
    
    var oldCell:WHDragCell!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubView()
    }
    
    func setUpSubView(){
        //1.首先头部的按钮
        let tipLabel = UILabel(frame: CGRect(x: 8, y: 30, width: 60, height: 25))
        self.addSubview(tipLabel)
        tipLabel.text = "我的关注"
        tipLabel.adjustsFontSizeToFitWidth = true
        
        switchButton = UIButton(frame: CGRect(x: SCREENWIDTH - 8 - 60, y: 30, width: 60, height: 25))
        self.addSubview(switchButton)
        switchButton.setTitle("排序删除", for: .normal)
        switchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        switchButton.setTitleColor(UIColor.orange, for: .normal)
        switchButton.addTarget(self, action: #selector(WHDragView.deleteCell), for: .touchDown)
        
        //2.初始化collectionview
        let itemLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 55, width: SCREENWIDTH, height: SCREENHEIGHT - 55), collectionViewLayout: itemLayout)
        self.addSubview(collectionView)
        itemLayout.itemSize = CGSize(width: Item_width, height: item_height)
        
        itemLayout.minimumLineSpacing = CGFloat(ItemLineSpacing)
        itemLayout.minimumInteritemSpacing = CGFloat(ItemInteritemSpacing)
        itemLayout.sectionInset = UIEdgeInsetsMake(kContentLeftAndRightSpace, kContentLeftAndRightSpace, kContentLeftAndRightSpace, kContentLeftAndRightSpace)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName:"WHDragCell",bundle:nil), forCellWithReuseIdentifier: WHDragView.cellIdentify)
        collectionView.backgroundColor = UIColor.white
        
        
    }
    
    func deleteCell(sender:UIButton){
        
        WHDragTool.get().isEditing = !WHDragTool.get().isEditing
        
        let titleString = WHDragTool.get().isEditing ?"完成":"排序删除"
        switchButton.setTitle(titleString, for: .normal)
        collectionView.reloadData()
    }
}

extension WHDragView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WHDragTool.get().subscribeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WHDragView.cellIdentify, for: indexPath) as! WHDragCell
        cell.label.text = WHDragTool.get().subscribeArray[indexPath.row] as? String
        cell.deleteButton.isHidden = !WHDragTool.get().isEditing
        
        cell.delegate = self
        return cell
    }
    
}

extension WHDragView:WHDragDelegate{
    
    func WHDragCellGestureAction(gesture: UIGestureRecognizer) {
        
        let cell = gesture.view as! WHDragCell
        //print(collectionView.indexPath(for: cell))
        switch gesture.state {
        case .began://开始记录位置
            if gesture.isKind(of: UILongPressGestureRecognizer.self){
                
                WHDragTool.get().isEditing = true
                let titleString = WHDragTool.get().isEditing ?"完成":"排序删除"
                switchButton.setTitle(titleString, for: .normal)
                for cell in collectionView.visibleCells{
                    (cell as! WHDragCell).isEditing = true
                }                
            }
            //获取cell的截图
            screenShotView = cell.snapshotView(afterScreenUpdates:true)
            self.screenShotView.center = cell.center

            

            collectionView.addSubview(screenShotView)
            firstIndexPath = collectionView.indexPath(for: cell)!
            oldCell = cell
            oldCell.isHidden = true
            WHConst.startPoint = gesture.location(in: collectionView)

            
        case .changed: //移动
            oldCell.isHidden = true
            //偏移量
            screenShotView.center = gesture.location(in: collectionView)
            WHConst.startPoint = gesture.location(ofTouch: 0, in: collectionView)
            
            //计算截图与哪个cell相交
            for cell in collectionView.visibleCells{
                //排除掉隐藏的cell
                if collectionView.indexPath(for: cell) == firstIndexPath || collectionView.indexPath(for: cell)?.item == 0 {
                    continue
                }
                
                //两个cell的距离
                let centerDistance = sqrt(pow(screenShotView.center.x - cell.center.x, 2) + pow(screenShotView.center.y - cell.center.y, 2))
                ////如果相交一半且两个视图Y的绝对值小于高度的一半就移动
                if centerDistance <= screenShotView.bounds.size.width / 2 && fabs(cell.center.y - screenShotView.center.y) <= screenShotView.bounds.size.height / 2 {
                    
                    nextIndexPath = collectionView.indexPath(for: cell)!
                    
                    if nextIndexPath.item > (firstIndexPath?.item)! {//向后移
                        for i in (firstIndexPath?.item)!..<nextIndexPath.item {
                            WHDragTool.get().subscribeArray.exchangeObject(at: i, withObjectAt: i+1)
                        }
                    }else {
                        for i in (nextIndexPath.item..<(firstIndexPath?.item)!).reversed() {//向前移
                            print("index==\(i)")
                            WHDragTool.get().subscribeArray.exchangeObject(at: i, withObjectAt: i + 1)
                        }
                    }
                    
                    
                    collectionView.moveItem(at: firstIndexPath!, to: nextIndexPath)
                    
                    firstIndexPath = nextIndexPath
                  
                     break
                }
               
            }
        case .ended:
            screenShotView.removeFromSuperview()
            oldCell.isHidden = false

            
        default:
            break
        }
    }
    
    func WHDragCellCancelTheme(themeCell: WHDragCell) {
        WHDragTool.get().subscribeArray.removeObject(at: (collectionView.indexPath(for: themeCell)?.item)!)
        
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}








