//
//  SynData.swift
//  HealthAppTest
//
//  Created by Martin Varga on 01/03/2022.
//

import Foundation

class SynData{
    let goalNone: [Goal]
    var task: Task
    var selectedGoals: Set<Goal>
    static let shared = SynData()
    
    init(){
        self.goalNone = [Goal(name: "None")]
        self.task = Task(name: "", servingGoals: [goalNone[0]])
        self.selectedGoals = Set(arrayLiteral: goalNone[0])
    }
    
    
    
    
    
    
    
    func printVars(){
        print(goalNone)
        print(task)
        print(selectedGoals)
        //print(count)
        //count = count + 1
    }
}

class dbHealthRow: Codable{
    var uuid : String
    var sampleType : String
    var sampleValue : Double
    var startDate : Date
    var endDate : Date
}
