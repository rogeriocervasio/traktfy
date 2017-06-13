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
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    var episodeArray: [Episode] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .none
        self.dateFormatter.timeZone = NSTimeZone.default
        
        self.timeFormatter.dateStyle = .none
        self.timeFormatter.timeStyle = .short
        self.timeFormatter.timeZone = NSTimeZone.default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.config()
    }
    
    func config() {
        
        print("NextViewController \(#function)")
        
        self.managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        self.fetchAllShows()
    }

    func fetchAllShows() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowEntity")
        var results: [AnyObject]
        do {
            try results = managedObjectContext!.fetch(fetchRequest)
            
            for show in results as! [ShowEntity] {
                
                print("NextViewController \(#function) - show.showTitle: \(String(describing: show.showTitle?.description)) - show.status: \(String(describing: show.status?.description)) - show.traktID: \(show.traktID)")
                
                if show.status == "returning series" {
                    self.getNextEpisode(traktID: Int(show.traktID), showName: show.showTitle?.description)
                }
            }
            
        } catch {
            print("Error when fetching ShowEntity: \(error)")
        }
    }
    
    func getNextEpisode(traktID: Int, showName: String?, completion: ((_ finished: Bool) -> Void)? = nil) {
        
        _ = Service.shared.getNextEpisode(traktID: traktID, extendedOptions: "full") { (finished, episode) in
            
            if finished && episode != nil {
                
                episode?.showTitle = showName
                
                self.episodeArray.append(episode!)
                let indexPath : NSIndexPath = NSIndexPath(row: (self.episodeArray.count > 0) ? self.episodeArray.count - 1 : 0, section: 0)
                
                print("NextViewController \(#function) - self.episodeArray.count: \(self.episodeArray.count) -  indexPath.row: \(indexPath.row)")
                
                self.tableView.insertRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
                
                //self.tableView.reloadData()
                self.tableView.flashScrollIndicators()
                
            }
            
            completion?(finished)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDelegate

extension NextViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.episodeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nextEpisodeCell", for: indexPath) as! NextTableViewCell
        
        let episode = self.episodeArray[indexPath.row]

        cell.labelSeriesName.text = (episode.showTitle != nil ? episode.showTitle :  "No name")
        cell.labelEpisode.text = "Season \(episode.season ?? 0) - Episode \(episode.number ?? 0)"
        cell.labelDate.text = (episode.firstAired != nil ? self.dateFormatter.string(from: episode.firstAired!) : "Unknown date")
        cell.labelTitle.text = (episode.title != nil ? episode.title! : "No title available")
        cell.labelTime.text = (episode.firstAired != nil ? self.timeFormatter.string(from: episode.firstAired!) : "Unknown time")
        cell.labelOverview.text = (episode.episodeOverview != nil ? episode.episodeOverview! : "No overview available")
        
        return cell
        
    }
}
