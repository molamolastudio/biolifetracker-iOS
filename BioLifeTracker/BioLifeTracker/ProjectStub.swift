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
    let state8 = BehaviourState(name: "Turning into Monsters", information: "Black/red smoke enters into humans")
    let state9 = BehaviourState(name: "Sacrificing Lambs", information: "Black/red smoke enters into humans")
    let state10 = BehaviourState(name: "Drinking", information: "Black/red smoke enters into humans")
    let state11 = BehaviourState(name: "Meditating", information: "Black/red smoke enters into humans")
    let state12 = BehaviourState(name: "Angel Hunting", information: "Black/red smoke enters into humans")
    let state13 = BehaviourState(name: "Worshipping", information: "Black/red smoke enters into humans")
    let state14 = BehaviourState(name: "Deer hunting", information: "Black/red smoke enters into humans")
    let state15 = BehaviourState(name: "Looking for Lucifer", information: "Black/red smoke enters into humans")
    
    
    let ethogram = Ethogram(name: "Demon Behaviour")
    
    var project: Project!
    var empty: Project!
    
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

    var date1 = NSDate()
    var date2 = NSDate()
    var date3 = NSDate()
    var date4 = NSDate()
    var date5 = NSDate()
    var date6 = NSDate()
    var date7 = NSDate()
    var date8 = NSDate()
    var date9 = NSDate()
    var date10 = NSDate()
    var date11 = NSDate()
    var date12 = NSDate()
    var date13 = NSDate()
    var date14 = NSDate()
    var date15 = NSDate()
    var date16 = NSDate()
    var date17 = NSDate()
    var date18 = NSDate()
    var date19 = NSDate()
    var date20 = NSDate()
    var date21 = NSDate()
    var date22 = NSDate()
    var date23 = NSDate()
    var date24 = NSDate()
    var date25 = NSDate()
    var date26 = NSDate()
    var date27 = NSDate()
    var date28 = NSDate()
    var date29 = NSDate()
    var date30 = NSDate()
    var date31 = NSDate()
    var date32 = NSDate()
    var date33 = NSDate()
    var date34 = NSDate()
    var date35 = NSDate()
    var date36 = NSDate()
    var date37 = NSDate()
    var date38 = NSDate()
    var date39 = NSDate()
    var date40 = NSDate()
    var date41 = NSDate()
    var date42 = NSDate()
    
    init() {
        
        initialiseEthogram()
        createProject()
        createSessions()
        setDates()
        createObservations()
        
        [user1, user2, user3, user4].map { self.project.addMember($0) }
        [session1, session2, session3, session4, session5].map { self.project.addSession($0) }
    }
    
    func initialiseEthogram() {
        ethogram.addBehaviourState(state1)
        ethogram.addBehaviourState(state2)
        ethogram.addBehaviourState(state3)
        ethogram.addBehaviourState(state4)
        ethogram.addBehaviourState(state5)
        ethogram.addBehaviourState(state6)
        ethogram.addBehaviourState(state7)
        ethogram.addBehaviourState(state8)
        ethogram.addBehaviourState(state9)
        ethogram.addBehaviourState(state10)
        ethogram.addBehaviourState(state11)
        ethogram.addBehaviourState(state12)
        ethogram.addBehaviourState(state13)
        ethogram.addBehaviourState(state14)
        ethogram.addBehaviourState(state15)
        
    }
    
    func createProject() {
        empty = Project(name: "Study of The Mark Of Cain", ethogram: ethogram)
        project = Project(name: "Study of Demons", ethogram: ethogram)
    }
    
    func createSessions() {
        session1 = Session(project: project, name: "SESSION 1", type: SessionType.Scan)
        session2 = Session(project: project, name: "SESSION 2", type: SessionType.Focal)
        session3 = Session(project: project, name: "SESSION 3", type: SessionType.Scan)
        session4 = Session(project: project, name: "SESSION 4", type: SessionType.Focal)
        session5 = Session(project: project, name: "SESSION 5", type: SessionType.Scan)
        session1.addIndividuals([individual1])
        session2.addIndividuals([individual1])
        session3.addIndividuals([individual1])
        session4.addIndividuals([individual1])
        session5.addIndividuals([individual1])
        
    }
    
    func setDates() {
        var calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        //mon 7am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 2, ofDate: date1, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 7, ofDate: day, options: nil) {
                date1 = hour
            }
        }
        //mon 8am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 2, ofDate: date2, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 8, ofDate: day, options: nil) {
                date2 = hour
            }
        }
        //tue 9am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 3, ofDate: date3, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 9, ofDate: day, options: nil) {
                date3 = hour
            }
        }
        //tue 6am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 3, ofDate: date4, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 6, ofDate: day, options: nil) {
                date4 = hour
            }
        }
        //wed 12pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 4, ofDate: date5, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 12, ofDate: day, options: nil) {
                date5 = hour
            }
        }
        //wed 11am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 4, ofDate: date6, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 11, ofDate: day, options: nil) {
                date6 = hour
            }
        }
        //thurs 10am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 5, ofDate: date7, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 10, ofDate: day, options: nil) {
                date7 = hour
            }
        }
        //thurs 11am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 5, ofDate: date8, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 11, ofDate: day, options: nil) {
                date8 = hour
            }
        }
        //fri 11am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 6, ofDate: date9, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 11, ofDate: day, options: nil) {
                date9 = hour
            }
        }
        //fri 6am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 6, ofDate: date10, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 6, ofDate: day, options: nil) {
                date10 = hour
            }
        }
        //sat 5am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 7, ofDate: date11, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 5, ofDate: day, options: nil) {
                date11 = hour
            }
        }
        //sat 12pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 7, ofDate: date12, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 12, ofDate: day, options: nil) {
                date12 = hour
            }
        }
        //sun 9am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 1, ofDate: date13, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 9, ofDate: day, options: nil) {
                date13 = hour
            }
        }
        //sun 8am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 1, ofDate: date14, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 8, ofDate: day, options: nil) {
                date14 = hour
            }
        }
        
        // afternoon times
        //mon 1pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 2, ofDate: date15, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 13, ofDate: day, options: nil) {
                date15 = hour
            }
        }
        //mon 2pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 2, ofDate: date16, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 14, ofDate: day, options: nil) {
                date16 = hour
            }
        }
        //tue 1pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 3, ofDate: date17, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 13, ofDate: day, options: nil) {
                date17 = hour
            }
        }
        //tue 3pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 3, ofDate: date18, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 15, ofDate: day, options: nil) {
                date18 = hour
            }
        }
        //wed 3pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 4, ofDate: date19, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 15, ofDate: day, options: nil) {
                date19 = hour
            }
        }
        //wed 2pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 4, ofDate: date20, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 14, ofDate: day, options: nil) {
                date20 = hour
            }
        }
        //thurs 1pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 5, ofDate: date21, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 13, ofDate: day, options: nil) {
                date21 = hour
            }
        }
        //thurs 3pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 5, ofDate: date22, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 15, ofDate: day, options: nil) {
                date22 = hour
            }
        }
        //fri 1pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 6, ofDate: date23, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 13, ofDate: day, options: nil) {
                date23 = hour
            }
        }
        //fri 3pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 6, ofDate: date24, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 15, ofDate: day, options: nil) {
                date24 = hour
            }
        }
        //sat 1pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 7, ofDate: date25, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 13, ofDate: day, options: nil) {
                date25 = hour
            }
        }
        //sat 2pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 7, ofDate: date26, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 14, ofDate: day, options: nil) {
                date26 = hour
            }
        }
        //sun 3pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 1, ofDate: date27, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 15, ofDate: day, options: nil) {
                date27 = hour
            }
        }
        //sun 1pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 1, ofDate: date28, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 13, ofDate: day, options: nil) {
                date28 = hour
            }
        }
        
        // evening times
        //mon 4pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 2, ofDate: date29, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 16, ofDate: day, options: nil) {
                date29 = hour
            }
        }
        //mon 5pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 2, ofDate: date30, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 17, ofDate: day, options: nil) {
                date30 = hour
            }
        }
        //tue 6pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 3, ofDate: date31, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 18, ofDate: day, options: nil) {
                date31 = hour
            }
        }
        //tue 7pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 3, ofDate: date32, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 19, ofDate: day, options: nil) {
                date32 = hour
            }
        }
        //wed 8pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 4, ofDate: date33, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 20, ofDate: day, options: nil) {
                date33 = hour
            }
        }
        //wed 5pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 4, ofDate: date34, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 17, ofDate: day, options: nil) {
                date34 = hour
            }
        }
        //thurs 10pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 5, ofDate: date35, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 22, ofDate: day, options: nil) {
                date35 = hour
            }
        }
        //thurs 11pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 5, ofDate: date36, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 23, ofDate: day, options: nil) {
                date36 = hour
            }
        }
        //fri 12am
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 6, ofDate: date37, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 0, ofDate: day, options: nil) {
                date37 = hour
            }
        }
        //fri 6pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 6, ofDate: date38, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 18, ofDate: day, options: nil) {
                date38 = hour
            }
        }
        //sat 5pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 7, ofDate: date39, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 17, ofDate: day, options: nil) {
                date39 = hour
            }
        }
        //sat 4pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 7, ofDate: date40, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 16, ofDate: day, options: nil) {
                date40 = hour
            }
        }
        //sun 9pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 1, ofDate: date41, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 21, ofDate: day, options: nil) {
                date41 = hour
            }
        }
        //sun 8pm
        if let day = calendar?.dateBySettingUnit(.CalendarUnitWeekday, value: 1, ofDate: date42, options: nil) {
            if let hour = calendar?.dateBySettingUnit(.CalendarUnitHour, value: 20, ofDate: day, options: nil) {
                date42 = hour
            }
        }

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
        
        observation1.changeCreator(user1)
        observation2.changeCreator(user2)
        observation3.changeCreator(user3)
        observation4.changeCreator(user4)
        observation5.changeCreator(user1)
        observation6.changeCreator(user2)
        observation7.changeCreator(user3)
        observation8.changeCreator(user4)
        observation9.changeCreator(user1)
        observation10.changeCreator(user2)
        observation131.changeCreator(user3)
        observation132.changeCreator(user4)
        
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
        
        observation11.changeCreator(user1)
        observation12.changeCreator(user2)
        observation13.changeCreator(user3)
        observation14.changeCreator(user4)
        observation15.changeCreator(user1)
        observation16.changeCreator(user2)
        observation17.changeCreator(user3)
        observation18.changeCreator(user4)
        observation19.changeCreator(user1)
        observation20.changeCreator(user2)
        observation21.changeCreator(user3)
        observation22.changeCreator(user4)
        observation23.changeCreator(user1)
        observation24.changeCreator(user2)
        observation25.changeCreator(user3)
        observation26.changeCreator(user4)
        observation27.changeCreator(user1)
        observation28.changeCreator(user2)
        observation29.changeCreator(user3)
        observation30.changeCreator(user4)
        
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
        
        observation31.changeCreator(user1)
        observation32.changeCreator(user2)
        observation33.changeCreator(user3)
        observation34.changeCreator(user4)
        observation35.changeCreator(user1)
        observation36.changeCreator(user2)
        observation37.changeCreator(user3)
        observation38.changeCreator(user4)
        observation39.changeCreator(user1)
        observation40.changeCreator(user2)
        observation41.changeCreator(user3)
        observation42.changeCreator(user4)
        observation43.changeCreator(user1)
        observation44.changeCreator(user2)
        observation45.changeCreator(user3)
        observation46.changeCreator(user4)
        observation47.changeCreator(user1)
        observation48.changeCreator(user2)
        observation49.changeCreator(user3)
        observation50.changeCreator(user4)
        observation51.changeCreator(user1)
        observation52.changeCreator(user2)
        observation53.changeCreator(user3)
        observation54.changeCreator(user4)
        observation55.changeCreator(user1)
        observation56.changeCreator(user2)
        observation57.changeCreator(user3)
        observation58.changeCreator(user4)
        observation59.changeCreator(user1)
        observation60.changeCreator(user2)
        observation61.changeCreator(user3)
        observation62.changeCreator(user4)
        observation63.changeCreator(user1)
        observation64.changeCreator(user2)
        observation65.changeCreator(user3)
        observation66.changeCreator(user4)
        observation67.changeCreator(user1)
        observation68.changeCreator(user2)
        observation69.changeCreator(user3)
        observation70.changeCreator(user4)
        
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
        
        observation71.changeCreator(user1)
        observation72.changeCreator(user2)
        observation73.changeCreator(user3)
        observation74.changeCreator(user4)
        observation75.changeCreator(user1)
        observation76.changeCreator(user2)
        observation77.changeCreator(user3)
        observation78.changeCreator(user4)
        observation79.changeCreator(user1)
        observation80.changeCreator(user2)
        observation81.changeCreator(user3)
        observation82.changeCreator(user4)
        observation83.changeCreator(user1)
        observation84.changeCreator(user2)
        observation85.changeCreator(user3)
        observation86.changeCreator(user4)
        observation87.changeCreator(user1)
        observation88.changeCreator(user2)
        observation89.changeCreator(user3)
        observation90.changeCreator(user4)
        observation91.changeCreator(user1)
        observation92.changeCreator(user2)
        observation93.changeCreator(user3)
        observation94.changeCreator(user4)
        observation95.changeCreator(user1)
        observation96.changeCreator(user2)
        observation97.changeCreator(user3)
        observation98.changeCreator(user4)
        observation99.changeCreator(user1)
        observation100.changeCreator(user2)
        observation101.changeCreator(user3)
        observation102.changeCreator(user4)
        observation103.changeCreator(user1)
        observation104.changeCreator(user2)
        observation105.changeCreator(user3)
        observation106.changeCreator(user4)
        observation107.changeCreator(user1)
        observation108.changeCreator(user2)
        observation109.changeCreator(user3)
        observation110.changeCreator(user4)
        
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
        
        observation110.changeCreator(user2)
        observation111.changeCreator(user3)
        observation112.changeCreator(user4)
        observation113.changeCreator(user1)
        observation114.changeCreator(user2)
        observation115.changeCreator(user3)
        observation116.changeCreator(user4)
        observation117.changeCreator(user1)
        observation118.changeCreator(user2)
        observation119.changeCreator(user3)
        observation120.changeCreator(user4)
        observation120.changeCreator(user2)
        observation121.changeCreator(user3)
        observation122.changeCreator(user4)
        observation123.changeCreator(user1)
        observation124.changeCreator(user2)
        observation125.changeCreator(user3)
        observation126.changeCreator(user4)
        observation127.changeCreator(user1)
        observation128.changeCreator(user2)
        observation129.changeCreator(user3)
        observation130.changeCreator(user4)
        
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