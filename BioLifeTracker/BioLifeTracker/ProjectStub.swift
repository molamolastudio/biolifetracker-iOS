//
//  ProjectStub.swift
//  BioLifeTracker
//
//  Created by Haritha on 13/4/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//

import Foundation


class ProjectStub {
    
    
    let user1 = User(name: "Dean Winchester", email: "impala67@default.com")
    let user2 = User(name: "Castiel", email: "fallenAngel@default.com")
    let user3 = User(name: "Sam Winchester", email: "tooPrecious@default.com")
    let user4 = User(name: "Bobby Singer", email: "whiskey4life@default.com")
    
    
    let state1 = BehaviourState(name: "Eating", information: "Finds human junk food")
    let state2 = BehaviourState(name: "Sleeping", information: "Resting in dark places")
    let state3 = BehaviourState(name: "Making Deals", information: "With a human at crossways")
    let state4 = BehaviourState(name: "Killing", information: "Sharp knives and demon magic")
    let state5 = BehaviourState(name: "Mating", information: "Something similar to the Pizzaman")
    let state6 = BehaviourState(name: "Fighting", information: "With other humans mostly hunters")
    let state7 = BehaviourState(name: "Possessing", information: "Black/red smoke enters into humans")
    
    let ethogram = Ethogram(name: "Demon Behaviour")
    
    var project: Project!
    
    var session1: Session!
    var session2: Session!
    var session3: Session!
    var session4: Session!
    var session5: Session!
    
    let individual1 = Individual(label: "Meg")
    let individual2 = Individual(label: "Crowley")
    let individual3 = Individual(label: "Ruby")
    let individual4 = Individual(label: "Abaddon")
    
    // morning times
    var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)

    let date1 = NSDate()
    let date2 = NSDate()
    let date3 = NSDate()
    let date4 = NSDate()
    let date5 = NSDate()
    let date6 = NSDate()
    let date7 = NSDate()
    let date8 = NSDate()
    let date9 = NSDate()
    let date10 = NSDate()
    let date11 = NSDate()
    let date12 = NSDate()
    let date13 = NSDate()
    let date14 = NSDate()
    let date15 = NSDate()
    let date16 = NSDate()
    let date17 = NSDate()
    let date18 = NSDate()
    let date19 = NSDate()
    let date20 = NSDate()
    let date21 = NSDate()
    let date22 = NSDate()
    let date23 = NSDate()
    let date24 = NSDate()
    let date25 = NSDate()
    let date26 = NSDate()
    let date27 = NSDate()
    let date28 = NSDate()
    let date29 = NSDate()
    let date30 = NSDate()
    let date31 = NSDate()
    let date32 = NSDate()
    let date33 = NSDate()
    let date34 = NSDate()
    let date35 = NSDate()
    let date36 = NSDate()
    let date37 = NSDate()
    let date38 = NSDate()
    let date39 = NSDate()
    let date40 = NSDate()
    let date41 = NSDate()
    let date42 = NSDate()
    
    init() {
        
        initialiseEthogram()
        createProject()
        createSessions()
        setDates()
        createObservations()
    }
    
    func initialiseEthogram() {
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        ethogram.addBehaviourState(state3)
        ethogram.addBehaviourState(state4)
        ethogram.addBehaviourState(state5)
        ethogram.addBehaviourState(state6)
        ethogram.addBehaviourState(state7)
    }
    
    func createProject() {
         project = Project(name: "Study of Demons", ethogram: ethogram)
    }
    
    func createSessions() {
        session1 = Session(project: project, type: SessionType.Scan)
        session2 = Session(project: project, type: SessionType.Focal)
        session3 = Session(project: project, type: SessionType.Scan)
        session4 = Session(project: project, type: SessionType.Focal)
        session5 = Session(project: project, type: SessionType.Scan)
        session1.addIndividuals([individual1])
        session2.addIndividuals([individual1])
        session3.addIndividuals([individual1])
        session4.addIndividuals([individual1])
        session5.addIndividuals([individual1])
    }
    
    func setDates() {
        var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        //mon 7am
        var components1 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date1)
        components1?.setValue(2, forComponent: .CalendarUnitWeekday)
        components1?.setValue(7, forComponent: .CalendarUnitHour)
        //mon 8am
        var components2 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date2)
        components2?.setValue(2, forComponent: .CalendarUnitWeekday)
        components2?.setValue(8, forComponent: .CalendarUnitHour)
        //tue 9am
        var components3 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date3)
        components3?.setValue(3, forComponent: .CalendarUnitWeekday)
        components3?.setValue(9, forComponent: .CalendarUnitHour)
        //tue 6am
        var components4 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date4)
        components4?.setValue(3, forComponent: .CalendarUnitWeekday)
        components4?.setValue(6, forComponent: .CalendarUnitHour)
        //wed 12pm
        var components5 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date5)
        components5?.setValue(4, forComponent: .CalendarUnitWeekday)
        components5?.setValue(12, forComponent: .CalendarUnitHour)
        //wed 11am
        var components6 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date6)
        components6?.setValue(4, forComponent: .CalendarUnitWeekday)
        components6?.setValue(11, forComponent: .CalendarUnitHour)
        //thurs 10am
        var components7 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date7)
        components7?.setValue(5, forComponent: .CalendarUnitWeekday)
        components7?.setValue(10, forComponent: .CalendarUnitHour)
        //thurs 11am
        var components8 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date8)
        components8?.setValue(5, forComponent: .CalendarUnitWeekday)
        components8?.setValue(11, forComponent: .CalendarUnitHour)
        //fri 11am
        var components9 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date9)
        components9?.setValue(6, forComponent: .CalendarUnitWeekday)
        components9?.setValue(11, forComponent: .CalendarUnitHour)
        //fri 6am
        var components10 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date10)
        components10?.setValue(6, forComponent: .CalendarUnitWeekday)
        components10?.setValue(6, forComponent: .CalendarUnitHour)
        //sat 5am
        var components11 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date11)
        components11?.setValue(7, forComponent: .CalendarUnitWeekday)
        components11?.setValue(5, forComponent: .CalendarUnitHour)
        //sat 12pm
        var components12 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date12)
        components12?.setValue(7, forComponent: .CalendarUnitWeekday)
        components12?.setValue(12, forComponent: .CalendarUnitHour)
        //sun 9am
        var components13 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date13)
        components13?.setValue(1, forComponent: .CalendarUnitWeekday)
        components13?.setValue(9, forComponent: .CalendarUnitHour)
        //sun 8am
        var components14 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date14)
        components14?.setValue(1, forComponent: .CalendarUnitWeekday)
        components14?.setValue(8, forComponent: .CalendarUnitHour)
        
        // afternoon times
        //mon 1pm
        var components15 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date15)
        components15?.setValue(2, forComponent: .CalendarUnitWeekday)
        components15?.setValue(13, forComponent: .CalendarUnitHour)
        //mon 2pm
        var components16 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date16)
        components16?.setValue(2, forComponent: .CalendarUnitWeekday)
        components16?.setValue(14, forComponent: .CalendarUnitHour)
        //tue 1pm
        var components17 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date17)
        components17?.setValue(3, forComponent: .CalendarUnitWeekday)
        components17?.setValue(13, forComponent: .CalendarUnitHour)
        //tue 3pm
        var components18 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date18)
        components18?.setValue(3, forComponent: .CalendarUnitWeekday)
        components18?.setValue(15, forComponent: .CalendarUnitHour)
        //wed 3pm
        var components19 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date19)
        components19?.setValue(4, forComponent: .CalendarUnitWeekday)
        components19?.setValue(15, forComponent: .CalendarUnitHour)
        //wed 2pm
        var components20 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date20)
        components20?.setValue(4, forComponent: .CalendarUnitWeekday)
        components20?.setValue(14, forComponent: .CalendarUnitHour)
        //thurs 1pm
        var components21 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date21)
        components21?.setValue(5, forComponent: .CalendarUnitWeekday)
        components21?.setValue(13, forComponent: .CalendarUnitHour)
        //thurs 3pm
        var components22 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date22)
        components22?.setValue(5, forComponent: .CalendarUnitWeekday)
        components22?.setValue(15, forComponent: .CalendarUnitHour)
        //fri 1pm
        var components23 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date23)
        components23?.setValue(6, forComponent: .CalendarUnitWeekday)
        components23?.setValue(13, forComponent: .CalendarUnitHour)
        //fri 3pm
        var components24 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date24)
        components24?.setValue(6, forComponent: .CalendarUnitWeekday)
        components24?.setValue(15, forComponent: .CalendarUnitHour)
        //sat 1pm
        var components25 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date25)
        components25?.setValue(7, forComponent: .CalendarUnitWeekday)
        components25?.setValue(13, forComponent: .CalendarUnitHour)
        //sat 2pm
        var components26 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date26)
        components26?.setValue(7, forComponent: .CalendarUnitWeekday)
        components26?.setValue(14, forComponent: .CalendarUnitHour)
        //sun 3pm
        var components27 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date27)
        components27?.setValue(1, forComponent: .CalendarUnitWeekday)
        components27?.setValue(15, forComponent: .CalendarUnitHour)
        //sun 1pm
        var components28 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date28)
        components28?.setValue(1, forComponent: .CalendarUnitWeekday)
        components28?.setValue(13, forComponent: .CalendarUnitHour)
        
        // evening times
        //mon 4pm
        var components29 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date29)
        components29?.setValue(2, forComponent: .CalendarUnitWeekday)
        components29?.setValue(16, forComponent: .CalendarUnitHour)
        //mon 5pm
        var components30 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date30)
        components30?.setValue(2, forComponent: .CalendarUnitWeekday)
        components30?.setValue(17, forComponent: .CalendarUnitHour)
        //tue 6pm
        var components31 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date31)
        components31?.setValue(3, forComponent: .CalendarUnitWeekday)
        components31?.setValue(18, forComponent: .CalendarUnitHour)
        //tue 7pm
        var components32 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date32)
        components32?.setValue(3, forComponent: .CalendarUnitWeekday)
        components32?.setValue(19, forComponent: .CalendarUnitHour)
        //wed 8pm
        var components33 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date33)
        components33?.setValue(4, forComponent: .CalendarUnitWeekday)
        components33?.setValue(20, forComponent: .CalendarUnitHour)
        //wed 5pm
        var components34 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date34)
        components34?.setValue(4, forComponent: .CalendarUnitWeekday)
        components34?.setValue(17, forComponent: .CalendarUnitHour)
        //thurs 10pm
        var components35 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date35)
        components35?.setValue(5, forComponent: .CalendarUnitWeekday)
        components35?.setValue(22, forComponent: .CalendarUnitHour)
        //thurs 11pm
        var components36 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date36)
        components36?.setValue(5, forComponent: .CalendarUnitWeekday)
        components36?.setValue(23, forComponent: .CalendarUnitHour)
        //fri 12am
        var components37 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date37)
        components37?.setValue(6, forComponent: .CalendarUnitWeekday)
        components37?.setValue(0, forComponent: .CalendarUnitHour)
        //fri 6pm
        var components38 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date38)
        components38?.setValue(6, forComponent: .CalendarUnitWeekday)
        components38?.setValue(18, forComponent: .CalendarUnitHour)
        //sat 5pm
        var components39 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date39)
        components39?.setValue(7, forComponent: .CalendarUnitWeekday)
        components39?.setValue(17, forComponent: .CalendarUnitHour)
        //sat 4pm
        var components40 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date40)
        components40?.setValue(7, forComponent: .CalendarUnitWeekday)
        components40?.setValue(16, forComponent: .CalendarUnitHour)
        //sun 9pm
        var components41 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date41)
        components41?.setValue(1, forComponent: .CalendarUnitWeekday)
        components41?.setValue(21, forComponent: .CalendarUnitHour)
        //sun 8pm
        var components42 = calendar?.components(.CalendarUnitWeekday | .CalendarUnitHour , fromDate: date42)
        components42?.setValue(1, forComponent: .CalendarUnitWeekday)
        components42?.setValue(20, forComponent: .CalendarUnitHour)

    }

    
    func createObservations() {
        // session 1 -- morning
        let observation1 = Observation(session: session1, individual: individual1, state: state1, timestamp: date1, information: "Eating vigourously")
        let observation2 = Observation(session: session1, individual: individual2, state: state2, timestamp: date2, information: "Eating vigourously")
        let observation3 = Observation(session: session1, individual: individual1, state: state2, timestamp: date3, information: "Eating vigourously")
        let observation4 = Observation(session: session1, individual: individual4, state: state2, timestamp: date14, information: "Eating vigourously")
        let observation5 = Observation(session: session1, individual: individual2, state: state2, timestamp: date5, information: "Eating vigourously")
        let observation6 = Observation(session: session1, individual: individual1, state: state2, timestamp: date6, information: "Eating vigourously")
        let observation7 = Observation(session: session1, individual: individual3, state: state6, timestamp: date7, information: "Eating vigourously")
        let observation8 = Observation(session: session1, individual: individual2, state: state1, timestamp: date8, information: "Eating vigourously")
        let observation9 = Observation(session: session1, individual: individual1, state: state7, timestamp: date9, information: "Eating vigourously")
        let observation10 = Observation(session: session1, individual: individual1, state: state2, timestamp: date10, information: "Eating vigourously")
        let observation131 = Observation(session: session1, individual: individual1, state: state3, timestamp: date11, information: "Eating vigourously")
        let observation132 = Observation(session: session1, individual: individual1, state: state4, timestamp: date12, information: "Eating vigourously")
        
        session1.addObservation([observation1, observation2, observation3, observation4, observation5, observation6, observation7, observation8, observation9, observation10, observation131, observation132])
        
        // session 2 -- afternoon
        
        let observation11 = Observation(session: session2, individual: individual1, state: state1, timestamp: date15, information: "Eating vigourously")
        let observation12 = Observation(session: session2, individual: individual1, state: state3, timestamp: date16, information: "Eating vigourously")
        let observation13 = Observation(session: session2, individual: individual1, state: state4, timestamp: date17, information: "Eating vigourously")
        let observation14 = Observation(session: session2, individual: individual1, state: state5, timestamp: date18, information: "Eating vigourously")
        let observation15 = Observation(session: session2, individual: individual1, state: state6, timestamp: date19, information: "Eating vigourously")
        let observation16 = Observation(session: session2, individual: individual1, state: state3, timestamp: date20, information: "Eating vigourously")
        let observation17 = Observation(session: session2, individual: individual1, state: state2, timestamp: date21, information: "Eating vigourously")
        let observation18 = Observation(session: session2, individual: individual1, state: state4, timestamp: date22, information: "Eating vigourously")
        let observation19 = Observation(session: session2, individual: individual1, state: state5, timestamp: date23, information: "Eating vigourously")
        let observation20 = Observation(session: session2, individual: individual1, state: state6, timestamp: date24, information: "Eating vigourously")
        let observation21 = Observation(session: session2, individual: individual1, state: state6, timestamp: date25, information: "Eating vigourously")
        let observation22 = Observation(session: session2, individual: individual1, state: state1, timestamp: date26, information: "Eating vigourously")
        let observation23 = Observation(session: session2, individual: individual1, state: state1, timestamp: date27, information: "Eating vigourously")
        let observation24 = Observation(session: session2, individual: individual1, state: state3, timestamp: date28, information: "Eating vigourously")
        let observation25 = Observation(session: session2, individual: individual1, state: state3, timestamp: date21, information: "Eating vigourously")
        let observation26 = Observation(session: session2, individual: individual1, state: state4, timestamp: date17, information: "Eating vigourously")
        let observation27 = Observation(session: session2, individual: individual1, state: state4, timestamp: date23, information: "Eating vigourously")
        let observation28 = Observation(session: session2, individual: individual1, state: state3, timestamp: date27, information: "Eating vigourously")
        let observation29 = Observation(session: session2, individual: individual1, state: state4, timestamp: date15, information: "Eating vigourously")
        let observation30 = Observation(session: session2, individual: individual1, state: state5, timestamp: date19, information: "Eating vigourously")
        
        session2.addObservation([observation11,
            observation12,
            observation13,
            observation14,
            observation15,
            observation16,
            observation17,
            observation18,
            observation19,
            observation20,
            observation21,
            observation22,
            observation23,
            observation24,
            observation25,
            observation26,
            observation27,
            observation28,
            observation29,
            observation30])
        
        
        // session 3 -- evening
        
        let observation31 = Observation(session: session2, individual: individual1, state: state1, timestamp: date29, information: "Eating vigourously")
        let observation32 = Observation(session: session2, individual: individual1, state: state3, timestamp: date30, information: "Eating vigourously")
        let observation33 = Observation(session: session2, individual: individual1, state: state4, timestamp: date31, information: "Eating vigourously")
        let observation34 = Observation(session: session2, individual: individual1, state: state5, timestamp: date32, information: "Eating vigourously")
        let observation35 = Observation(session: session2, individual: individual1, state: state6, timestamp: date33, information: "Eating vigourously")
        let observation36 = Observation(session: session2, individual: individual1, state: state3, timestamp: date34, information: "Eating vigourously")
        let observation37 = Observation(session: session2, individual: individual1, state: state2, timestamp: date35, information: "Eating vigourously")
        let observation38 = Observation(session: session2, individual: individual1, state: state4, timestamp: date36, information: "Eating vigourously")
        let observation39 = Observation(session: session2, individual: individual1, state: state5, timestamp: date37, information: "Eating vigourously")
        let observation40 = Observation(session: session2, individual: individual1, state: state6, timestamp: date38, information: "Eating vigourously")
        let observation41 = Observation(session: session2, individual: individual1, state: state6, timestamp: date39, information: "Eating vigourously")
        let observation42 = Observation(session: session2, individual: individual1, state: state1, timestamp: date40, information: "Eating vigourously")
        let observation43 = Observation(session: session2, individual: individual1, state: state1, timestamp: date41, information: "Eating vigourously")
        let observation44 = Observation(session: session2, individual: individual1, state: state3, timestamp: date42, information: "Eating vigourously")
        let observation45 = Observation(session: session2, individual: individual1, state: state3, timestamp: date41, information: "Eating vigourously")
        let observation46 = Observation(session: session2, individual: individual1, state: state4, timestamp: date40, information: "Eating vigourously")
        let observation47 = Observation(session: session2, individual: individual1, state: state7, timestamp: date39, information: "Eating vigourously")
        let observation48 = Observation(session: session2, individual: individual1, state: state3, timestamp: date38, information: "Eating vigourously")
        let observation49 = Observation(session: session2, individual: individual1, state: state7, timestamp: date37, information: "Eating vigourously")
        let observation50 = Observation(session: session2, individual: individual1, state: state5, timestamp: date36, information: "Eating vigourously")
        let observation51 = Observation(session: session2, individual: individual1, state: state1, timestamp: date35, information: "Eating vigourously")
        let observation52 = Observation(session: session2, individual: individual1, state: state3, timestamp: date34, information: "Eating vigourously")
        let observation53 = Observation(session: session2, individual: individual1, state: state4, timestamp: date33, information: "Eating vigourously")
        let observation54 = Observation(session: session2, individual: individual1, state: state7, timestamp: date32, information: "Eating vigourously")
        let observation55 = Observation(session: session2, individual: individual1, state: state6, timestamp: date31, information: "Eating vigourously")
        let observation56 = Observation(session: session2, individual: individual1, state: state3, timestamp: date30, information: "Eating vigourously")
        let observation57 = Observation(session: session2, individual: individual1, state: state3, timestamp: date29, information: "Eating vigourously")
        let observation58 = Observation(session: session2, individual: individual1, state: state4, timestamp: date29, information: "Eating vigourously")
        let observation59 = Observation(session: session2, individual: individual1, state: state5, timestamp: date30, information: "Eating vigourously")
        let observation60 = Observation(session: session2, individual: individual1, state: state6, timestamp: date42, information: "Eating vigourously")
        let observation61 = Observation(session: session2, individual: individual1, state: state7, timestamp: date31, information: "Eating vigourously")
        let observation62 = Observation(session: session2, individual: individual1, state: state1, timestamp: date32, information: "Eating vigourously")
        let observation63 = Observation(session: session2, individual: individual1, state: state7, timestamp: date33, information: "Eating vigourously")
        let observation64 = Observation(session: session2, individual: individual1, state: state3, timestamp: date34, information: "Eating vigourously")
        let observation65 = Observation(session: session2, individual: individual1, state: state3, timestamp: date35, information: "Eating vigourously")
        let observation66 = Observation(session: session2, individual: individual1, state: state4, timestamp: date36, information: "Eating vigourously")
        let observation67 = Observation(session: session2, individual: individual1, state: state4, timestamp: date37, information: "Eating vigourously")
        let observation68 = Observation(session: session2, individual: individual1, state: state3, timestamp: date38, information: "Eating vigourously")
        let observation69 = Observation(session: session2, individual: individual1, state: state4, timestamp: date39, information: "Eating vigourously")
        let observation70 = Observation(session: session2, individual: individual1, state: state5, timestamp: date40, information: "Eating vigourously")
        
        session3.addObservation([observation31,
            observation32,
            observation33,
            observation34,
            observation35,
            observation36,
            observation37,
            observation38,
            observation39,
            observation40,
            observation41,
            observation42,
            observation43,
            observation44,
            observation45,
            observation46,
            observation47,
            observation48,
            observation49,
            observation50,
            observation51,
            observation52,
            observation53,
            observation54,
            observation55,
            observation56,
            observation57,
            observation58,
            observation59,
            observation60,
            observation61,
            observation62,
            observation63,
            observation64,
            observation65,
            observation66,
            observation67,
            observation68,
            observation69,
            observation70])
        
        
        // session 4 -- evening
        let observation71 = Observation(session: session2, individual: individual1, state: state1, timestamp: date41, information: "Eating vigourously")
        let observation72 = Observation(session: session2, individual: individual1, state: state3, timestamp: date42, information: "Eating vigourously")
        let observation73 = Observation(session: session2, individual: individual1, state: state4, timestamp: date42, information: "Eating vigourously")
        let observation74 = Observation(session: session2, individual: individual1, state: state5, timestamp: date41, information: "Eating vigourously")
        let observation75 = Observation(session: session2, individual: individual1, state: state6, timestamp: date40, information: "Eating vigourously")
        let observation76 = Observation(session: session2, individual: individual1, state: state3, timestamp: date39, information: "Eating vigourously")
        let observation77 = Observation(session: session2, individual: individual1, state: state2, timestamp: date38, information: "Eating vigourously")
        let observation78 = Observation(session: session2, individual: individual1, state: state4, timestamp: date37, information: "Eating vigourously")
        let observation79 = Observation(session: session2, individual: individual1, state: state5, timestamp: date36, information: "Eating vigourously")
        let observation80 = Observation(session: session2, individual: individual1, state: state6, timestamp: date35, information: "Eating vigourously")
        let observation81 = Observation(session: session2, individual: individual1, state: state6, timestamp: date34, information: "Eating vigourously")
        let observation82 = Observation(session: session2, individual: individual1, state: state1, timestamp: date33, information: "Eating vigourously")
        let observation83 = Observation(session: session2, individual: individual1, state: state1, timestamp: date32, information: "Eating vigourously")
        let observation84 = Observation(session: session2, individual: individual1, state: state2, timestamp: date31, information: "Eating vigourously")
        let observation85 = Observation(session: session2, individual: individual1, state: state3, timestamp: date30, information: "Eating vigourously")
        let observation86 = Observation(session: session2, individual: individual1, state: state4, timestamp: date29, information: "Eating vigourously")
        let observation87 = Observation(session: session2, individual: individual1, state: state4, timestamp: date29, information: "Eating vigourously")
        let observation88 = Observation(session: session2, individual: individual1, state: state3, timestamp: date30, information: "Eating vigourously")
        let observation89 = Observation(session: session2, individual: individual1, state: state4, timestamp: date31, information: "Eating vigourously")
        let observation90 = Observation(session: session2, individual: individual1, state: state5, timestamp: date32, information: "Eating vigourously")
        let observation91 = Observation(session: session2, individual: individual1, state: state2, timestamp: date33, information: "Eating vigourously")
        let observation92 = Observation(session: session2, individual: individual1, state: state3, timestamp: date34, information: "Eating vigourously")
        let observation93 = Observation(session: session2, individual: individual1, state: state4, timestamp: date35, information: "Eating vigourously")
        let observation94 = Observation(session: session2, individual: individual1, state: state7, timestamp: date36, information: "Eating vigourously")
        let observation95 = Observation(session: session2, individual: individual1, state: state6, timestamp: date37, information: "Eating vigourously")
        let observation96 = Observation(session: session2, individual: individual1, state: state2, timestamp: date38, information: "Eating vigourously")
        let observation97 = Observation(session: session2, individual: individual1, state: state7, timestamp: date39, information: "Eating vigourously")
        let observation98 = Observation(session: session2, individual: individual1, state: state4, timestamp: date40, information: "Eating vigourously")
        let observation99 = Observation(session: session2, individual: individual1, state: state5, timestamp: date41, information: "Eating vigourously")
        let observation100 = Observation(session: session2, individual: individual1, state: state6, timestamp: date42, information: "Eating vigourously")
        let observation101 = Observation(session: session2, individual: individual1, state: state2, timestamp: date42, information: "Eating vigourously")
        let observation102 = Observation(session: session2, individual: individual1, state: state1, timestamp: date41, information: "Eating vigourously")
        let observation103 = Observation(session: session2, individual: individual1, state: state7, timestamp: date40, information: "Eating vigourously")
        let observation104 = Observation(session: session2, individual: individual1, state: state3, timestamp: date39, information: "Eating vigourously")
        let observation105 = Observation(session: session2, individual: individual1, state: state3, timestamp: date38, information: "Eating vigourously")
        let observation106 = Observation(session: session2, individual: individual1, state: state4, timestamp: date37, information: "Eating vigourously")
        let observation107 = Observation(session: session2, individual: individual1, state: state2, timestamp: date36, information: "Eating vigourously")
        let observation108 = Observation(session: session2, individual: individual1, state: state3, timestamp: date35, information: "Eating vigourously")
        let observation109 = Observation(session: session2, individual: individual1, state: state4, timestamp: date34, information: "Eating vigourously")
        let observation110 = Observation(session: session2, individual: individual1, state: state5, timestamp: date33, information: "Eating vigourously")
        
        session4.addObservation([observation71,
            observation72,
            observation73,
            observation74,
            observation75,
            observation76,
            observation77,
            observation78,
            observation79,
            observation80,
            observation81,
            observation82,
            observation83,
            observation84,
            observation85,
            observation86,
            observation87,
            observation88,
            observation89,
            observation90,
            observation91,
            observation92,
            observation93,
            observation94,
            observation95,
            observation96,
            observation97,
            observation98,
            observation99,
            observation100,
            observation101,
            observation102,
            observation103,
            observation104,
            observation105,
            observation106,
            observation107,
            observation108,
            observation109,
            observation110])
        
        // session 5 -- afternoon
        let observation111 = Observation(session: session2, individual: individual1, state: state1, timestamp: date15, information: "Eating vigourously")
        let observation112 = Observation(session: session2, individual: individual1, state: state2, timestamp: date16, information: "Eating vigourously")
        let observation113 = Observation(session: session2, individual: individual1, state: state4, timestamp: date17, information: "Eating vigourously")
        let observation114 = Observation(session: session2, individual: individual1, state: state5, timestamp: date18, information: "Eating vigourously")
        let observation115 = Observation(session: session2, individual: individual1, state: state7, timestamp: date19, information: "Eating vigourously")
        let observation116 = Observation(session: session2, individual: individual1, state: state3, timestamp: date20, information: "Eating vigourously")
        let observation117 = Observation(session: session2, individual: individual1, state: state2, timestamp: date21, information: "Eating vigourously")
        let observation118 = Observation(session: session2, individual: individual1, state: state7, timestamp: date22, information: "Eating vigourously")
        let observation119 = Observation(session: session2, individual: individual1, state: state5, timestamp: date23, information: "Eating vigourously")
        let observation120 = Observation(session: session2, individual: individual1, state: state6, timestamp: date24, information: "Eating vigourously")
        let observation121 = Observation(session: session2, individual: individual1, state: state6, timestamp: date25, information: "Eating vigourously")
        let observation122 = Observation(session: session2, individual: individual1, state: state2, timestamp: date26, information: "Eating vigourously")
        let observation123 = Observation(session: session2, individual: individual1, state: state1, timestamp: date27, information: "Eating vigourously")
        let observation124 = Observation(session: session2, individual: individual1, state: state3, timestamp: date28, information: "Eating vigourously")
        let observation125 = Observation(session: session2, individual: individual1, state: state2, timestamp: date21, information: "Eating vigourously")
        let observation126 = Observation(session: session2, individual: individual1, state: state4, timestamp: date15, information: "Eating vigourously")
        let observation127 = Observation(session: session2, individual: individual1, state: state4, timestamp: date16, information: "Eating vigourously")
        let observation128 = Observation(session: session2, individual: individual1, state: state3, timestamp: date19, information: "Eating vigourously")
        let observation129 = Observation(session: session2, individual: individual1, state: state4, timestamp: date23, information: "Eating vigourously")
        let observation130 = Observation(session: session2, individual: individual1, state: state5, timestamp: date22, information: "Eating vigourously")
        
        session4.addObservation([observation111,
            observation112,
            observation113,
            observation114,
            observation115,
            observation116,
            observation117,
            observation118,
            observation119,
            observation120,
            observation121,
            observation122,
            observation123,
            observation124,
            observation125,
            observation126,
            observation127,
            observation128,
            observation129,
            observation130])
        
    }
    
}