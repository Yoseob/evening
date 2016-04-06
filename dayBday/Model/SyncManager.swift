//
//  SyncManager.swift
//  dayBday
//
//  Created by LeeYoseob on 2016. 3. 26..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

import UIKit
import SwiftyDropbox
import CloudKit

class SyncManager {
    
    static let sharedInstance = SyncManager()
    
    init() {
        
    }
    
    func changeICloudState(state: Bool){
        if state{
            
//            print(SqlConnection.staticDbPath())
//            let documentUrl = NSURL(fileURLWithPath: SqlConnection.staticDbPath())
//            let document = UIManagedDocument(fileURL: documentUrl)
////            document.persistentStoreOptions = ["NSMigratePersistentStoresAutomaticallyOption": true, "NSInferMappingModelAutomaticallyOption": true]
//        
//            if NSFileManager.defaultManager().fileExistsAtPath(documentUrl.path!) {
//                document.openWithCompletionHandler({ success in
//                    if success {
//                        
//                    }else{
//                        
//                    }
//                })
//            }else {
//                document.saveToURL(documentUrl, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: { success in
//                    if success {
//                        
//                    }else{
//                        
//                    }
//                })
//            }
//        }else{
//            
        }
    }
    
    
    func backupToDropBox(){
    
    }
    
    func restoreFromDropBox(){
    }
    
    func unlinkAmongDropBox(){
    }
    

    
    
}
