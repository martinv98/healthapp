//
//  databaseHelper.swift
//  HealthAppTest
//
//  Created by Martin Varga on 14/05/2022.
//

import Foundation
import SQLite3

class databaseHelper{
    var db : OpaquePointer?
    var path : String = "healthDatabase.sqlite"
    var listOfHealthData : [healthModelSample]
    init() {
        listOfHealthData = [healthModelSample]()
        self.db = createDB()
        self.createTable()
    }
    
    func createDB() -> OpaquePointer? {
        /*let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)*/
        let filePath = try? FileManager.default.url(for: .documentDirectory, in: .localDomainMask, appropriateFor: nil, create: true).appendingPathExtension(path)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath?.path, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        }else {
            print("Database has been created with path \(path)")
            return db
        }
    }
    
    func createTable()  {
        let query = "CREATE TABLE IF NOT EXISTS health_db9 (uuid TEXT PRIMARY KEY, sampleType TEXT, sampleValue DOUBLE, startDate TEXT, endDate TEXT);"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table creation success")
            }else {
                print("Table creation fail")
            }
        } else {
            print("Prepration fail")
        }
    }
    
    func insert(uuid : String, sampleType : String, sampleValue: Double, startDate: Date, endDate: Date){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateStartString = formatter.string(from: startDate)
        let dateEndString = formatter.string(from: endDate)
        
        let query = "INSERT INTO health_db9 (uuid, sampleType, sampleValue, startDate, endDate) VALUES (?, ?, ?, ?, ?);"
        
        var statement : OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (uuid as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (sampleType as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 3, sampleValue)
            sqlite3_bind_text(statement, 4, (dateStartString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (dateEndString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data inserted success")
            }else {
                print("Data is not inserted in table")
            }
        } else {
          print("Query is not as per requirement")
        }
        
    }

    struct healthModelSample{
        var uuid : String
        var sampleType : String
        var sampleValue : Double
        var startDate : Date
        var endDate : Date
    }
    
    func read() -> [healthModelSample]{
    //func read(){
        var mainList = [healthModelSample]()
        //var index = 0
        let query = "SELECT * FROM health_db9;"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let uuid = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let sampleType = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let sampleValue = Double(sqlite3_column_double(statement, 2))
                let startDateDB = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                let endDateDB = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let startDateFinal = dateFormatter.date(from: startDateDB)
                let endDateFinal = dateFormatter.date(from: endDateDB)
                
                let model = healthModelSample(uuid: uuid, sampleType: sampleType, sampleValue: Double(sampleValue), startDate: startDateFinal!, endDate: endDateFinal!)
                
                
                mainList.append(model)
                //print(mainList[index].sampleValue)
                //index = index + 1
            }
        }
        
        return mainList
    }
    
    /*func update(id : Int, name : String, result : String, avg : Int, list : [Grade]) {
        let data = try! JSONEncoder().encode(list)
        let listString = String(data: data, encoding: .utf8)
        let query = "UPDATE grade SET name = '\(name)', result = '\(result)', avg = \(avg), list = '\(listString!)' WHERE id = \(id);"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data updated success")
            }else {
                print("Data is not updated in table")
            }
        }
    }
    
    func delete(id : Int) {
        let query = "DELETE FROM grade where id = \(id)"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data delete success")
            }else {
                print("Data is not deleted in table")
            }
        }
    }*/
    
}
