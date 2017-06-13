//
//  NextViewController.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 12/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit
import CoreData

class NextViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext? = nil

    @IBOutlet weak var tableView: UITableView!

    var episodeArray: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.config()
    }
    
    func config() {
        
        print("ShowDetailViewController \(#function)")
        
        self.managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        self.fetchAllShows()
    }

    func fetchAllShows() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowEntity")
        var results: [AnyObject]
        do {
            try results = managedObjectContext!.fetch(fetchRequest)
            
            for show in results as! [ShowEntity] {
                if show.status == "returning series" {
                    
                }
                //self.getSeasons(traktID: (self.show?.traktID)!)
            }
            
        } catch {
            print("Error when fetching ShowEntity: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
