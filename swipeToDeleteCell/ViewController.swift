//
//  ViewController.swift
//  swipeToDeleteCell
//
//  Created by Imbue on 15/08/2016.
//  Copyright © 2016 Imbue. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var cats : [UIImage] = [UIImage(named: "Cat")!, UIImage(named: "Cats")!,UIImage(named: "Cucumber")!]
    private var activeCell : VideoCell!

    @IBOutlet var myView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView(){
        // Setting up swipe gesture recognizers
        let swipeUp : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.userDidSwipeUp))
        swipeUp.direction = .Up
        
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.userDidSwipeDown))
        swipeDown.direction = .Down
        
        view.addGestureRecognizer(swipeDown)
    }
    
    func getCellAtPoint(point: CGPoint) -> VideoCell? {
        // Function for getting item at point. Note optionals as it could be nil
        let indexPath = myView.indexPathForItemAtPoint(point)
        var cell : VideoCell?
        
        if indexPath != nil {
            cell = myView.cellForItemAtIndexPath(indexPath!) as? VideoCell
        } else {
            cell = nil
        }
        
        return cell
    }

    func userDidSwipeUp(gesture : UISwipeGestureRecognizer){
        let point = gesture.locationInView(myView)
        let duration = animationDuration()
        
        if(activeCell == nil){
            activeCell = getCellAtPoint(point)
            
            UIView.animateWithDuration(duration, animations: {
                self.activeCell.myCellView.transform = CGAffineTransformMakeTranslation(0, -self.activeCell.frame.height)
            });
        } else {
            // Getting the cell at the point
            let cell = getCellAtPoint(point)
            
            // If the cell is the previously swiped cell, or nothing assume its the previously one.
            if cell == nil || cell == activeCell {
                // To target the cell after that animation I test if the point of the swiping exists inside the now twice as tall cell frame
                let cellFrame = activeCell.frame
                let rect = CGRectMake(cellFrame.origin.x, cellFrame.origin.y - cellFrame.height, cellFrame.width, cellFrame.height*2)
                if CGRectContainsPoint(rect, point) {
                    // If swipe point is in the cell delete it
                    
                    let indexPath = myView.indexPathForCell(activeCell)
                    cats.removeAtIndex(indexPath!.row)
                    myView.deleteItemsAtIndexPaths([indexPath!])
                    
                }
                // If another cell is swiped
            } else if activeCell != cell {
                    // It's not the same cell that is swiped, so the previously selected cell will get unswiped and the new swiped.
                UIView.animateWithDuration(duration, animations: {
                    self.activeCell.myCellView.transform = CGAffineTransformIdentity
                    cell!.myCellView.transform = CGAffineTransformMakeTranslation(0, -cell!.frame.height)
                    }, completion: {
                        (Void) in
                        self.activeCell = cell
                    })
                    
            }
        }
        
        
    }
    
    
    func userDidSwipeDown(){
        // Revert back
        if(activeCell != nil){
            let duration = animationDuration()
        
            UIView.animateWithDuration(duration, animations: {
                self.activeCell.myCellView.transform = CGAffineTransformIdentity
            }, completion: {
                (Void) in
                    self.activeCell = nil
            })
        }
    }
    
    func animationDuration() -> Double {
        return 0.5
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // If clicked on another cell than the swiped cell
        let cell = myView.cellForItemAtIndexPath(indexPath)
        if activeCell != nil && activeCell != cell {
            userDidSwipeDown()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    // Loading the data for the collection view
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! VideoCell
        
        cell.myImageView.image = cats[indexPath.row]
        cell.tag = indexPath.row
        
        return cell
    }

}

