//
//  ScanViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var animalsView: UICollectionView!
    @IBOutlet weak var statesView: UICollectionView!
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    
    let animalsTag = 11
    let statesTag = 12
    
    let cellReuseIdentifier = "CollectionCell"
    
    var currentSession: Session? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animalsView.dataSource = self
        animalsView.delegate = self
        
        statesView.dataSource = self
        statesView.delegate = self
        
        animalsView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        animalsView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    // UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        // Make it a circle
        cell.contentView.layer.cornerRadius = 0.25
        
        if collectionView.tag == animalsTag {
            
        } else if collectionView.tag == statesTag {
            
        } else {
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == animalsTag {
            
        } else if collectionView.tag == statesTag {
            
        } else {
            
        }
        return 0
    }
    
    // UICollectionViewDelegate methods
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.tag == animalsTag {
            
        } else if collectionView.tag == statesTag {
            
        } else {
            
        }
    }

    @IBAction func leftArrowPressed(sender: UIButton) {
        
    }
    
    @IBAction func rightArrowPressed(sender: UIButton) {
        
    }
    
}
