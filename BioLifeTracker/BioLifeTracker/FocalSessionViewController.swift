//
//  FocalSessionViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FocalSessionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate  {
    var delegate: FocalSessionViewControllerDelegate? = nil
    
    @IBOutlet weak var individualsView: UICollectionView!
    @IBOutlet weak var observationsView: UITableView!
    @IBOutlet weak var statesView: UICollectionView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoOverlayView: UIView!
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var observationDisplay: UIView!
    
    let textCellIdentifier = "SingleLineTextCell"
    let circleCellIdentifier = "CircleCell"
    let circleLabelCellIdentifier = "CircleWithLabelCell"
    
    let individualsDefaultColor = UIColor.lightGrayColor()
    let individualsSelectedColor = UIColor.greenColor()
    let statesDefaultColor = UIColor.lightGrayColor()
    let statesSelectedColor = UIColor.greenColor()
    
    let numSections = 1
    
    let messageAdd = "+ Add"
    
    let formatter = NSDateFormatter()
    
    var editable = false
    
    var currentSession: Session? = nil
    var selectedIndividual = 0
    var selectedObservation = 0
    var selectedObservations = [Observation]()
    
    var individuals = [Individual]()
    // Maps the individual's label to a list of its observations in this session
    var originalObservations = [Individual: [Observation]]()
    var newObservations = [Individual: [Observation]]()
    var states = [BehaviourState]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        // Sets up the date formatter for converting dates to strings
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        
        getData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showIndividualAtIndex(NSIndexPath(forRow: 0, inSection: 0))
    }
    
    func setupViews() {
        observationsView.dataSource = self
        observationsView.delegate = self
        
        individualsView.dataSource = self
        individualsView.delegate = self
        
        statesView.dataSource = self
        statesView.delegate = self
        
        observationsView.registerNib(UINib(nibName: textCellIdentifier, bundle: nil), forCellReuseIdentifier: textCellIdentifier)
        individualsView.registerNib(UINib(nibName: circleCellIdentifier, bundle: nil), forCellWithReuseIdentifier: circleCellIdentifier)
        statesView.registerNib(UINib(nibName: circleLabelCellIdentifier, bundle: nil), forCellWithReuseIdentifier: circleLabelCellIdentifier)
        
        // Sets the subviews to display under the navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Sets the rounded corners for the views
        observationsView.layer.cornerRadius = 8;
        observationsView.layer.masksToBounds = true;
        individualsView.layer.cornerRadius = 8;
        individualsView.layer.masksToBounds = true;
        statesView.layer.cornerRadius = 8;
        statesView.layer.masksToBounds = true;
        photoView.layer.cornerRadius = 8;
        photoView.layer.masksToBounds = true;
        photoOverlayView.layer.cornerRadius = 8;
        photoOverlayView.layer.masksToBounds = true;
        notesView.layer.cornerRadius = 8;
        notesView.layer.masksToBounds = true;
    }
    
    func makeEditable(value: Bool) {
        editable = value
        individualsView.reloadData()
        observationsView.reloadData()
        statesView.reloadData()
    }
    
    // Sets the data source of this controller.
    func setData(session: Session) {
        currentSession = session
    }
    
    func getData() {
        if currentSession != nil {
            // Setup the individuals array
            let all = Individual(label: "All")
            individuals.append(all)
            originalObservations[all] = currentSession!.observations
            newObservations[all] = getCopyOfObservations(currentSession!.observations)
            
            println(currentSession!.project.individuals)
            
            // Copy over observations
            for i in currentSession!.project.individuals {
                individuals.append(i)
                let observations = currentSession!.getAllObservationsForIndividual(i)
                originalObservations[i] = observations
                newObservations[i] = getCopyOfObservations(observations)
            }
            
            // Get states
            states = currentSession!.project.ethogram.behaviourStates
        }
    }
    
    // Copy over the information in the edited observations to the original observations.
    func saveData() {
        for i in individuals {
            let observations = newObservations[i]!
            let original = originalObservations[i]!
            
            for j in 0...observations.count {
                if j < original.count {
                    // Copy over the updated information of the observation
                    copyOverObservation(observations[j], to: original[j])
                } else {
                    // Add a new observation
                    currentSession!.addObservation([observations[j]])
                }
            }
        }
    }
    
    func getCopyOfObservations(array: [Observation]) -> [Observation]{
        var newArray = [Observation]()
        for o in array {
            let observation = Observation(session: o.session, individual: o.individual!, state: o.state, timestamp: o.timestamp, information: o.information)
            newArray.append(observation)
        }
        return newArray
    }
    
    // Copy fields of 'from' to 'to'.
    func copyOverObservation(from: Observation, to: Observation) {
        to.changeBehaviourState(from.state)
        to.updateInformation(from.information)
    }
    
    // UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == individualsView {
            return getCellForIndividualsView(indexPath)
        } else if collectionView == statesView {
            return getCellForStatesView(indexPath)
        }
        return UICollectionViewCell()
    }
    
    // Returns a cell that displays an individual in a scan.
    func getCellForIndividualsView(indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = individualsView.dequeueReusableCellWithReuseIdentifier(circleCellIdentifier, forIndexPath: indexPath) as! CircleCell
        
        if isExtraRowForIndividuals(indexPath.row) {
            cell.label.text = messageAdd
        } else {
            cell.label.text = individuals[indexPath.row].label
        }
        
        cell.backgroundColor = individualsDefaultColor
        
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
        
        if collectionView == individualsView {
            itemCount = individuals.count
            
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
        if collectionView == individualsView {
            
            // User wants to add an extra individual
            if isExtraRowForIndividuals(indexPath.row) {
                // Popup a alert view with text field
                
                // Add a new individual
                let individual = Individual(label: "")
                individuals.append(individual)
                newObservations[individual] = []
                
                // Reload views
                individualsView.reloadData()
            }
            selectedIndividual = indexPath.row
            showIndividualAtIndex(indexPath)
            
        } else if collectionView == statesView {
            showStateAsSelected(indexPath.row)
            let observation = newObservations[individuals[selectedIndividual]]![indexPath.row]
            observation.changeBehaviourState(states[indexPath.row])
        }
    }
    
    func showIndividualAtIndex(indexPath: NSIndexPath) {
        showIndividualAsSelected(indexPath.row)
        
        showObservationsForIndividual(individuals[indexPath.row])
    }
    
    func showIndividualAsSelected(selectedIndex: Int) {
        if selectedIndex < individuals.count {
            for i in 0...individuals.count - 1 {
                let index = NSIndexPath(forRow: i, inSection: 0)
                if i == selectedIndex {
                    individualsView.cellForItemAtIndexPath(index)!.backgroundColor = individualsSelectedColor
                } else {
                    individualsView.cellForItemAtIndexPath(index)!.backgroundColor = individualsDefaultColor
                }
            }
        }
    }
    
    func showObservationsForIndividual(individual: Individual) {
        selectedObservations = newObservations[individual]!
        observationsView.reloadData()
        observationsView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Top)
    }
    
    func showObservationAtIndex(indexPath: NSIndexPath) {
        if indexPath.row < selectedObservations.count {
            
            let observation = selectedObservations[indexPath.row]
            
            // Update views
            showStateAsSelected(getIndexOfState(observation.state))
            if observation.photo != nil {
                photoView.image = observation.photo!.image
            } else {
                photoView.image = nil
            }
            notesView.text = observation.information
            
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
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! SingleLineTextCell
        
        cell.textField.hidden = true
        
        if isExtraRowForObservations(indexPath.row) {
            cell.label.text = messageAdd
        } else {
            let observation = selectedObservations[indexPath.row]
            cell.label.text = formatter.stringFromDate(observation.createdAt)
        }
        
        return cell
    }
    
    // Sets the selected observation, updates the views for displaying observation fields.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isExtraRowForObservations(indexPath.row) {
            // Add new observation with default first state
            let observation = Observation(session: currentSession!, individual: individuals[selectedIndividual], state: states.first!, timestamp: NSDate(), information: "")
            newObservations[individuals[selectedIndividual]]!.append(observation)
            
            tableView.reloadData()
        }
        selectedObservation = indexPath.row
        showObservationAtIndex(indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editable {
            return selectedObservations.count + 1
        } else {
            return selectedObservations.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    @IBAction func photoBtnPressed(sender: UIButton) {
        
    }
    
    func hideObservationSection() {
        observationDisplay.hidden = true
    }
    
    func showObservationSection() {
        observationDisplay.hidden = false
    }
    
    // Helper methods
    func getIndexOfState(state: BehaviourState) -> Int {
        for i in 0...states.count {
            if states[i] == state {
                return i
            }
        }
        return 0
    }
    
    func isExtraRowForIndividuals(index: Int) -> Bool {
        return index == individuals.count
    }
    
    func isExtraRowForObservations(index: Int) -> Bool {
        return index == selectedObservations.count
    }
    
}

