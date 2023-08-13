//
//  HealthStore.swift
//  HealthAppTest
//
//  Created by Martin Varga on 13/12/2021.
//

import Foundation
import HealthKit
import UIKit

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
    var oneDayAgo: Date {
            return self.addingTimeInterval(-86400)
        }
    
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
   }

    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }

}

class HealthStore{
    static let shared = HealthStore()
    var healthStore: HKHealthStore?
    var waterLabel: String?
    var stepLabel: String?
    var distanceRunningLabel: String?
    var distanceCycledLabel: String?
    var distanceSwimmingLabel: String?
    var distanceWheelchairLabel: String?
    var heartRateLabel: String?
    var caloriesLabel: String?
    
    private init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType)!
        let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
        let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        let height = HKObjectType.quantityType(forIdentifier: .height)!
        let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let waterType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        let distanceRanType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let distanceCyclingType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!
        let distanceSwimmingType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming)!
        let distanceWheelchairType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWheelchair)!
        let heartRateType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let caloriesType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        
        
        let healthKitTypesToWrite: Set<HKSampleType> = [stepType,
                                                        bodyMassIndex,
                                                        activeEnergy,
                                                        waterType,
                                                        distanceRanType,
                                                        distanceCyclingType,
                                                        distanceSwimmingType,
                                                        distanceWheelchairType,
                                                        heartRateType,
                                                        caloriesType,
                                                        HKObjectType.workoutType()]
            
        let healthKitTypesToRead: Set<HKObjectType> = [stepType,
                                                       dateOfBirth,
                                                       bloodType,
                                                       biologicalSex,
                                                       bodyMassIndex,
                                                       height,
                                                       bodyMass,
                                                       waterType,
                                                       distanceRanType,
                                                       distanceCyclingType,
                                                       distanceSwimmingType,
                                                       distanceWheelchairType,
                                                       heartRateType,
                                                       caloriesType,
                                                       HKObjectType.workoutType()]
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            completion(success)
        }
        
    }
    
    func readWater(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void){
        guard let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else {
            print("Sample type not available")
            return
        }
        //var dateComponent = DateComponents()
        //dateComponent.day = 1
        //let endDate = Calendar.current.date(byAdding: dateComponent, to: date)
        //let sDate = Calendar.current.date(byAdding: .hour, value: 0, to: dateStart.startOfDay)!
        //let eDate = Calendar.current.date(byAdding: .hour, value: 0, to: dateEnd.endOfDay)!
        let s24hPredicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        
        let waterQuery = HKSampleQuery(sampleType: waterType,
                                       predicate: s24hPredicate,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) {
                                        (query, samples, error) in
                                            
                                            guard
                                                error == nil,
                                                let quantitySamples = samples as? [HKQuantitySample] else {
                                                    print("Something went wrong: \(String(describing: error))")
                                                    return
                                            }
            //print(quantitySamples)
                                            let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for:                 HKUnit.literUnit(with: .milli)) }
                                                    print("total water: \(total)")
                                                DispatchQueue.main.async {
                                                    self.waterLabel = "\(total) ml of water"
                                                    if(self.waterLabel != ""){
                                                        self.waterLabel = "\(total) ml of water"
                                                        completion(true)
                                                    }else{
                                                        self.waterLabel = "0 ml of water"
                                                        completion(false)
                                                    }
                                            }
                                        }
        self.healthStore?.execute(waterQuery)
        
    }
    
    func writeWater(waterConsumed: Double, dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        guard let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else {
            print("Sample type not available")
            return
        }
        
        //let sDate = Calendar.current.date(byAdding: .hour, value: +1, to: dateStart.startOfDay)!
        //let eDate = Calendar.current.date(byAdding: .hour, value: -1, to: dateEnd.endOfDay)!
        
        let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: waterConsumed)
        //let today = Date()
        let waterQuantitySample = HKQuantitySample(type: waterType, quantity: waterQuantity, start: dateStart, end: dateEnd)
        
        self.healthStore?.save(waterQuantitySample) { (success, error) in
            if (error != nil) {
              NSLog("error occurred saving water data")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func writeSteps(stepCountValue: Double, dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            print("Quantity type not available")
            return
        }
        
        //let sDate = Calendar.current.date(byAdding: .hour, value: +1, to: dateStart.startOfDay)!
        //let eDate = Calendar.current.date(byAdding: .hour, value: -1, to: dateEnd.endOfDay)!
        
        let stepCountUnit:HKUnit = HKUnit.count()
        let stepCountQuantity = HKQuantity(unit: stepCountUnit, doubleValue: Double(stepCountValue))
        //let today = Date()
        let stepCountSample = HKQuantitySample(type: stepType, quantity: stepCountQuantity, start: dateStart, end: dateEnd)
        
        self.healthStore?.save(stepCountSample) { (success, error) in
            if (error != nil) {
              NSLog("error occurred saving steps data")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    
    func readSteps(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void){
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            print("Quantity type not available")
            return
        }
        //var dateComponent = DateComponents()
        //dateComponent.day = 1
        //let endDate = Calendar.current.date(byAdding: dateComponent, to: date)
        //let sDate = Calendar.current.date(byAdding: .hour, value: 0, to: dateStart.startOfDay)!
        //let eDate = Calendar.current.date(byAdding: .hour, value: 0, to: dateEnd.endOfDay)!
        
        let s24hPredicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        
        let stepQuery = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: s24hPredicate,
                options: .cumulativeSum
            ) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    self.stepLabel = String(format: "%.2f steps", 0)
                    completion(false)
                    return
                }

                self.stepLabel = String(format: "%.2f steps", sum.doubleValue(for: HKUnit.count()))
                completion(true)
            }
        self.healthStore?.execute(stepQuery)
    }
    
    func readWaterForDB(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        let predicateTime = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicateTime,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in

            guard let results = results else{
                //print(results)
                completion(false)
                return
            }
            self.samplesToSyncWater.removeAll()
            var index = 0
            for result in results{
                let sampleValues = results as? [HKQuantitySample]
                let valueToAdd = sampleValues?[index].quantity.doubleValue(for: HKUnit.literUnit(with: .milli)) ?? 69
                
                self.samplesToSyncWater.append(healthModelSample(uuid: result.uuid.uuidString, sampleType: result.sampleType.identifier, sampleValue: valueToAdd, startDate: result.startDate, endDate: result.endDate))

                index = index + 1
            }
            completion(true)
            return
        }
        healthStore?.execute(query)
    }
    
    func readStepsForDB(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let predicateTime = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicateTime,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in

            guard let results = results else{
                //print(results)
                completion(false)
                return
            }
            self.samplesToSyncSteps.removeAll()
            var index = 0
            for result in results{
                let sampleValues = results as? [HKQuantitySample]
                let valueToAdd = sampleValues?[index].quantity.doubleValue(for: HKUnit.count()) ?? 69
                
                self.samplesToSyncSteps.append(healthModelSample(uuid: result.uuid.uuidString, sampleType: result.sampleType.identifier, sampleValue: valueToAdd, startDate: result.startDate, endDate: result.endDate))

                index = index + 1
            }
            //print("index: " + String(index))
            /*var index2 = 0
            for result in results{
                print(self.samplesToSync[index2])
                index2 = index2 + 1
            }*/
            
            completion(true)
            return
        }
        healthStore?.execute(query)
    }
    
    func readDistanceRunningForDB(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let predicateTime = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicateTime,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in

            guard let results = results else{
                //print(results)
                completion(false)
                return
            }
            self.samplesToSyncDistanceRunning.removeAll()
            var index = 0
            for result in results{
                let sampleValues = results as? [HKQuantitySample]
                let valueToAdd = sampleValues?[index].quantity.doubleValue(for: HKUnit.meter()) ?? 69
                
                self.samplesToSyncDistanceRunning.append(healthModelSample(uuid: result.uuid.uuidString, sampleType: result.sampleType.identifier, sampleValue: valueToAdd, startDate: result.startDate, endDate: result.endDate))

                index = index + 1
            }
            //print("index: " + String(index))
            /*var index2 = 0
            for result in results{
                print(self.samplesToSync[index2])
                index2 = index2 + 1
            }*/
            
            completion(true)
            return
        }
        healthStore?.execute(query)
    }
    
    func readDistanceSwimmingForDB(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming)
        let predicateTime = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicateTime,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in

            guard let results = results else{
                //print(results)
                completion(false)
                return
            }
            self.samplesToSyncDistanceSwimming.removeAll()
            var index = 0
            for result in results{
                let sampleValues = results as? [HKQuantitySample]
                let valueToAdd = sampleValues?[index].quantity.doubleValue(for: HKUnit.meter()) ?? 69
                
                self.samplesToSyncDistanceSwimming.append(healthModelSample(uuid: result.uuid.uuidString, sampleType: result.sampleType.identifier, sampleValue: valueToAdd, startDate: result.startDate, endDate: result.endDate))

                index = index + 1
            }
            //print("index: " + String(index))
            /*var index2 = 0
            for result in results{
                print(self.samplesToSync[index2])
                index2 = index2 + 1
            }*/
            
            completion(true)
            return
        }
        healthStore?.execute(query)
    }
    
    func readDistanceWheelchairForDB(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWheelchair)
        let predicateTime = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicateTime,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in

            guard let results = results else{
                //print(results)
                completion(false)
                return
            }
            self.samplesToSyncDistanceWheelchair.removeAll()
            var index = 0
            for result in results{
                let sampleValues = results as? [HKQuantitySample]
                let valueToAdd = sampleValues?[index].quantity.doubleValue(for: HKUnit.meter()) ?? 69
                
                self.samplesToSyncDistanceWheelchair.append(healthModelSample(uuid: result.uuid.uuidString, sampleType: result.sampleType.identifier, sampleValue: valueToAdd, startDate: result.startDate, endDate: result.endDate))

                index = index + 1
            }
            //print("index: " + String(index))
            /*var index2 = 0
            for result in results{
                print(self.samplesToSync[index2])
                index2 = index2 + 1
            }*/
            
            completion(true)
            return
        }
        healthStore?.execute(query)
    }
    
    func readCyclingDistanceForDB(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)
        let predicateTime = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicateTime,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in

            guard let results = results else{
                //print(results)
                completion(false)
                return
            }
            self.samplesToSyncDistanceCycling.removeAll()
            var index = 0
            for result in results{
                let sampleValues = results as? [HKQuantitySample]
                let valueToAdd = sampleValues?[index].quantity.doubleValue(for: HKUnit.meter()) ?? 69
                
                self.samplesToSyncDistanceCycling.append(healthModelSample(uuid: result.uuid.uuidString, sampleType: result.sampleType.identifier, sampleValue: valueToAdd, startDate: result.startDate, endDate: result.endDate))

                index = index + 1
            }
            //print("index: " + String(index))
            /*var index2 = 0
            for result in results{
                print(self.samplesToSync[index2])
                index2 = index2 + 1
            }*/
            
            completion(true)
            return
        }
        healthStore?.execute(query)
    }
    
    func readHeartRateForDB(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        let predicateTime = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicateTime,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in

            guard let results = results else{
                //print(results)
                completion(false)
                return
            }
            self.samplesToSyncHeartRate.removeAll()
            var index = 0
            for result in results{
                let sampleValues = results as? [HKQuantitySample]
                let valueToAdd = sampleValues?[index].quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 69
                
                self.samplesToSyncHeartRate.append(healthModelSample(uuid: result.uuid.uuidString, sampleType: result.sampleType.identifier, sampleValue: valueToAdd, startDate: result.startDate, endDate: result.endDate))

                index = index + 1
            }
            //print("index: " + String(index))
            /*var index2 = 0
            for result in results{
                print(self.samplesToSync[index2])
                index2 = index2 + 1
            }*/
            
            completion(true)
            return
        }
        healthStore?.execute(query)
    }
    
    func readCaloriesForDB(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)
        let predicateTime = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: predicateTime,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in

            guard let results = results else{
                //print(results)
                completion(false)
                return
            }
            self.samplesToSyncCalories.removeAll()
            var index = 0
            for result in results{
                let sampleValues = results as? [HKQuantitySample]
                let valueToAdd = sampleValues?[index].quantity.doubleValue(for: HKUnit.kilocalorie()) ?? 69
                
                self.samplesToSyncCalories.append(healthModelSample(uuid: result.uuid.uuidString, sampleType: result.sampleType.identifier, sampleValue: valueToAdd, startDate: result.startDate, endDate: result.endDate))

                index = index + 1
            }
            //print("index: " + String(index))
            /*var index2 = 0
            for result in results{
                print(self.samplesToSync[index2])
                index2 = index2 + 1
            }*/
            
            completion(true)
            return
        }
        healthStore?.execute(query)
    }
    
    func writeDistanceRunning(distanceRunningValue: Double, dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        guard let distanceRunningType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning) else {
            print("Quantity type not available")
            return
        }
        let distanceRunningQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: Double(distanceRunningValue))
        let distanceRunningSample = HKQuantitySample(type: distanceRunningType, quantity: distanceRunningQuantity, start: dateStart, end: dateEnd)
        self.healthStore?.save(distanceRunningSample) { (success, error) in
            if (error != nil) {
              NSLog("error occurred saving distance running data")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    
    func readDistanceRunning(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void){
        guard let distanceRunningType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning) else {
            print("Quantity type not available")
            return
        }
        let s24hPredicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let distanceRunningQuery = HKStatisticsQuery(
                quantityType: distanceRunningType,
                quantitySamplePredicate: s24hPredicate,
                options: .cumulativeSum
            ) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    self.distanceRunningLabel = String(format: "%.2f km ran", 0)
                    completion(false)
                    return
                }

                self.distanceRunningLabel = String(format: "%.2f km ran", sum.doubleValue(for: HKUnit.meter())/1000)
                completion(true)
            }
        self.healthStore?.execute(distanceRunningQuery)
    }
    
    func writeDistanceCycling(distanceCyclingValue: Double, dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        guard let distanceCyclingType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling) else {
            print("Quantity type not available")
            return
        }
        let distanceCyclingQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: Double(distanceCyclingValue))
        let distanceCyclingSample = HKQuantitySample(type: distanceCyclingType, quantity: distanceCyclingQuantity, start: dateStart, end: dateEnd)
        self.healthStore?.save(distanceCyclingSample) { (success, error) in
            if (error != nil) {
              NSLog("error occurred saving distance cycled data")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    
    func readDistanceCycling(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void){
        guard let distanceCyclingType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling) else {
            print("Quantity type not available")
            return
        }
        let s24hPredicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let distanceCyclingQuery = HKStatisticsQuery(
                quantityType: distanceCyclingType,
                quantitySamplePredicate: s24hPredicate,
                options: .cumulativeSum
            ) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    self.distanceCycledLabel = String(format: "%.2f km cycled", 0)
                    completion(false)
                    return
                }

                self.distanceCycledLabel = String(format: "%.2f km cycled", sum.doubleValue(for: HKUnit.meter())/1000)
                completion(true)
            }
        self.healthStore?.execute(distanceCyclingQuery)
    }
    
    func writeDistanceSwimming(distanceSwimmingValue: Double, dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        guard let distanceSwimmingType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming) else {
            print("Quantity type not available")
            return
        }
        let distanceSwimmingQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: Double(distanceSwimmingValue))
        let distanceSwimmingSample = HKQuantitySample(type: distanceSwimmingType, quantity: distanceSwimmingQuantity, start: dateStart, end: dateEnd)
        self.healthStore?.save(distanceSwimmingSample) { (success, error) in
            if (error != nil) {
              NSLog("error occurred saving distance swimming data")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    
    func readDistanceSwimming(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void){
        guard let distanceSwimmingType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming) else {
            print("Quantity type not available")
            return
        }
        let s24hPredicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let distanceSwimmingQuery = HKStatisticsQuery(
                quantityType: distanceSwimmingType,
                quantitySamplePredicate: s24hPredicate,
                options: .cumulativeSum
            ) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    self.distanceSwimmingLabel = String(format: "%.2f km swam", 0)
                    completion(false)
                    return
                }

                self.distanceSwimmingLabel = String(format: "%.2f km swam", sum.doubleValue(for: HKUnit.meter())/1000)
                completion(true)
            }
        self.healthStore?.execute(distanceSwimmingQuery)
    }
    
    func writeDistanceWheelchair(distanceWheelchairValue: Double, dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        guard let distanceWheelchairType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWheelchair) else {
            print("Quantity type not available")
            return
        }
        let distanceWheelchairQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: Double(distanceWheelchairValue))
        let distanceWheelchairSample = HKQuantitySample(type: distanceWheelchairType, quantity: distanceWheelchairQuantity, start: dateStart, end: dateEnd)
        self.healthStore?.save(distanceWheelchairSample) { (success, error) in
            if (error != nil) {
              NSLog("error occurred saving distance wheelchair data")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    
    func readDistanceWheelchair(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void){
        guard let distanceWheelchairType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWheelchair) else {
            print("Quantity type not available")
            return
        }
        let s24hPredicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let distanceWheelchairQuery = HKStatisticsQuery(
                quantityType: distanceWheelchairType,
                quantitySamplePredicate: s24hPredicate,
                options: .cumulativeSum
            ) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    self.distanceWheelchairLabel = String(format: "%.2f km of distance covered while in wheelchair", 0)
                    completion(false)
                    return
                }

                self.distanceWheelchairLabel = String(format: "%.2f km of distance covered while in wheelchair", sum.doubleValue(for: HKUnit.meter())/1000)
                completion(true)
            }
        self.healthStore?.execute(distanceWheelchairQuery)
    }
    
    func readHeartRate(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void){
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            print("Quantity type not available")
            return
        }
        let s24hPredicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let heartRateQuery = HKStatisticsQuery(
                quantityType: heartRateType,
                quantitySamplePredicate: s24hPredicate,
                options: .discreteAverage
            ) { _, result, _ in
                guard let result = result, let avg: HKQuantity = result.averageQuantity() else {
                    self.distanceWheelchairLabel = String(format: "Avg %.2f beats per min", 0)
                    completion(false)
                    return
                }
                let beats: Double = avg.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                self.heartRateLabel = String(format: "Avg %.2f beats per min", beats)
                completion(true)
            }
        self.healthStore?.execute(heartRateQuery)
    }
    
    func writeCalories(caloriesValue: Double, dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void) {
        guard let caloriesType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
            print("Quantity type not available")
            return
        }
        let caloriesQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: Double(caloriesValue))
        let caloriesSample = HKQuantitySample(type: caloriesType, quantity: caloriesQuantity, start: dateStart, end: dateEnd)
        self.healthStore?.save(caloriesSample) { (success, error) in
            if (error != nil) {
              NSLog("error occurred saving calories data")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    
    func readCalories(dateStart: Date, dateEnd: Date, completion: @escaping(Bool) -> Void){
        guard let caloriesType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
            print("Quantity type not available")
            return
        }
        let s24hPredicate = HKQuery.predicateForSamples(withStart: dateStart, end: dateEnd, options: .strictEndDate)
        let caloriesQuery = HKStatisticsQuery(
                quantityType: caloriesType,
                quantitySamplePredicate: s24hPredicate,
                options: .cumulativeSum
            ) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    self.caloriesLabel = String(format: "%.2f kcals", 0)
                    completion(false)
                    return
                }

                self.caloriesLabel = String(format: "%.2f kcals", sum.doubleValue(for: HKUnit.kilocalorie()))
                completion(true)
            }
        self.healthStore?.execute(caloriesQuery)
    }
    
    var samplesToSyncWater:[healthModelSample] = [healthModelSample]()
    var samplesToSyncSteps:[healthModelSample] = [healthModelSample]()
    var samplesToSyncDistanceRunning:[healthModelSample] = [healthModelSample]()
    var samplesToSyncDistanceSwimming:[healthModelSample] = [healthModelSample]()
    var samplesToSyncDistanceCycling:[healthModelSample] = [healthModelSample]()
    var samplesToSyncDistanceWheelchair:[healthModelSample] = [healthModelSample]()
    var samplesToSyncHeartRate:[healthModelSample] = [healthModelSample]()
    var samplesToSyncCalories:[healthModelSample] = [healthModelSample]()
    
    struct healthModelSample{
        var uuid : String
        var sampleType : String
        var sampleValue : Double
        var startDate : Date
        var endDate : Date
    }
}


