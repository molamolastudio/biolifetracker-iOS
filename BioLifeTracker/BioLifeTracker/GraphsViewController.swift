//
//  GraphControllers.swift
//  BioLifeTracker
//
//  Created by Haritha on 26/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation
import UIKit

class GraphsViewController:  UIViewController, CPTPlotDataSource, CPTBarPlotDataSource, CPTBarPlotDelegate, CPTScatterPlotDelegate, CPTScatterPlotDataSource, CPTPlotSpaceDelegate{
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

//    @IBOutlet var hostingViews: [CPTGraphHostingView]!
//
    @IBOutlet weak var graphHostingView: CPTGraphHostingView!
    
//    @IBOutlet weak var hourPlotHostingView: CPTGraphHostingView!
//    @IBOutlet weak var stateChartHostingView: CPTGraphHostingView!
//    @IBOutlet weak var dayPlotHostingView: CPTGraphHostingView!
    
    var projectInstance: Project!
    
    var dayGraph: CPTXYGraph = CPTXYGraph(frame: CGRectZero)
    var hourGraph: CPTXYGraph = CPTXYGraph(frame: CGRectZero)
    var statesGraph: CPTXYGraph = CPTXYGraph(frame: CGRectZero)
    var graphLineWidth: CGFloat = 2.5
    
    // default setting
    var current: GraphType = .HourPlot
    
    var yMaxHours = 0
    var yMaxDays = 0
    var yMaxStates = 0

    //x axis possiblities
    var days = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
    var hours = ["6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm"]
    
    var allBehaviourStates: [BehaviourState]!
    var chosenBehaviourStates: [BehaviourState]!
    
    //y axis -- number of occurences
    var numberOfDayOccurences: [Int]!
    var numberOfHourOccurences: [Int]!
    var numberOfStatesOccurences: [Int]!
    
    var chosenUsers: [User]!
    var allUsers: [User]!
    
    var chosenSessions: [Session]!
    var allSessions: [Session]!
    
    var symbolTextAnnotation: CPTPlotSpaceAnnotation!
    var AliceBlue = UIColor(red: 228.0/255.0, green: 241.0/255.0, blue: 254.0/255.0, alpha: 1)
    var HummingBird = UIColor(red: 197.0/255.0, green: 239.0/255.0, blue: 247.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        initConditions()
        prepareNumberOfOccurances()
        drawGraph()
        
        
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
    func drawGraph() {
        switch current {
        case .DayPlot:
            configureGraph(&dayGraph)
            configurePlots(&dayGraph)
        case .HourPlot:
            configureGraph(&hourGraph)
            configurePlots(&hourGraph)
        case .StateChart:
            configureGraph(&statesGraph)
            configurePlots(&statesGraph)
        }

        configureAxes()
        
        graphHostingView.hostedGraph.reloadData()
//        if chartByState {
//            configureGraph()
//            configureBarPlots()
//            configureAxes()
//        } else {
//            configureGraph()
//            configurePlots()
//            configureAxes()
//            
//        }
//        hostingView.hostedGraph.reloadData()
    }
    
    func toggleGraph(type: GraphType) {
        current = type
    }
    
    func prepareNumberOfOccurances() {
        var occurences = projectInstance.getObservations(sessions: chosenSessions, users: chosenUsers, behaviourStates: chosenBehaviourStates)
        
        if current == GraphType.StateChart {
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
        } else {
            //for number of days
            numberOfDayOccurences = [Int](count: days.count, repeatedValue:0)
            
            //for number of hours
            numberOfHourOccurences = [Int](count: hours.count, repeatedValue:0)
        
            for occurence in occurences {
                if current == GraphType.DayPlot {
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
                } else {
                
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
    
    func configureGraph(inout graph: CPTXYGraph) {
    
        graphHostingView.allowPinchScaling = true
        graph = CPTXYGraph(frame: CGRectZero)
        graph.applyTheme(CPTTheme(named: kCPTPlainWhiteTheme))
        graphHostingView.hostedGraph = graph
    
        graph.plotAreaFrame.paddingLeft = 40
        graph.plotAreaFrame.paddingRight = 40
        graph.plotAreaFrame.paddingBottom = 40
        graph.plotAreaFrame.paddingTop = 40
        
        graph.plotAreaFrame.fill = CPTFill(color: CPTColor(CGColor: HummingBird.CGColor))
        graph.plotAreaFrame.plotArea.fill = CPTFill(color: CPTColor(CGColor: HummingBird.CGColor))
        graph.fill = CPTFill(color: CPTColor(CGColor: AliceBlue.CGColor))
        
        
        var plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.allowsUserInteraction = true
        plotSpace.delegate = self
        
    }
    
    func configurePlots(inout graph: CPTXYGraph) {
        var plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        
        if current != .StateChart {
            var occurencePlot = CPTScatterPlot(frame: graph.frame)
            occurencePlot.dataSource = self
            occurencePlot.delegate = self
            occurencePlot.plotSymbolMarginForHitDetection = 10
            var occurenceColor = CPTColor.darkGrayColor()
            
            graph.addPlot(occurencePlot, toPlotSpace: plotSpace)
            
            var xRange = plotSpace.xRange.mutableCopy() as! CPTMutablePlotRange
            var yRange = plotSpace.yRange.mutableCopy() as! CPTMutablePlotRange
            if current == .DayPlot {
                plotSpace.globalXRange = CPTPlotRange(location: 0, length: days.count)
                plotSpace.globalYRange = CPTPlotRange(location: 0, length: yMaxDays)
                xRange.length = days.count
                yRange.length = yMaxDays
            } else {
                plotSpace.globalXRange = CPTPlotRange(location: 0, length: hours.count)
                plotSpace.globalYRange = CPTPlotRange(location: 0, length: yMaxHours)
                xRange.length = hours.count
                yRange.length = yMaxHours
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
        } else {
            graphHostingView.allowPinchScaling = false
            var statesPlot = CPTBarPlot(frame: graph.frame)
            
            statesPlot.dataSource = self
            statesPlot.delegate = self
            //statesPlot.identifier = "states"
            
            statesPlot.barWidth = 0.5
            statesPlot.barOffset = 0.5
            
            
            graph.addPlot(statesPlot, toPlotSpace: plotSpace)
            
            var xRange = plotSpace.xRange.mutableCopy() as! CPTMutablePlotRange
            var yRange = plotSpace.yRange.mutableCopy() as! CPTMutablePlotRange
            plotSpace.globalXRange = CPTPlotRange(location: 0, length: chosenBehaviourStates.count)
            plotSpace.globalYRange = CPTPlotRange(location: 0, length: yMaxStates)

            xRange.length = 5.5
            yRange.length = yMaxStates
            
            plotSpace.xRange = xRange
            plotSpace.yRange = yRange
            
            
            
            var statesLineStyle = statesPlot.lineStyle.mutableCopy() as! CPTMutableLineStyle
            statesLineStyle.lineWidth = self.graphLineWidth
            statesLineStyle.lineColor = CPTColor.lightGrayColor()
            statesPlot.lineStyle = statesLineStyle
            
        }
        
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
        var axisSet = graphHostingView.hostedGraph.axisSet as! CPTXYAxisSet
        
        // 3 - Configure x-axis
        
        var x = axisSet.xAxis
        
        switch current {
        case .HourPlot:
            x.title = "Hour of the Day"
        case .DayPlot:
            x.title = "Day of the Week"
        case .StateChart:
            x.title = "Behaviour States"
        }
        
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
        
        switch current {
        case .HourPlot:
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
        case .DayPlot:
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
        case .StateChart:
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
        
        if current == GraphType.StateChart {
            y.title = "No. of Behaviour States"
        } else {
            y.title = "No. of Observations"
        }
        
        y.axisConstraints = CPTConstraints.constraintWithLowerOffset(0.0)
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
        
        var yMax: CGFloat
        
        switch current {
        case .HourPlot:
            yMax = CGFloat(yMaxHours)
        case .DayPlot:
            yMax = CGFloat(yMaxDays)
        case .StateChart:
            yMax = CGFloat(yMaxStates)
        }
        
        var yLabels = NSMutableSet()
        var yMajorLocations = NSMutableSet()
        var yMinorLocations = NSMutableSet()
        
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
                break;
        case UInt(CPTScatterPlotField.Y.rawValue):
            //if plot.identifier != nil {
                //if plot.identifier.isEqual("occurence") {
                
            switch current {
            case .DayPlot:
                return numberOfDayOccurences[Int(idx)]
            case .HourPlot:
                return numberOfHourOccurences[Int(idx)]
            case .StateChart:
                return numberOfStatesOccurences[Int(idx)]
            }
                
                //}else if plot.identifier.isEqual("states") {
                 //   return arr[Int(idx)]
                //}
            //}
        default:
            break;
        }
        
        var x = 0 as NSDecimalNumber
        return x
    }
    
    func plotSpace(space: CPTPlotSpace!, willChangePlotRangeTo newRange: CPTPlotRange!, forCoordinate coordinate: CPTCoordinate) -> CPTPlotRange! {
        if let range = newRange {
            switch current{
            case .HourPlot:
                if coordinate == CPTCoordinate.X {
                    var limit = Double(hours.count/2)
                    if range.lengthDouble < limit   {
                        return CPTPlotRange(location: range.locationDouble , length: limit)
                    }
                } else {
                    var limit = Double(yMaxHours/2)
                    if range.lengthDouble < limit   {
                        return CPTPlotRange(location: range.locationDouble , length: limit)
                    }
                }
                break
            case .DayPlot:
                if coordinate == CPTCoordinate.X {
                    var limit = Double(days.count/2)
                    if range.lengthDouble < limit   {
                        return CPTPlotRange(location: range.locationDouble , length: limit)
                    }
                } else {
                    var limit = Double(yMaxDays/2)
                    if range.lengthDouble < limit   {
                        return CPTPlotRange(location: range.locationDouble , length: limit)
                    }
                }
                break
            default:
                break
            }
        }
        return newRange
        
    }
    
    func barPlot(plot: CPTBarPlot!, barWasSelectedAtRecordIndex idx: UInt) {
        
//        var plotXValue = chosenBehaviourStates[Int(idx)]
        if let bar = plot {
            
            
            
            var axis = plot.graph.axisSet as! CPTXYAxisSet
            var x = axis.xAxis.majorTickLocations.
            
        var plotYValue = numberOfStatesOccurences[Int(idx)]
        
        var plotSpace = plot.graph.defaultPlotSpace
        
        var cgPlotPoint = CGPointMake(plotXValue.floatValue, plotYValue.floatValue)
        
        
            CGPoint cgPlotAreaPoint =
                [graph convertPoint:cgPlotPoint toLayer:graph.plotAreaFrame.plotArea];
            
            NSDecimal plotAreaPoint[2];
            plotAreaPoint[CPTCoordinateX] =
                CPTDecimalFromFloat(cgPlotAreaPoint.x);
            plotAreaPoint[CPTCoordinateY] =
                CPTDecimalFromFloat(cgPlotAreaPoint.y);
            
            CGPoint dataPoint = [plotSpace
                
                
                plotAreaViewPointForPlotPoint:plotAreaPoint];
            NSLog(@"datapoint (CGPoint) coordinates tapped: %@",NSStringFromCGPoint(dataPoint));
            
            GrowthChartInfoTableViewController *infoViewController = [self.storyboard
            instantiateViewControllerWithIdentifier:@"GrowthChartInfo"];
            
            
            
            self.popover = nil;
            self.popover = [[UIPopoverController alloc]
            
            
            initWithContentViewController:infoViewController];
            self.popover.popoverContentSize = CGSizeMake(250, 200);
            self.popover.delegate = self;
            CGRect popoverAnchor =
            CGRectMake(dataPoint.x + graph.paddingLeft,
            dataPoint.y - graph.paddingTop + graph.paddingBottom,
            (CGFloat)1.0f, (CGFloat)1.0f);
            
            [self.popover presentPopoverFromRect:popoverAnchor
            inView:self.view
            permittedArrowDirections:UIPopoverArrowDirectionUp
            animated:YES];
        }
    }
    
    func barFillForBarPlot(barPlot: CPTBarPlot!, recordIndex idx: UInt) -> CPTFill! {
        return CPTFill(color: CPTColor.blueColor())
    }
    
    func symbolForScatterPlot(plot: CPTScatterPlot!, recordIndex idx: UInt) -> CPTPlotSymbol! {
        
        var symbol = CPTPlotSymbol()
        symbol.symbolType = CPTPlotSymbolType.Ellipse
        var symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineWidth = 2.0
        symbolLineStyle.lineColor = CPTColor.blackColor()
        
        symbol.lineStyle = symbolLineStyle
        
        return symbol
    }
    
    
    func scatterPlot(plot: CPTScatterPlot!, plotSymbolWasSelectedAtRecordIndex idx: UInt) {

        if (self.symbolTextAnnotation != nil) {
            plot.graph.plotAreaFrame.plotArea.removeAllAnnotations()
            self.symbolTextAnnotation = nil
            
        }
        
        // Setup a style for the annotation
        var hitAnnotationTextStyle = CPTMutableTextStyle()
        hitAnnotationTextStyle.color = CPTColor.redColor()
        hitAnnotationTextStyle.fontSize = 16.0
        hitAnnotationTextStyle.fontName = "Helvetica-Bold"
        
        // Determine point of symbol in plot coordinates
        var x: NSNumber!
        var y: NSNumber!
        var text: String!
        switch current {
        case .DayPlot:
            x = Int(idx) as NSNumber
            y = x
            
        case .HourPlot:
            x = Int(idx) as NSNumber
            y = x
            
        default:
            break
        }
        
        var anchorPoint = [x, y]
        
        // Add annotation
        
        // Now add the annotation to the plot area
        
        var ystr = String(stringInterpolationSegment: y)
        text = ystr
        
        var textLayer = CPTTextLayer(text: text, style: hitAnnotationTextStyle)
//        var bg = CPTImage(CGImage: UIImage(named: "blah")?.CGImage)
//        textLayer.paddingLeft   = 2.0;
//        textLayer.paddingTop    = 2.0;
//        textLayer.paddingRight  = 2.0;
//        textLayer.paddingBottom = 2.0;
        
        self.symbolTextAnnotation = CPTPlotSpaceAnnotation(plotSpace: plot.graph.plotSpaceAtIndex(idx) , anchorPlotPoint: anchorPoint)
        
        self.symbolTextAnnotation.contentLayer = textLayer;
        //symbolTextAnnotation.contentAnchorPoint = CGPointMake(5, 0)
        var pos = plot.plotAreaPointOfVisiblePointAtIndex(idx)
        self.symbolTextAnnotation.displacement = CGPointMake(pos.x, pos.y + 10)
        
        
        plot.graph.plotAreaFrame.plotArea.addAnnotation(symbolTextAnnotation)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



