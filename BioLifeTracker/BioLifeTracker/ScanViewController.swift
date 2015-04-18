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
    
    let cellReuseIdentifier = "CircleCell"
    
    let animalsDefaultColor = UIColor.lightGrayColor()
    let animalsSelectedColor = UIColor.greenColor()
    let statesDefaultColor = UIColor.lightGrayColor()
    let statesSelectedColor = UIColor.greenColor()
    
    var currentSession: Session? = nil
    var selectedTimestamp: NSDate? = nil
    
    var observations = [Observation]()
    var states = [BehaviourState]()
    
    var selectedObservation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViews()
        getData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showObservationAtIndex(NSIndexPath(forRow: 0, inSection: 0))
    }
    
    func setupCollectionViews() {
        animalsView.dataSource = self
        animalsView.delegate = self
        
        statesView.dataSource = self
        statesView.delegate = self
        
        animalsView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        statesView.registerNib(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // Sets the subviews to display under the navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Sets the rounded corners for the table views
        animalsView.layer.cornerRadius = 8;
        animalsView.layer.masksToBounds = true;
        statesView.layer.cornerRadius = 8;
        statesView.layer.masksToBounds = true;
        notesView.layer.cornerRadius = 8;
        notesView.layer.masksToBounds = true;
    }
    
    func getData() {
        if currentSession != nil && selectedTimestamp != nil {
            observations = currentSession!.getObservationsByTimestamp(selectedTimestamp!)
            states = currentSession!.project.ethogram.behaviourStates
        }
    }
    
    // UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CircleCell
        
        if collectionView == animalsView {
            cell.label.text = "A\(indexPath.row)"
            cell.backgroundColor = animalsDefaultColor
        } else if collectionView == statesView {
            let name = states[indexPath.row].name
            cell.label.text = name.substringToIndex(name.startIndex.successor())
            cell.backgroundColor = statesDefaultColor
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == animalsView {
            return observations.count
        } else if collectionView == statesView {
            return states.count
        }
        return 0
    }
    
    // UICollectionViewDelegate methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == animalsView {
            selectedObservation = indexPath.row
            showObservationAtIndex(indexPath)
            
        } else if collectionView == statesView {
            showStateAsSelected(indexPath.row)
            observations[selectedObservation].changeBehaviourState(states[indexPath.row])
        }
    }
    
    func showObservationAtIndex(indexPath: NSIndexPath) {
        showAnimalAsSelected(indexPath.row)
        
        let observation = observations[indexPath.row]
        showStateAsSelected(getIndexOfState(observation.state))
    }
    
    func showAnimalAsSelected(selectedIndex: Int) {
        if selectedIndex < observations.count {
            for i in 0...observations.count - 1 {
                let index = NSIndexPath(forRow: i, inSection: 0)
                if i == selectedIndex {
                    animalsView.cellForItemAtIndexPath(index)!.backgroundColor = animalsSelectedColor
                } else {
                    animalsView.cellForItemAtIndexPath(index)!.backgroundColor = animalsDefaultColor
                }
            }
        }
        
        // Toggle visibility of arrows
        if selectedIndex == 0 {
            leftArrow.hidden = true
            rightArrow.hidden = false
        } else if selectedIndex == observations.count - 1 {
            leftArrow.hidden = false
            rightArrow.hidden = true
        } else {
            leftArrow.hidden = false
            rightArrow.hidden = false
        }
    }
    
    func showStateAsSelected(selectedIndex: Int) {
        if selectedIndex < states.count {
            for i in 0...states.count - 1 {
                let index = NSIndexPath(forRow: i, inSection: 0)
                if i == selectedIndex {
                    statesView.cellForItemAtIndexPath(index)!.backgroundColor = statesSelectedColor
                } else {
                    statesView.cellForItemAtIndexPath(index)!.backgroundColor = statesDefaultColor
                }
            }
        }
    }
    
    func setCellAsDefault() {
        
    }
    
    func setCellAsSelected() {
        
    }
    
    func getIndexOfState(state: BehaviourState) -> Int {
        for i in 0...states.count {
            if states[i] == state {
                return i
            }
        }
        return 0
    }
    
    @IBAction func leftArrowPressed(sender: UIButton) {
        selectedObservation = selectedObservation - 1
        showObservationAtIndex(NSIndexPath(forRow: selectedObservation, inSection: 0))
    }
    
    @IBAction func rightArrowPressed(sender: UIButton) {
        selectedObservation = selectedObservation + 1
        showObservationAtIndex(NSIndexPath(forRow: selectedObservation, inSection: 0))
    }
    
}
