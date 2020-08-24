//
//  DBManager.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/22.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class DBManager{
    //MARK: Singleton
    static let sharedInstance = DBManager()
    
    private var database: Realm
    
    private init() {
        //https://stackoverflow.com/questions/33363508/rlmexception-migration-is-required-for-object-type
        var configuration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {

                    // if just the name of your model's property changed you can do this
                    //migration.renameProperty(onType: NotSureItem.className(), from: "text", to: "title")

                    // if you want to fill a new property with some values you have to enumerate
                    // the existing objects and set the new value
                    //migration.enumerateObjects(ofType: NotSureItem.className()) { oldObject, newObject in
                    //    let text = oldObject!["text"] as! String
                    //    newObject!["textDescription"] = "The title is \(text)"
                    //}

                    // if you added a new property or removed a property you don't
                    // have to do anything because Realm automatically detects that
                }
            }
        )
        Realm.Configuration.defaultConfiguration = configuration
        self.database = try! Realm()
    }
    
    func getCurrentSearchTextWithSTRFromDB(searchString string: String, returnData: @escaping(_ result: Results<currentSearchData>) -> Void ) {
        let results : Results<currentSearchData> = self.database.objects(currentSearchData.self)
        let data = results.filter("text CONTAINS '\(string)'")
        returnData(data)
    }
    
    func getCurrentSearchTextFromDB(returnData: @escaping(_ result: Results<currentSearchData>) -> Void){
        DispatchQueue.main.async {
            let results : Results<currentSearchData> = self.database.objects(currentSearchData.self)
            let data = self.database.objects(currentSearchData.self).sorted(byKeyPath: "text", ascending: true)
            dprint("Get current Search Text From Db : \(data) && \(results)")
            returnData(results)
        }
    }
    
    func addCurrentSearchText(string: String) {
        DispatchQueue.main.async {
            self.getSpecificCurrentSearchTextFromDB(string: string) { (element) in
                if let _element = element, _element.text.elementsEqual(string)  {
                    self.deleteCurrentSearchText(string: string)
                }
                let currentItem = currentSearchData(text: string)
                do {
                    dprint("Check add current text : \(currentItem)")
                    try self.database.write{
                        self.database.add(currentItem)
                        dprint("New Data!")
                    }
                }catch{
                    dprint("Check Error! : addCurrentSearchText : \(error)")
                }
            }
        }
    }
    
    func getSpecificCurrentSearchTextFromDB(string: String, returnData: @escaping(_ result : currentSearchData?) -> Void) {
        DispatchQueue.main.async {
            let results : Results<currentSearchData> = self.database.objects(currentSearchData.self)
            let data = results.filter("text == '\(string)'").first
            dprint("Check specific current search text from db : \(results) && \(data) - \(string)")
            returnData(data)
        }
    }
    
    func deleteAllCurrentSearchText() {
        DispatchQueue.main.async {
            do {
                try self.database.write{
                    self.database.deleteAll()
                }
            }catch{
                dprint("Check Error! : deleteAllCurrentSearchText : \(error)")
            }
        }
    }
    
    func deleteCurrentSearchText(string: String) {
        self.getSpecificCurrentSearchTextFromDB(string: string) { (result) in
            //main queue
            guard let _result = result else {return}
            do {
                try self.database.write{
                    self.database.delete(_result)
                }
            }catch {
                dprint("delete Search Text Error \(string) || \(error)")
            }
        }
        
    }
}
