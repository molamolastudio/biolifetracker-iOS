//
//  GraphControllers.swift
//  BioLifeTracker
//
//  Created by Haritha on 26/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

class GraphsViewController:  UIViewController, CPTPlotDataSource, CPTBarPlotDataSource, CPTBarPlotDelegate, CPTPlotDelegate {
    var delegate: GraphsViewControllerDelegate!
    

    @IBOutlet weak var graphSwitch: UISegmentedControl!
    
    @IBOutlet weak var hostingView: CPTGraphHostingView!

    var projectInstance: Project!
    
    var graph: CPTXYGraph!
    var graphLineWidth: CGFloat = 2.5
    
    var plotByDay = false
    var plotByHour = true // default setting
    var chartByState = false
    
    var yMaxHours = 0
    var yMaxDays = 0
    var yMaxStates = 0
    
    var barOfBehaviourStates = false

    //x axis possiblities
    var days = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
    var hours = ["6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm"]
    
    //constants
    var Sunday = 6
    var Monday = 0
    var Tuesday = 1
    var Wednesday = 2
    var Thursday = 3
    var Friday = 4
    var Saturday = 5
    var sixam = 0
    var sevenam = 1
    var eightam = 2
    var nineam = 3
    var tenam = 4
    var elevenam = 5
    var twelvepm = 6
    var onepm = 7
    var twopm = 8
    var threepm = 9
    var fourpm = 10
    var fivepm = 11
    var sixpm = 12
    var sevenpm = 13
    var eightpm = 14
    var ninepm = 15
    var tenpm = 16
    
    var allBehaviourStates: [BehaviourState]!
    var chosenBehaviourStates: [BehaviourState]!
    
    //y axis -- number of occurences
    var numberOfOccurences: [Int]!
    
    var chosenUsers: [User]!
    var allUsers: [User]!
    
    var chosenSessions: [Session]!
    var allSessions: [Session]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var stub = ProjectStub()
        projectInstance = stub.project
        initConditions()
        if plotByDay {
            configureGraph()
        } else if plotByHour {
            configureGraph()
            configurePlots()
            configureAxes()
        } else {
            configureGraph()
            configureBarPlots()
            configureAxes()
        }
        
    }
    
    /********************* SET INITIAL DATA **********************/
    //Gets the data that conform to what the user provided and 
    //sets them as conditions for the the graph
    func initConditions() {
        getAllUsers()
        getAllSessions()
        getAllBehaviourStates()
        
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
    
    func getAllUsers() {
        allUsers = projectInstance.members
        chosenUsers = allUsers
    }
    
    func getAllSessions() {
        allSessions = projectInstance.sessions
        chosenSessions = allSessions
    }
    
    func getAllBehaviourStates() {
        allBehaviourStates = projectInstance.ethogram.behaviourStates
        chosenBehaviourStates = allBehaviourStates
    }
    
    
    /*********************** UPDATE FOR GRAPH ********************/
    
    func prepareNumberOfOccurances() {
        var occurences = projectInstance.getObservations(sessions: chosenSessions, users: chosenUsers, behaviourStates: chosenBehaviourStates)
        
        if plotByDay {
            // 7 for number of days
            numberOfOccurences = [Int](count: 7, repeatedValue:0)
            
            for occurence in occurences {
                var day = getDayOfWeek(occurence.timestamp)
                numberOfOccurences[day] += 1
                
                //check and update max value of y axis
                var count = numberOfOccurences[day]
                if count > yMaxDays {
                    var max = count/10
                    max = max+1
                    max = max*10
                    yMaxDays = max
                }
                
            }
            
        } else if plotByHour {
            //13 for number of hours
            numberOfOccurences = [Int](count: 13, repeatedValue:0)
            
            for occurence in occurences {
                var hour = getHourOfDay(occurence.timestamp)
                numberOfOccurences[hour] += 1
                
                // check and update max value of y axis
                var count = numberOfOccurences[hour]
                if count > yMaxHours {
                    var max = count/10
                    max = max+1
                    max = max*10
                    yMaxHours = max
                }
            }
        } else {
            var numPerBS = projectInstance.getObservationsPerBS()
            
            for BS in chosenBehaviourStates {
                
                if let count = numPerBS[BS.name] {
                    numberOfOccurences.append(count)
                    
                    // check and update max value of y axis
                    if count > yMaxStates {
                        var max = count/10
                        max = max+1
                        max = max*10
                        yMaxStates = max
                    }
                    
                } else {
                    numberOfOccurences.append(0)
                }
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
            return Sunday
        case 2:
            return Monday
        case 3:
            return Tuesday
        case 4:
            return Wednesday
        case 5:
            return Thursday
        case 6:
            return Friday
        case 7:
            return Saturday
        default:
            return 7
        }
    }
    
    func getHourOfDay(date: NSDate) -> Int {
        var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        var components = calendar?.components(.CalendarUnitHour, fromDate: date)
        var hour = components?.hour
        
        switch hour! {
        case 6:
            return sixam
        case 7:
            return sevenam
        case 8:
            return eightam
        case 9:
            return nineam
        case 10:
            return tenam
        case 11:
            return elevenam
        case 12:
            return twelvepm
        case 13:
            return onepm
        case 14:
            return twopm
        case 15:
            return threepm
        case 16:
            return fourpm
        case 17:
            return fivepm
        case 18:
            return sixpm
        case 19:
            return sevenpm
        case 20:
            return eightpm
        case 21:
            return ninepm
        case 22:
            return tenpm
        default:
            if hour < 6 {
                return sixam
            } else {
                return tenpm
            }
        }

    }
    
    /********************** CONFIGURE GRAPHS ****************/
    func configureGraph() {

        self.hostingView.allowPinchScaling = true
        
        self.graph = CPTXYGraph(frame: CGRectZero)
        graph.applyTheme(CPTTheme(named: kCPTPlainWhiteTheme))
        self.hostingView.hostedGraph = graph
        
        graph.plotAreaFrame.paddingLeft = 40
        graph.plotAreaFrame.paddingRight = 40
        graph.plotAreaFrame.paddingBottom = 40
        graph.plotAreaFrame.paddingTop = 40
        
        
        var plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.allowsUserInteraction = true
        
    }
    
    func configurePlots() {
        var plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        var occurencePlot = CPTScatterPlot(frame: graph.frame)
        occurencePlot.dataSource = self
        occurencePlot.identifier = "occurence"
        var occurenceColor = CPTColor.darkGrayColor()
        
        graph.addPlot(occurencePlot, toPlotSpace: plotSpace)
        
        var xRange = plotSpace.xRange.mutableCopy() as! CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as! CPTMutablePlotRange
        if plotByHour {
            xRange.length = hours.count
            yRange.length = yMaxHours
        } else {
            xRange.length = days.count
            yRange.length = yMaxDays
        }
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange
        
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
    
    func configureBarPlots() {
        var plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        var statesPlot = CPTBarPlot(frame: graph.frame)
        
        statesPlot.dataSource = self
        statesPlot.identifier = "states"

        statesPlot.barWidth = 0.5
        statesPlot.barOffset = 0.5
        
        graph.addPlot(statesPlot, toPlotSpace: plotSpace)
        
        var xRange = plotSpace.xRange.mutableCopy() as! CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as! CPTMutablePlotRange
  
        xRange.length = chosenBehaviourStates.count
        yRange.length = yMaxStates
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange
        
        var statesLineStyle = statesPlot.lineStyle.mutableCopy() as! CPTMutableLineStyle
        statesLineStyle.lineWidth = self.graphLineWidth
        statesLineStyle.lineColor = CPTColor.lightGrayColor()
        statesPlot.lineStyle = statesLineStyle
    }

    
    func configureAxes() {
        
        var axisTitleStyle = CPTMutableTextStyle()
        axisTitleStyle.color = CPTColor.blackColor()
        axisTitleStyle.fontName = "Helvetica-Bold"
        axisTitleStyle.fontSize = 12.0
        
        var axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 2.0
        axisLineStyle.lineColor = CPTColor.blackColor()
        
        var axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor.blackColor()
        axisTextStyle.fontName = "Helvetica-Bold"
        axisTextStyle.fontSize = 11.0
        
        var tickLineStyle = CPTMutableLineStyle()
        tickLineStyle.lineColor = CPTColor.blackColor()
        tickLineStyle.lineWidth = 2.0
        
        var gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = CPTColor.whiteColor()
        gridLineStyle.lineWidth = 1.0
        
        // 2 - Get axis set
        var axisSet = self.hostingView.hostedGraph.axisSet as! CPTXYAxisSet
        
        // 3 - Configure x-axis
        
        var x = axisSet.xAxis
        
        if plotByHour {
            x.title = "Hour of the Day"
        } else if plotByDay {
            x.title = "Day of the Week"
        } else {
            x.title = "Behaviour States"
        }
        
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
        
        if plotByHour {
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
        } else if plotByDay {
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
        } else {
            
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

        }
        
        x.axisLabels = xLabels as Set<NSObject>
        x.majorTickLocations = xLocations as Set<NSObject>
        
        // 4 - Configure y-axis
        var y = axisSet.yAxis
        if chartByState {
            y.title = "No. of Behaviour States"
        } else {
            y.title = "No. of Observations"
        }
        y.titleTextStyle = axisTitleStyle
        y.titleOffset = -40.0
        y.axisLineStyle = axisLineStyle
        y.majorGridLineStyle = gridLineStyle
        y.labelingPolicy = CPTAxisLabelingPolicy.None
        y.labelTextStyle = axisTextStyle
        y.labelOffset = 16.0
        y.majorTickLineStyle = axisLineStyle
        y.majorTickLength = 4.0
        y.minorTickLength = 2.0
        y.tickDirection = CPTSign.Positive
        
        var majorIncrement = 1.0 as CGFloat
        var minorIncrement = 0.5 as CGFloat
        
        var yMax: CGFloat
        if plotByHour {
            yMax = CGFloat(yMaxHours)
        } else if plotByDay {
            yMax = CGFloat(yMaxDays)
        } else {
            yMax = CGFloat(yMaxStates)
        }
        
        var yLabels = NSMutableSet()
        var yMajorLocations = NSMutableSet()
        var yMinorLocations = NSMutableSet()
        
        for var j: CGFloat = 0; j <= yMax; j += minorIncrement {
            var mod = j % majorIncrement
            
            if mod == 0 {
                var jstr = j.description
                var label = CPTAxisLabel(text: jstr, textStyle: y.labelTextStyle)
                label.offset = -y.majorTickLength - y.labelOffset
                label.tickLocation = j
                yLabels.addObject(label)
                
                yMajorLocations.addObject(j)
                
            } else {
                yMinorLocations.addObject(j)
            }
            
        }
        y.axisLabels = yLabels as Set<NSObject>;    
        y.majorTickLocations = yMajorLocations as Set<NSObject>;
        y.minorTickLocations = yMinorLocations as Set<NSObject>;
    }
    
    /******************** DATASOURCE AND DELEGATE METHODS ******************/
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        
        return UInt(numberOfOccurences.count)
        
    }
    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject! {
        var valueCount = UInt(numberOfOccurences.count)
        switch fieldEnum {
        case UInt(CPTScatterPlotField.X.rawValue):
                if idx < valueCount {
                    return NSNumber(unsignedLong: idx)
                }
                break;
        case UInt(CPTScatterPlotField.Y.rawValue):
            if plot.identifier != nil {
                //if plot.identifier.isEqual("occurence") {
                return numberOfOccurences[Int(idx)]
                //}else if plot.identifier.isEqual("states") {
                 //   return arr[Int(idx)]
                //}
            }
            break;
        default:
            break;
        }
        
        var x = 0 as NSDecimalNumber
        return x
    }
    
    func barPlot(plot: CPTBarPlot!, barWasSelectedAtRecordIndex idx: UInt) {
        // show information
    }
    
    func barFillForBarPlot(barPlot: CPTBarPlot!, recordIndex idx: UInt) -> CPTFill! {
        return CPTFill(color: CPTColor.blueColor())
    }
    
    @IBAction func graphIndexChanged(sender: AnyObject) {
        switch graphSwitch.selectedSegmentIndex {
        case 0:
            println("hour")
        case 1:
            println("day")
        case 2:
            println("states")
            // only view behaviourstate tables
        default:
            break
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



