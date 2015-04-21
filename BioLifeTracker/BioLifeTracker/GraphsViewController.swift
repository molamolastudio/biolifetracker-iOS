//
//  GraphControllers.swift
//  BioLifeTracker
//
//  Created by Haritha on 26/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

class GraphsViewController:  UIViewController, CPTPlotDataSource, CPTBarPlotDataSource, CPTBarPlotDelegate, CPTScatterPlotDelegate, CPTScatterPlotDataSource, CPTPlotSpaceDelegate, UIPopoverPresentationControllerDelegate {
    var delegate: GraphsViewControllerDelegate!
    
    
    enum GraphType {
        case DayPlot, HourPlot, StateChart
    }
    
    enum WeekDays : Int{
        case Sunday = 6
        case Monday = 0
        case Tuesday = 1
        case Wednesday = 2
        case Thursday = 3
        case Friday = 4
        case Saturday = 5
    }
    
    enum Hours : Int {
        case sixam = 0
        case sevenam = 1
        case eightam = 2
        case nineam = 3
        case tenam = 4
        case elevenam = 5
        case twelvepm = 6
        case onepm = 7
        case twopm = 8
        case threepm = 9
        case fourpm = 10
        case fivepm = 11
        case sixpm = 12
    }
    
    @IBOutlet weak var graphHostingView: CPTGraphHostingView!
    
    private var projectInstance: Project!
    var project: Project { get { return projectInstance } }

    private var graph: CPTXYGraph = CPTXYGraph(frame: CGRectZero)
//    private var dayGraph: CPTXYGraph = CPTXYGraph(frame: CGRectZero)
//    private var hourGraph: CPTXYGraph = CPTXYGraph(frame: CGRectZero)
//    private var statesGraph: CPTXYGraph = CPTXYGraph(frame: CGRectZero)
    private var graphLineWidth: CGFloat = 2.5
    
    // default setting
    private var current: GraphType = .StateChart
    var currentPlot: GraphType { get { return current } }
    
    private var yMaxHours = 0
    private var yMaxDays = 0
    private var yMaxStates = 0

    //x axis possiblities
    private var days = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
    private var hours = ["6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm"]
    
    private var allBehaviourStates: [BehaviourState]!
    private var chosenBehaviourStates: [BehaviourState]!
    
    //y axis -- number of occurences
    private var numberOfDayOccurences: [Int]!
    private var numberOfHourOccurences: [Int]!
    private var numberOfStatesOccurences: [Int]!
    
    private var chosenUsers: [User]!
    private var allUsers: [User]!
    
    private var chosenSessions: [Session]!
    private var allSessions: [Session]!
    
    private var popover: UIPopoverPresentationController!
    private var popoverContent: PopoverLabelViewController!
    
    private var selectedPoint: Int = -1
    
    var AliceBlue = UIColor(red: 228.0/255.0, green: 241.0/255.0, blue: 254.0/255.0, alpha: 1)
    var HourBackgroundGreen = UIColor(red: 153.0/255.0, green: 235.0/255.0, blue: 202.0/255.0, alpha: 1)
    var HourAxesBrown = UIColor(red: 107.0/255.0, green: 58.0/255.0, blue: 48.0/255.0, alpha: 1)
    var DayBackgroundGreen = UIColor(red: 223.0/255.0, green: 213.0/255.0, blue: 229.0/255.0, alpha: 1)
    var DayAxesBrown = UIColor(red: 37.0/255.0, green: 46.0/255.0, blue: 6.0/255.0, alpha: 1)
    var StatesBackgroundGreen = UIColor(red: 228.0/255.0, green: 241.0/255.0, blue: 254.0/255.0, alpha: 1)
    var StatesAxesBrown = UIColor.blackColor()
    
    //var GreenSeaHighLight = UIColor(red: 183.0/255.0, green: 88.0/255.0, blue: 77.0/255.0, alpha: 1)
    var PlotSelectRed = UIColor(red: 234.0/255.0, green: 79.0/255.0, blue: 88.0/255.0, alpha: 1)
    
    // Returns an array of twenty colors at hue of 120
    let colors = randomColorsCount(20, hue: .Random, luminosity: .Light)
    
    override func loadView() {
        self.view = NSBundle.mainBundle().loadNibNamed("GraphsView", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseGraph()
        observeRotation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        UnobserveRotation()
    }
    
    func observeRotation() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
    }
    
    func UnobserveRotation() {
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    /********************* SET INITIAL DATA **********************/
    //Gets the data that conform to what the user provided and 
    //sets them as conditions for the the graph
    func initialiseGraph() {
        initConditions()
        prepareNumberOfOccurances()
        drawGraph()
    }

    func initConditions() {
        setAllUsers()
        setAllSessions()
        setAllBehaviourStates()
    }
    
    func updateUsers(chosen: [User]) {
        chosenUsers = chosen
    }
    
    func updateSessions(chosen: [Session]) {
        chosenSessions = chosen
    }
    
    func updateBehaviourStates(chosen: [BehaviourState]) {
        chosenBehaviourStates = chosen
        
    }
    
    func setAllUsers() {
        allUsers = projectInstance.members
        chosenUsers = allUsers
    }
    
    func setAllSessions() {
        allSessions = projectInstance.sessions
        chosenSessions = allSessions
    }
    
    func setAllBehaviourStates() {
        allBehaviourStates = projectInstance.ethogram.behaviourStates
        chosenBehaviourStates = allBehaviourStates
    }
    
    func getAllUsers() -> [User]{
        return allUsers
    }
    
    func getAllSessions() -> [Session]{
        return allSessions
    }
    
    func getAllBehaviourStates() -> [BehaviourState]{
        return allBehaviourStates
    }
    
    func getChosenUsers() -> [User]{
        return chosenUsers
    }
    
    func getChosenSessions() -> [Session]{
        return chosenSessions
    }
    
    func getChosenBehaviourStates() -> [BehaviourState]{
        return chosenBehaviourStates
    }
    
    
    
    /*********************** UPDATE FOR GRAPH ********************/
    func updateGraph() {
        prepareNumberOfOccurances()
        drawGraph()
    }
    
    func drawGraph() {
        configureGraph()
        configurePlots()
        configureAxes()
        graphHostingView.hostedGraph.reloadData()
    }
    
    func toggleGraph(type: GraphType) {
        current = type
    }
    
    func setProject(project: Project) {
        projectInstance = project
    }
    
    /***************** PREPARE OCCURENCES ************/
    func prepareNumberOfOccurances() {
        var occurences = projectInstance.getObservations(sessions: chosenSessions, users: chosenUsers, behaviourStates: chosenBehaviourStates)
        
        switch current {
        case .StateChart:
            prepareBehaviourStateOccurences()
        case .DayPlot:
            prepareDayOccurences(occurences)
        case .HourPlot:
            prepareHourOccurences(occurences)
        }
    }
    
    func prepareBehaviourStateOccurences() {
        var numPerBS = projectInstance.getObservationsPerBS()
        //initialize to 0 elements
        numberOfStatesOccurences = [Int]()
        
        for BS in chosenBehaviourStates {
            if let count = numPerBS[BS.name] {
                numberOfStatesOccurences.append(count)
                
                // check and update max value of y axis
                if count > yMaxStates {
                    var max = count/10
                    max = max+1
                    max = max*10
                    yMaxStates = max
                }
            } else {
                numberOfStatesOccurences.append(0)
            }
        }
    }
    
    func prepareHourOccurences(occurences: [Observation]) {
        
        numberOfHourOccurences = [Int](count: hours.count, repeatedValue:0)
        for occurence in occurences {
            var hour = getHourOfDay(occurence.timestamp)
            numberOfHourOccurences[hour] += 1
            
            // check and update max value of y axis
            var hcount = numberOfHourOccurences[hour]
            if hcount > yMaxHours {
                var max = hcount/10
                max = max+1
                max = max*10
                yMaxHours = max
            }
        }
    }
    
    func prepareDayOccurences(occurences: [Observation]) {
        
        numberOfDayOccurences = [Int](count: days.count, repeatedValue:0)
        for occurence in occurences {
            var day = getDayOfWeek(occurence.timestamp)
            numberOfDayOccurences[day] += 1
            
            //check and update max value of y axis
            var dcount = numberOfDayOccurences[day]
            if dcount > yMaxDays {
                var max = dcount/10
                max = max+1
                max = max*10
                yMaxDays = max
            }
        }
    }

    /********************* HELPER METHODS ********************/
    func getDayOfWeek(date: NSDate) -> Int {
        
        var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        var components = calendar?.components(.CalendarUnitWeekday, fromDate: date)
        var weekday = components?.weekday
        
        switch weekday! {
        case 1:
            return WeekDays.Sunday.rawValue
        case 2:
            return WeekDays.Monday.rawValue
        case 3:
            return WeekDays.Tuesday.rawValue
        case 4:
            return WeekDays.Wednesday.rawValue
        case 5:
            return WeekDays.Thursday.rawValue
        case 6:
            return WeekDays.Friday.rawValue
        case 7:
            return WeekDays.Saturday.rawValue
        default:
            return WeekDays.Saturday.rawValue
        }
    }
    
    func getHourOfDay(date: NSDate) -> Int {
        var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        var components = calendar?.components(.CalendarUnitHour, fromDate: date)
        var hour = components?.hour
        
        switch hour! {
        case 6:
            return Hours.sixam.rawValue
        case 7:
            return Hours.sevenam.rawValue
        case 8:
            return Hours.eightam.rawValue
        case 9:
            return Hours.nineam.rawValue
        case 10:
            return Hours.tenam.rawValue
        case 11:
            return Hours.elevenam.rawValue
        case 12:
            return Hours.twelvepm.rawValue
        case 13:
            return Hours.onepm.rawValue
        case 14:
            return Hours.twopm.rawValue
        case 15:
            return Hours.threepm.rawValue
        case 16:
            return Hours.fourpm.rawValue
        case 17:
            return Hours.fivepm.rawValue
        case 18:
            return Hours.sixpm.rawValue
        default:
            if hour < 6 {
                return Hours.sixam.rawValue
            } else {
                return Hours.sixpm.rawValue
            }
        }

    }
    
    /********************** CONFIGURE GRAPHS ****************/
    
    func configureGraph() {
    
        graphHostingView.allowPinchScaling = false
        graph = CPTXYGraph(frame: CGRectZero)
        graph.applyTheme(CPTTheme(named: kCPTPlainWhiteTheme))
        graphHostingView.hostedGraph = graph
    
        graph.plotAreaFrame.paddingLeft = 40
        graph.plotAreaFrame.paddingRight = 40
        graph.plotAreaFrame.paddingBottom = 40
        graph.plotAreaFrame.paddingTop = 40
        
        graph.plotAreaFrame.fill = getGraphBackgroundColour()
        graph.plotAreaFrame.plotArea.fill = getGraphBackgroundColour()
        
        var plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.allowsUserInteraction = true
        plotSpace.delegate = self
        
    }
    
    func getGraphBackgroundColour() -> CPTFill {
        switch current{
        case .HourPlot:
            return CPTFill(color: CPTColor(CGColor: HourBackgroundGreen.CGColor))
        case .DayPlot:
            return CPTFill(color: CPTColor(CGColor: DayBackgroundGreen.CGColor))
        case .StateChart:
            return CPTFill(color: CPTColor(CGColor: StatesBackgroundGreen.CGColor))
        }
    }
    
    /**************** CONFIGURE PLOTS *********************/
    
    func configurePlots() {

        switch current {
        case .HourPlot:
            configureHourPlot()
        case .DayPlot:
            configureDayPlot()
        case .StateChart:
            configureStatePlot()
        }
    }
    
    func configureHourPlot() {
        var plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        
        var occurencePlot = CPTScatterPlot(frame: graph.frame)
        occurencePlot.dataSource = self
        occurencePlot.delegate = self
        occurencePlot.plotSymbolMarginForHitDetection = 15
        
        graph.addPlot(occurencePlot, toPlotSpace: plotSpace)
        
        var xRange = plotSpace.xRange.mutableCopy() as! CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as! CPTMutablePlotRange
        
        plotSpace.globalXRange = CPTPlotRange(location: 0, length: hours.count)
        plotSpace.globalYRange = CPTPlotRange(location: 0, length: yMaxHours)
        xRange.length = hours.count
        yRange.length = yMaxHours
        
        if yMaxHours == 0 {
            plotSpace.globalYRange = CPTPlotRange(location: 0, length: 1)
            yRange.length = 1
        }
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange
        
        var occurenceColor = CPTColor.darkGrayColor()
        
        var occurenceLineStyle = occurencePlot.dataLineStyle.mutableCopy() as! CPTMutableLineStyle
        occurenceLineStyle.lineWidth = self.graphLineWidth
        occurenceLineStyle.lineColor = occurenceColor
        occurencePlot.dataLineStyle = occurenceLineStyle
        var occurenceSymbolLineStyle = CPTMutableLineStyle()
        occurenceSymbolLineStyle.lineColor = occurenceColor
        var occurenceSymbol = CPTPlotSymbol.ellipsePlotSymbol()
        occurenceSymbol.fill = CPTFill(color: occurenceColor)
        occurenceSymbol.lineStyle = occurenceSymbolLineStyle
        
        occurencePlot.plotSymbol = occurenceSymbol
    }
    
    func configureDayPlot() {
        var plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        
        var occurencePlot = CPTScatterPlot(frame: graph.frame)
        occurencePlot.dataSource = self
        occurencePlot.delegate = self
        occurencePlot.plotSymbolMarginForHitDetection = 15
        
        graph.addPlot(occurencePlot, toPlotSpace: plotSpace)
        
        var xRange = plotSpace.xRange.mutableCopy() as! CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as! CPTMutablePlotRange
        
        plotSpace.globalXRange = CPTPlotRange(location: 0, length: days.count)
        plotSpace.globalYRange = CPTPlotRange(location: 0, length: yMaxDays)
        
        xRange.length = days.count
        yRange.length = yMaxDays
        if yMaxDays == 0 {
            plotSpace.globalYRange = CPTPlotRange(location: 0, length: 1)
            yRange.length = 1
        }
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange
        
        var occurenceColor = CPTColor.darkGrayColor()
        var occurenceLineStyle = occurencePlot.dataLineStyle.mutableCopy() as! CPTMutableLineStyle
        occurenceLineStyle.lineWidth = self.graphLineWidth
        occurenceLineStyle.lineColor = occurenceColor
        occurencePlot.dataLineStyle = occurenceLineStyle
        var occurenceSymbolLineStyle = CPTMutableLineStyle()
        occurenceSymbolLineStyle.lineColor = occurenceColor
        var occurenceSymbol = CPTPlotSymbol.ellipsePlotSymbol()
        occurenceSymbol.fill = CPTFill(color: occurenceColor)
        occurenceSymbol.lineStyle = occurenceSymbolLineStyle
        
        occurencePlot.plotSymbol = occurenceSymbol
    }
    
    func configureStatePlot() {
        var plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        
        graphHostingView.allowPinchScaling = false
        var statesPlot = CPTBarPlot(frame: graph.frame)
        
        statesPlot.dataSource = self
        statesPlot.delegate = self
        //statesPlot.identifier = "states"
        
        statesPlot.barWidth = 0.4
        statesPlot.barOffset = 0.5
        
        graph.addPlot(statesPlot, toPlotSpace: plotSpace)
        
        var xRange = plotSpace.xRange.mutableCopy() as! CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as! CPTMutablePlotRange
        plotSpace.globalXRange = CPTPlotRange(location: 0, length: chosenBehaviourStates.count)
        plotSpace.globalYRange = CPTPlotRange(location: 0, length: yMaxStates)
        
        xRange.length = 5.5
        yRange.length = yMaxStates
        if yMaxStates == 0 {
            plotSpace.globalYRange = CPTPlotRange(location: 0, length: 1)
            yRange.length = 1
        }
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange
        
        var statesLineStyle = statesPlot.lineStyle.mutableCopy() as! CPTMutableLineStyle
        statesLineStyle.lineWidth = 1.0
        statesLineStyle.lineColor = CPTColor.blackColor()
        statesPlot.lineStyle = statesLineStyle
    }
    
    /****************** CONFIGURE AXES **************/
    func configureAxes() {
        
        switch current {
        case .HourPlot:
            configureAxesForHour()
        case .DayPlot:
            configureAxesForDay()
        case .StateChart:
            configureAxesForStates()
        }
    }
    
    func configureAxesForDay() {
        var axisTitleStyle = CPTMutableTextStyle()
        axisTitleStyle.color = CPTColor(CGColor: DayAxesBrown.CGColor)
        axisTitleStyle.fontName = "Helvetica-Bold"
        axisTitleStyle.fontSize = 12.0
        
        var axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 2.0
        axisLineStyle.lineColor = CPTColor(CGColor: DayAxesBrown.CGColor)
        
        var axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor(CGColor: DayAxesBrown.CGColor)
        axisTextStyle.fontName = "Helvetica-Bold"
        axisTextStyle.fontSize = 11.0
        
        var tickLineStyle = CPTMutableLineStyle()
        tickLineStyle.lineColor = CPTColor(CGColor: DayAxesBrown.CGColor)
        tickLineStyle.lineWidth = 2.0
        
        var gridLineStyle = CPTMutableLineStyle()
        if yMaxDays == 0 {
            gridLineStyle.lineColor = CPTColor(CGColor: graph.plotAreaFrame.fill.cgColor)
        } else {
            gridLineStyle.lineColor = CPTColor.whiteColor()
        }
        gridLineStyle.lineWidth = 1.0
        
        // 2 - Get axis set
        var axisSet = graphHostingView.hostedGraph.axisSet as! CPTXYAxisSet
        
        // 3 - Configure x-axis
        
        var x = axisSet.xAxis
    
        x.title = "Day of the Week"
        x.axisConstraints = CPTConstraints.constraintWithLowerOffset(0.0)
        x.titleTextStyle = axisTitleStyle
        x.titleOffset = 15.0
        x.axisLineStyle = axisLineStyle
        x.labelingPolicy = CPTAxisLabelingPolicy.None
        x.labelTextStyle = axisTextStyle
        x.majorTickLineStyle = axisLineStyle
        x.majorTickLength = 4.0
        x.tickDirection = CPTSign.Negative
        
        var xLabels: NSMutableSet
        var xLocations: NSMutableSet

        xLabels = NSMutableSet(capacity: days.count)
        xLocations = NSMutableSet(capacity: days.count)
        var i = 0 as CGFloat
        
        for day in days {
            var label = CPTAxisLabel(text: day, textStyle: x.labelTextStyle) as CPTAxisLabel
            var location: CGFloat = i++
            label.offset = x.majorTickLength
            label.tickLocation = location
            
            xLabels.addObject(label)
            xLocations.addObject(location)
            
        }
        
        x.axisLabels = xLabels as Set<NSObject>
        x.majorTickLocations = xLocations as Set<NSObject>
        
        // 4 - Configure y-axis
        var y = axisSet.yAxis
        
        y.title = "No. of Observations"
        
        y.axisConstraints = CPTConstraints.constraintWithLowerOffset(0.0)
        y.titleTextStyle = axisTitleStyle
        y.titleOffset = -40.0
        y.axisLineStyle = axisLineStyle
        y.majorGridLineStyle = gridLineStyle
        y.labelingPolicy = CPTAxisLabelingPolicy.None
        y.labelTextStyle = axisTextStyle
        y.labelOffset = 16.0
        y.majorTickLineStyle = axisLineStyle
        y.minorTickLineStyle = axisLineStyle
        y.majorTickLength = 4.0
        y.minorTickLength = 2.0
        y.tickDirection = CPTSign.Positive
        
        var yMax: CGFloat
        yMax = CGFloat(yMaxDays)
        
        var yLabels = NSMutableSet()
        var yMajorLocations = NSMutableSet()
        var yMinorLocations = NSMutableSet()
        
        if yMax != 0 {
            var majorIncrement = yMax/10.0 as CGFloat
            var minorIncrement = yMax/20.0 as CGFloat
            
            for var j: CGFloat = 0; j <= yMax; j += minorIncrement {
                var mod = j % majorIncrement
                
                if mod == 0 {
                    var jstr = String(format: "%.0f", j)
                    var label = CPTAxisLabel(text: jstr, textStyle: y.labelTextStyle)
                    label.offset = -y.majorTickLength - y.labelOffset
                    label.tickLocation = j
                    yLabels.addObject(label)
                    
                    yMajorLocations.addObject(j)
                    
                } else {
                    yMinorLocations.addObject(j)
                }
                
            }
        } else {
            for var j: CGFloat = 0; j <= 1; j += 1 {
                var jstr = String(format: "%.0f", j)
                var label = CPTAxisLabel(text: jstr, textStyle: y.labelTextStyle)
                label.offset = -y.majorTickLength - y.labelOffset
                label.tickLocation = j
                yLabels.addObject(label)
                
                yMajorLocations.addObject(j)
                
            }
        }
        
        y.axisLabels = yLabels as Set<NSObject>;
        y.majorTickLocations = yMajorLocations as Set<NSObject>;
        y.minorTickLocations = yMinorLocations as Set<NSObject>;

    }
    
    func configureAxesForHour() {
        var axisTitleStyle = CPTMutableTextStyle()
        axisTitleStyle.color = CPTColor(CGColor: HourAxesBrown.CGColor)
        axisTitleStyle.fontName = "Helvetica-Bold"
        axisTitleStyle.fontSize = 12.0
        
        var axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 2.0
        axisLineStyle.lineColor = CPTColor(CGColor: HourAxesBrown.CGColor)
        
        var axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor(CGColor: HourAxesBrown.CGColor)
        axisTextStyle.fontName = "Helvetica-Bold"
        axisTextStyle.fontSize = 11.0
        
        var tickLineStyle = CPTMutableLineStyle()
        tickLineStyle.lineColor = CPTColor(CGColor: HourAxesBrown.CGColor)
        tickLineStyle.lineWidth = 2.0
        
        var gridLineStyle = CPTMutableLineStyle()
        if yMaxHours == 0 {
            gridLineStyle.lineColor = CPTColor(CGColor: graph.plotAreaFrame.fill.cgColor)
        } else {
            gridLineStyle.lineColor = CPTColor.whiteColor()
        }
        gridLineStyle.lineWidth = 1.0
        
        // 2 - Get axis set
        var axisSet = graphHostingView.hostedGraph.axisSet as! CPTXYAxisSet
        
        // 3 - Configure x-axis
        
        var x = axisSet.xAxis
        
        x.title = "Hour of the Day"
        x.axisConstraints = CPTConstraints.constraintWithLowerOffset(0.0)
        x.titleTextStyle = axisTitleStyle
        x.titleOffset = 15.0
        x.axisLineStyle = axisLineStyle
        x.labelingPolicy = CPTAxisLabelingPolicy.None
        x.labelTextStyle = axisTextStyle
        x.majorTickLineStyle = axisLineStyle
        x.majorTickLength = 4.0
        x.tickDirection = CPTSign.Negative
        
        var xLabels: NSMutableSet
        var xLocations: NSMutableSet

        xLabels = NSMutableSet(capacity: hours.count)
        xLocations = NSMutableSet(capacity: hours.count)
        var i = 0 as CGFloat
        
        for hour in hours {
            var label = CPTAxisLabel(text: hour, textStyle: x.labelTextStyle) as CPTAxisLabel
            var location: CGFloat = i++
            label.offset = x.majorTickLength
            label.tickLocation = location
            
            xLabels.addObject(label)
            
            xLocations.addObject(location)
        }
        
        x.axisLabels = xLabels as Set<NSObject>
        x.majorTickLocations = xLocations as Set<NSObject>
        
        // 4 - Configure y-axis
        var y = axisSet.yAxis
        
        y.title = "No. of Observations"
        
        y.axisConstraints = CPTConstraints.constraintWithLowerOffset(0.0)
        y.titleTextStyle = axisTitleStyle
        y.titleOffset = -40.0
        y.axisLineStyle = axisLineStyle
        y.majorGridLineStyle = gridLineStyle
        y.labelingPolicy = CPTAxisLabelingPolicy.None
        y.labelTextStyle = axisTextStyle
        y.labelOffset = 16.0
        y.majorTickLineStyle = axisLineStyle
        y.minorTickLineStyle = axisLineStyle
        y.majorTickLength = 4.0
        y.minorTickLength = 2.0
        y.tickDirection = CPTSign.Positive
        
        var yMax: CGFloat
        
        yMax = CGFloat(yMaxHours)
        
        var yLabels = NSMutableSet()
        var yMajorLocations = NSMutableSet()
        var yMinorLocations = NSMutableSet()
        
        if yMax != 0 {
            var majorIncrement = yMax/10.0 as CGFloat
            var minorIncrement = yMax/20.0 as CGFloat
            
            for var j: CGFloat = 0; j <= yMax; j += minorIncrement {
                var mod = j % majorIncrement
                
                if mod == 0 {
                    var jstr = String(format: "%.0f", j)
                    var label = CPTAxisLabel(text: jstr, textStyle: y.labelTextStyle)
                    label.offset = -y.majorTickLength - y.labelOffset
                    label.tickLocation = j
                    yLabels.addObject(label)
                    
                    yMajorLocations.addObject(j)
                    
                } else {
                    yMinorLocations.addObject(j)
                }
                
            }
        } else {
            for var j: CGFloat = 0; j <= 1; j += 1 {
                var jstr = String(format: "%.0f", j)
                var label = CPTAxisLabel(text: jstr, textStyle: y.labelTextStyle)
                label.offset = -y.majorTickLength - y.labelOffset
                label.tickLocation = j
                yLabels.addObject(label)
                
                yMajorLocations.addObject(j)
                
            }
        }
        
        y.axisLabels = yLabels as Set<NSObject>;
        y.majorTickLocations = yMajorLocations as Set<NSObject>;
        y.minorTickLocations = yMinorLocations as Set<NSObject>;

    }
    
    func configureAxesForStates() {
        var axisTitleStyle = CPTMutableTextStyle()
        axisTitleStyle.color = CPTColor(CGColor: StatesAxesBrown.CGColor)
        axisTitleStyle.fontName = "Helvetica-Bold"
        axisTitleStyle.fontSize = 12.0
        
        var axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 2.0
        axisLineStyle.lineColor = CPTColor(CGColor: StatesAxesBrown.CGColor)
        
        var axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor(CGColor: StatesAxesBrown.CGColor)
        axisTextStyle.fontName = "Helvetica-Bold"
        axisTextStyle.fontSize = 11.0
        
        var tickLineStyle = CPTMutableLineStyle()
        tickLineStyle.lineColor = CPTColor(CGColor: StatesAxesBrown.CGColor)
        tickLineStyle.lineWidth = 2.0
        
        var gridLineStyle = CPTMutableLineStyle()
        if yMaxStates == 0 {
            gridLineStyle.lineColor = CPTColor(CGColor: graph.plotAreaFrame.fill.cgColor)
        } else {
            gridLineStyle.lineColor = CPTColor.whiteColor()
        }
        gridLineStyle.lineWidth = 1.0
        
        // 2 - Get axis set
        var axisSet = graphHostingView.hostedGraph.axisSet as! CPTXYAxisSet
        
        // 3 - Configure x-axis
        
        var x = axisSet.xAxis
        
        x.title = "Behaviour States"
        x.axisConstraints = CPTConstraints.constraintWithLowerOffset(0.0)
        x.titleTextStyle = axisTitleStyle
        x.titleOffset = 15.0
        x.axisLineStyle = axisLineStyle
        x.labelingPolicy = CPTAxisLabelingPolicy.None
        x.labelTextStyle = axisTextStyle
        x.majorTickLineStyle = axisLineStyle
        x.majorTickLength = 4.0
        x.tickDirection = CPTSign.Negative
        
        var xLabels: NSMutableSet
        var xLocations: NSMutableSet
        
        xLabels = NSMutableSet(capacity: chosenBehaviourStates.count)
        xLocations = NSMutableSet(capacity: chosenBehaviourStates.count)
        var i = 0.5 as CGFloat
        
        for state in chosenBehaviourStates {
            var label = CPTAxisLabel(text: state.name, textStyle: x.labelTextStyle) as CPTAxisLabel
            var location: CGFloat = i++
            label.offset = x.majorTickLength
            label.tickLocation = location
            
            xLabels.addObject(label)
            
            xLocations.addObject(location)
            
        }
        
        x.axisLabels = xLabels as Set<NSObject>
        x.majorTickLocations = xLocations as Set<NSObject>
        
        // 4 - Configure y-axis
        var y = axisSet.yAxis
        
        y.title = "No. of Behaviour States"
        
        y.axisConstraints = CPTConstraints.constraintWithLowerOffset(0.0)
        y.titleTextStyle = axisTitleStyle
        y.titleOffset = -40.0
        y.axisLineStyle = axisLineStyle
        y.majorGridLineStyle = gridLineStyle
        y.labelingPolicy = CPTAxisLabelingPolicy.None
        y.labelTextStyle = axisTextStyle
        y.labelOffset = 16.0
        y.majorTickLineStyle = axisLineStyle
        y.minorTickLineStyle = axisLineStyle
        y.majorTickLength = 4.0
        y.minorTickLength = 2.0
        y.tickDirection = CPTSign.Positive
        
        var yMax: CGFloat
        yMax = CGFloat(yMaxStates)
        
        var yLabels = NSMutableSet()
        var yMajorLocations = NSMutableSet()
        var yMinorLocations = NSMutableSet()
        
        if yMax != 0 {
            var majorIncrement = yMax/10.0 as CGFloat
            var minorIncrement = yMax/20.0 as CGFloat
            
            for var j: CGFloat = 0; j <= yMax; j += minorIncrement {
                var mod = j % majorIncrement
                
                if mod == 0 {
                    var jstr = String(format: "%.0f", j)
                    var label = CPTAxisLabel(text: jstr, textStyle: y.labelTextStyle)
                    label.offset = -y.majorTickLength - y.labelOffset
                    label.tickLocation = j
                    yLabels.addObject(label)
                    
                    yMajorLocations.addObject(j)
                    
                } else {
                    yMinorLocations.addObject(j)
                }
                
            }
        } else {
            for var j: CGFloat = 0; j <= 1; j += 1 {
                var jstr = String(format: "%.0f", j)
                var label = CPTAxisLabel(text: jstr, textStyle: y.labelTextStyle)
                label.offset = -y.majorTickLength - y.labelOffset
                label.tickLocation = j
                yLabels.addObject(label)
                
                yMajorLocations.addObject(j)
                
            }
        }
        
        y.axisLabels = yLabels as Set<NSObject>;
        y.majorTickLocations = yMajorLocations as Set<NSObject>;
        y.minorTickLocations = yMinorLocations as Set<NSObject>;

    }
    
    
    /******************** DATASOURCE AND DELEGATE METHODS ******************/
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        switch current {
        case .DayPlot:
                return UInt(numberOfDayOccurences.count)
        case .HourPlot:
                return UInt(numberOfHourOccurences.count)
        case .StateChart:
                return UInt(numberOfStatesOccurences.count)
        }
        
    }
    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject! {
        var valueCount: UInt
        
        switch current {
        case .DayPlot:
             valueCount = UInt(numberOfDayOccurences.count)
        case .HourPlot:
            valueCount =  UInt(numberOfHourOccurences.count)
        case .StateChart:
            valueCount =  UInt(numberOfStatesOccurences.count)
        }
        
        switch fieldEnum {
        case UInt(CPTScatterPlotField.X.rawValue):
                if idx < valueCount {
                    return NSNumber(unsignedLong: idx)
                }
            
        case UInt(CPTScatterPlotField.Y.rawValue):
            switch current {
            case .DayPlot:
                if numberOfDayOccurences != nil {
                    return numberOfDayOccurences[Int(idx)]
                }
            case .HourPlot:
                if numberOfHourOccurences != nil {
                    return numberOfHourOccurences[Int(idx)]
                }
            case .StateChart:
                if numberOfStatesOccurences != nil {
                    return numberOfStatesOccurences[Int(idx)]
                }
            }
        default:
            break
        }
        
        var x = 0 as NSDecimalNumber
        return x
    }

    func barPlot(plot: CPTBarPlot!, barWasSelectedAtRecordIndex idx: UInt) {

        var x = Double(idx) + 0.5
        var plotYValue = yMaxStates - numberOfStatesOccurences[Int(idx)]
        
        var plotPoint = [x, Double(plotYValue)]
        
        var pos = plot.plotSpace.plotAreaViewPointForPlotPoint(plotPoint)

        var popoverContent = PopoverLabelViewController(nibName: "PopoverLabelView", bundle: nil)
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(70,30)
        popover!.delegate = self
        
        var anchorPoint  = plot.graph.convertPoint(CGPointMake(pos.x, pos.y), fromLayer: plot.graph.plotAreaFrame.plotArea)
        
        var popoverAnchor = CGRectMake(anchorPoint.x, anchorPoint.y, 0, 0)
        popover!.sourceView = self.graphHostingView
        popover!.sourceRect = popoverAnchor
        popover!.permittedArrowDirections = UIPopoverArrowDirection.Up
        
        self.presentViewController(popoverContent, animated: true, completion: nil)
        var final = String(numberOfStatesOccurences[Int(idx)])
        popoverContent.setLabelMessage(final)
        plot.graph.reloadData()
    }
    
    func barFillForBarPlot(barPlot: CPTBarPlot!, recordIndex idx: UInt) -> CPTFill! {
        
        var chosenColor = colors[Int(idx)]
        return CPTFill(color: CPTColor(CGColor: chosenColor.CGColor))
    }
    
    func symbolForScatterPlot(plot: CPTScatterPlot!, recordIndex idx: UInt) -> CPTPlotSymbol! {
        
        var symbol = CPTPlotSymbol()
        symbol.symbolType = CPTPlotSymbolType.Ellipse
        var symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineWidth = 2.0
        
        if selectedPoint == Int(idx) {
            symbolLineStyle.lineColor = CPTColor(CGColor: PlotSelectRed.CGColor)
        } else {
            symbolLineStyle.lineColor = CPTColor.blackColor()
        }
        
        symbol.lineStyle = symbolLineStyle
        
        return symbol
    }

    
    func scatterPlot(plot: CPTScatterPlot!, plotSymbolWasSelectedAtRecordIndex idx: UInt) {
        
        selectedPoint = Int(idx)
        
        // Determine point of symbol in plot coordinates
        var x: Double!
        var y: Double!
        var final: String!
        switch current {
        case .DayPlot:
            x = Double(idx)
            y = Double(yMaxDays - numberOfDayOccurences[Int(idx)])
            final = String(numberOfDayOccurences[Int(idx)])
            
        case .HourPlot:
            x = Double(idx)
            y = Double(yMaxHours - numberOfHourOccurences[Int(idx)])
            final = String(numberOfHourOccurences[Int(idx)])
        default:
            break
        }
        
        var plotPoint = [x, y]
        
        var pos = plot.plotSpace.plotAreaViewPointForPlotPoint(plotPoint)
        
        popoverContent = PopoverLabelViewController(nibName: "PopoverLabelView", bundle: nil)
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(70,30)
        popover!.delegate = self
        
        var anchorPoint  = plot.graph.convertPoint(CGPointMake(pos.x, pos.y), fromLayer: plot.graph.plotAreaFrame.plotArea)
        
        var popoverAnchor = CGRectMake(anchorPoint.x, anchorPoint.y, 0, 0)
        popover!.sourceView = self.graphHostingView
        popover!.sourceRect = popoverAnchor
        popover!.permittedArrowDirections = UIPopoverArrowDirection.Up
        
        self.presentViewController(popoverContent, animated: true, completion: nil)
        popoverContent.setLabelMessage(final)
        plot.graph.reloadData()
    }

    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
            updateGraphDataAfterDeSelect()
        
    }
    
    func rotated() {
        self.dismissViewControllerAnimated(false, completion: nil)
        updateGraphDataAfterDeSelect()
    }
    
    func updateGraphDataAfterDeSelect() {
        selectedPoint = -1
        graph.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



