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
    
    let circleCellIdentifier = "CircleCell"
    let circleLabelCellIdentifier = "CircleWithLabelCell"
    
    let animalsDefaultColor = UIColor.lightGrayColor()
    let animalsSelectedColor = UIColor.greenColor()
    let statesDefaultColor = UIColor.lightGrayColor()
    let statesSelectedColor = UIColor.greenColor()
    
    var editable = false
    
    var currentSession: Session? = nil
    var selectedTimestamp: NSDate? = nil
    
    var originalObservations = [Observation]()
    var observations = [Observation]()
    var states = [BehaviourState]()
    
    var selectedObservation = 0
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("ScanView", owner: self, options: nil).first as! UIView
    }
    
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
        
        animalsView.registerNib(UINib(nibName: circleCellIdentifier, bundle: nil), forCellWithReuseIdentifier: circleCellIdentifier)
        statesView.registerNib(UINib(nibName: circleLabelCellIdentifier, bundle: nil), forCellWithReuseIdentifier: circleLabelCellIdentifier)
        
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
    
    func makeEditable(value: Bool) {
        editable = value
        animalsView.reloadData()
        statesView.reloadData()
    }
    
    // Sets the data source of this controller.
    func setData(session: Session, timestamp: NSDate) {
        currentSession = session
        selectedTimestamp = timestamp
    }
    
    func getData() {
        if currentSession != nil && selectedTimestamp != nil {
            originalObservations = currentSession!.getObservationsByTimestamp(selectedTimestamp!)
            states = currentSession!.project.ethogram.behaviourStates
            
            observations.removeAll()
            for o in originalObservations {
                let newObservation = Observation(session: o.session, state: o.state, timestamp: o.timestamp, information: o.information)
                observations.append(newObservation)
            }
        }
    }
    
    // Copy over the information in the edited observations to the original observations.
    func saveData() {
        for i in 0...observations.count { // intentionally include observations.count (last loop)
            if i < originalObservations.count {
                // Copy over the updated information of the observation
                copyOverObservation(observations[i], to: originalObservations[i])
            } else {
                // Add a new observation
                currentSession!.addObservation([observations[i]])
            }
        }
    }
    
    // Copy fields of 'from' to 'to'.
    func copyOverObservation(from: Observation, to: Observation) {
        to.changeBehaviourState(from.state)
        to.updateInformation(from.information)
    }
    
    // UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == animalsView {
            return getCellForAnimalsView(indexPath)
        } else if collectionView == statesView {
            return getCellForStatesView(indexPath)
        }
        return UICollectionViewCell()
    }
    
    // Returns a cell that displays an animal in a scan.
    func getCellForAnimalsView(indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = animalsView.dequeueReusableCellWithReuseIdentifier(circleCellIdentifier, forIndexPath: indexPath) as! CircleCell
        
        if isExtraRow(indexPath.row) {
            cell.label.text = "+"
        } else {
            cell.label.text = "A\(indexPath.row)"
        }
        
        cell.backgroundColor = animalsDefaultColor
        
        return cell
    }
    
    // Returns a cell that displays a behaviour state. User interaction is disabled if this
    // view controller is not editable.
    func getCellForStatesView(indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = statesView.dequeueReusableCellWithReuseIdentifier(circleLabelCellIdentifier, forIndexPath: indexPath) as! CircleWithLabelCell
        
        let name = states[indexPath.row].name
        cell.circleViewLabel.text = name.substringToIndex(name.startIndex.successor())
        cell.label.text = name
        cell.circleView.backgroundColor = statesDefaultColor
        
        cell.userInteractionEnabled = editable
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        
        if collectionView == animalsView {
            itemCount = observations.count
            
            if editable {
                // Add an extra cell for the add button
                itemCount = itemCount + 1
            }
            
        } else if collectionView == statesView {
            itemCount = states.count
        }
        return itemCount
    }
    
    // UICollectionViewDelegate methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == animalsView {
            
            selectedObservation = indexPath.row
            
            // User wants to add an extra animal
            if isExtraRow(indexPath.row) {
                // Add a new observation
                let observation = Observation(session: currentSession!, state: states.first!, timestamp: selectedTimestamp!, information: "")
                observations.append(observation)
                
                // Reload views
                animalsView.reloadData()
                statesView.reloadData()
            }
            
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
        } else if observations.count == 1 {
            leftArrow.hidden = true
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
                let cell = statesView.cellForItemAtIndexPath(index) as! CircleWithLabelCell
                if i == selectedIndex {
                    cell.circleView.backgroundColor = statesSelectedColor
                } else {
                    cell.circleView.backgroundColor = statesDefaultColor
                }
            }
        }
    }
    
    func setCellAsDefault() {
        
    }
    
    func setCellAsSelected() {
        
    }
    
    // Actions for arrow buttons
    @IBAction func leftArrowPressed(sender: UIButton) {
        selectedObservation = selectedObservation - 1
        showObservationAtIndex(NSIndexPath(forRow: selectedObservation, inSection: 0))
    }
    
    @IBAction func rightArrowPressed(sender: UIButton) {
        selectedObservation = selectedObservation + 1
        showObservationAtIndex(NSIndexPath(forRow: selectedObservation, inSection: 0))
    }
    
    // Helper methods
    func getIndexOfState(state: BehaviourState) -> Int {
        for (var i = 0; i < states.count; i++) {
            if states[i] == state {
                return i
            }
        }
        return 0
    }
    
    func isExtraRow(index: Int) -> Bool {
        return index == observations.count
    }
    
}
