//
//  FocalSessionViewController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 14/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import UIKit

class FocalSessionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, WeatherViewControllerDelegate  {
    
    @IBOutlet weak var individualsView: UICollectionView!
    @IBOutlet weak var observationsView: UITableView!
    @IBOutlet weak var statesView: UICollectionView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoOverlayView: UIView!
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var observationDisplay: UIView!
    @IBOutlet weak var weatherOverlayView: UIView!
    
    let textCellIdentifier = "SingleLineTextCell"
    let circleCellIdentifier = "CircleCell"
    let circleLabelCellIdentifier = "CircleWithLabelCell"
    
    let individualsDefaultColor = UIColor.lightGrayColor()
    let individualsSelectedColor = UIColor.greenColor()
    let statesDefaultColor = UIColor.lightGrayColor()
    let statesSelectedColor = UIColor.greenColor()
    
    let numSections = 1
    
    let messageAdd = "+ Add"
    
    let weatherVC = WeatherViewController(nibName: "WeatherView", bundle: nil)
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
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("FocalSessionView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideObservationSection()
        setupViews()
        getData()
        // Sets up the date formatter for converting dates to strings
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViews() {
        setupWeatherController()
        
        observationsView.dataSource = self
        observationsView.delegate = self
        
        individualsView.dataSource = self
        individualsView.delegate = self
        
        statesView.dataSource = self
        statesView.delegate = self
        
        notesView.delegate = self
        
        observationsView.registerNib(UINib(nibName: textCellIdentifier, bundle: nil), forCellReuseIdentifier: textCellIdentifier)
        individualsView.registerNib(UINib(nibName: circleCellIdentifier, bundle: nil), forCellWithReuseIdentifier: circleCellIdentifier)
        statesView.registerNib(UINib(nibName: circleLabelCellIdentifier, bundle: nil), forCellWithReuseIdentifier: circleLabelCellIdentifier)
        
        // Sets the subviews to display under the navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Sets the rounded corners for the views
        observationsView.layer.cornerRadius = 8
        observationsView.layer.masksToBounds = true
        individualsView.layer.cornerRadius = 8
        individualsView.layer.masksToBounds = true
        statesView.layer.cornerRadius = 8
        statesView.layer.masksToBounds = true
        photoView.layer.cornerRadius = 8
        photoView.layer.masksToBounds = true
        photoOverlayView.layer.cornerRadius = 8
        photoOverlayView.layer.masksToBounds = true
        notesView.layer.cornerRadius = 8
        notesView.layer.masksToBounds = true
    }
    
    func setupWeatherController() {
        weatherVC.delegate = self
        weatherVC.view.frame = CGRectMake(0, 0, weatherOverlayView.frame.width, weatherOverlayView.frame.height)
        weatherOverlayView.addSubview(weatherVC.view)
    }
    
    func makeEditable(value: Bool) {
        editable = value
        refreshViews()
    }
    
    func refreshViews() {
        selectedObservations = [Observation]()
        
        individuals = [Individual]()
        originalObservations = [Individual: [Observation]]()
        newObservations = [Individual: [Observation]]()
        
        getData()
        individualsView.reloadData()
        observationsView.reloadData()
        statesView.reloadData()
        hideObservationSection()
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
            newObservations[all] = []
            
            // If there are no individuals defined, do nothing
            if currentSession!.project.individuals.count > 0 {
                
                originalObservations[all] = currentSession!.observations
                newObservations[all] = getCopyOfObservations(currentSession!.observations)
                
                // Copy over observations
                for i in currentSession!.project.individuals {
                    individuals.append(i)
                    let observations = currentSession!.getAllObservationsForIndividual(i)
                    originalObservations[i] = observations
                    newObservations[i] = getCopyOfObservations(observations)
                }
            }
            
            // Get states
            states = currentSession!.project.ethogram.behaviourStates
        }
    }
    
    // Copies over the information in the edited individuals to the original individuals.
    // Copies over the information in the edited observations to the original observations.
    // Adds new individuals or observations.
    func saveData() {
        let originalIndividuals = currentSession!.project.individuals
        
        individuals.removeAtIndex(0) // Remove the 'All' individual
        for i in 0...individuals.count - 1 {
            let individual = individuals[i] // Get the individual
            
            // If this individual exists in the project
            if i < originalIndividuals.count {
                
                let observations = newObservations[individual]!
                let original = originalObservations[individual]!
                
                if observations.count > 0 {
                    for j in 0...observations.count - 1 {
                        if j < original.count {
                            // Copy over the updated information of the observation
                            copyOverObservation(observations[j], to: original[j])
                        } else {
                            // Add a new observation
                            currentSession!.addObservation([observations[j]])
                        }
                    }
                }
            } else { // If this individual does not exist in the project
                // Add it to the project
                currentSession!.project.addIndividuals([individual])
                
                // Add its observations to the session
                currentSession!.addObservation(newObservations[individual]!)
            }
            
        }
    }
    
    // Returns a deep copy of the given array of observations.
    func getCopyOfObservations(array: [Observation]) -> [Observation]{
        var newArray = [Observation]()
        for o in array {
            let observation = Observation(session: o.session, individual: o.individual!, state: o.state, timestamp: o.timestamp, information: o.information)
            observation.updatePhoto(o.photo)
            if o.weather != nil {
                observation.changeWeather(o.weather!)
            }
            newArray.append(observation)
        }
        return newArray
    }
    
    // Copy fields of 'from' to 'to'.
    func copyOverObservation(from: Observation, to: Observation) {
        to.changeBehaviourState(from.state)
        to.updateInformation(from.information)
        to.updatePhoto(from.photo)
        if from.weather != nil {
            to.changeWeather(from.weather!)
        }
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
                showFormForIndividual(indexPath)
            } else {
                selectedIndividual = indexPath.row
                refreshObservations()
            }
            
        } else if collectionView == statesView {
            showStateAsSelected(indexPath.row)
            let observation = selectedObservations[selectedObservation]
            observation.changeBehaviourState(states[indexPath.row])
        }
    }
    
    // UITableViewDataSource and UITableViewDelegate METHODS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! SingleLineTextCell
        
        cell.textField.hidden = true
        
        // Show extra row for adding observations for all individuals except 'All'
        if selectedIndividual != 0 && isExtraRowForObservations(indexPath.row) {
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
            
            refreshObservations()
        }
        selectedObservation = indexPath.row
        showObservationAtIndex(indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editable && selectedIndividual != 0 {
            return selectedObservations.count + 1
        } else {
            return selectedObservations.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numSections
    }
    
    // UITextViewDelegate methods
    // Updates the currently displayed observation's text when user types in the text view.
    func textViewDidChange(textView: UITextView) {
        let observation = selectedObservations[selectedObservation]
        observation.updateInformation(textView.text)
    }
    
    // WeatherViewControllerDelegate methods
    // Updates the currently displayed observation's weather when user changes the weather.
    func userDidSelectWeather(weather: Weather?) {
        let observation = selectedObservations[selectedObservation]
        if weather != nil {
            observation.changeWeather(weather!)
        } else {
            observation.changeWeather(Weather())
        }
    }
    
    // End delegate methods
    
    func refreshObservations() {
        var allObservations = [Observation]()
        for i in 1...individuals.count - 1 {
            for o in newObservations[individuals[i]]! {
                allObservations.append(o)
            }
        }
        newObservations[individuals[0]] = allObservations
        
        
        showIndividualAtIndex(NSIndexPath(forRow: selectedIndividual, inSection: 0))
        observationsView.reloadData()
    }
    
    // Methods to toggle views
    func showIndividualAtIndex(indexPath: NSIndexPath) {
        if isValidIndexForIndividuals(indexPath.row) {
            selectedIndividual = indexPath.row
            
            showIndividualAsSelected(indexPath.row)
            
            showObservationsForIndividual(individuals[indexPath.row])
            hideObservationSection()
        }
    }
    
    func showIndividualAsSelected(selectedIndex: Int) {
        if isValidIndexForIndividuals(selectedIndex) {
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
    }
    
    func showObservationAtIndex(indexPath: NSIndexPath) {
        if !isExtraRowForObservations(indexPath.row) {
            showObservationSection()
            
            let observation = selectedObservations[indexPath.row]
            
            // Update views
            showStateAsSelected(getIndexOfState(observation.state))
            if observation.photo != nil {
                photoView.image = observation.photo!.image
            } else {
                photoView.image = nil
            }
            notesView.text = observation.information
            
            weatherVC.setWeather(observation.weather)
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
    
    func hideObservationSection() {
        observationDisplay.hidden = true
    }
    
    func showObservationSection() {
        photoOverlayView.hidden = !editable
        notesView.userInteractionEnabled = editable
        weatherVC.view.userInteractionEnabled = editable
        observationDisplay.hidden = false
    }
    
    func showFormForIndividual(indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "New Individual", message: "", preferredStyle: .Alert)
        
        // Adds buttons
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let actionOk = UIAlertAction(title: "OK", style: .Default, handler: {action in
            let textField = alert.textFields!.first as! UITextField
            
            let individual = Individual(label: textField.text)
            self.addIndividual(individual)
        })
        actionOk.enabled = false
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        
        // Adds a text field for the label
        alert.addTextFieldWithConfigurationHandler({textField in
            textField.placeholder = "Label (eg: M1, F1)"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                actionOk.enabled = textField.text != ""
            }
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addIndividual(individual: Individual) {
        individuals.append(individual)
        
        newObservations[individual] = []
        
        individualsView.reloadData()
        self.showObservationsForIndividual(individual)
    }
    
    // IBActions for buttons
    @IBAction func photoBtnPressed(sender: UIButton) {
        
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
    
    func isValidIndexForIndividuals(index: Int) -> Bool {
        if editable {
            return !isExtraRowForIndividuals(index)
        } else {
            return index < individuals.count
        }
        
    }
    
    func isExtraRowForIndividuals(index: Int) -> Bool {
        return index == individuals.count
    }
    
    func isExtraRowForObservations(index: Int) -> Bool {
        return index >= selectedObservations.count
    }
    
}

