//
//  EpisodesViewController.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 12/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit
import CoreData

class EpisodesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var seriesTitle: String?
    var seasonEntity: SeasonEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EpisodesViewController \(#function) - traktID: \((seasonEntity?.showID)!)")
        
        self.config()
    }
    
    func config() {
        
        self.navigationItem.title = self.seriesTitle!
        
        self.managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        if self.fetchEpisodesBySeasonID(seasonID: (seasonEntity?.seasonID)!) == nil {
            self.getEpisodesFromAPI(traktID: Int((seasonEntity?.showID)!), seasonNumber: (seasonEntity?.seasonNumber)!)
        }
    }
    
    func fetchEpisodesBySeasonID(seasonID: Int32) -> EpisodeEntity? {
        print("EpisodesViewController \(#function) - seasonID: \(seasonID)")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EpisodeEntity")
        fetchRequest.predicate = NSPredicate(format: "seasonID == %i", seasonID)
        
        var results: [AnyObject]
        do {
            try results = self.managedObjectContext!.fetch(fetchRequest)
        } catch {
            print("Error when fetching Episode by seasonID: \(error)")
            return nil
        }
        
        return results.first as? EpisodeEntity
    }
    
    func getEpisodesFromAPI(traktID: Int, seasonNumber: Int32, completion: ((_ finished: Bool) -> Void)? = nil) {
        
        _ = Service.shared.getSeasonEpisodes(traktID: traktID, seasonNumber: seasonNumber, extendedOptions: "full") { (finished, episodes) in
            
            if finished && episodes != nil {
                
                if (episodes?.count)! > 0 {

                    for episode in episodes! {
                        
                        let newEpisode = EpisodeEntity(context: self.managedObjectContext!)
                        
                        newEpisode.watched      = false
                        newEpisode.showID       = Int32((self.seasonEntity?.showID)!)
                        newEpisode.seasonID     = Int32((self.seasonEntity?.seasonID)!)
                        
                        newEpisode.season       = Int32(episode.season!)
                        newEpisode.number       = Int32(episode.number!)
                        newEpisode.title        = (episode.title != nil ? episode.title! : nil)
                        newEpisode.episodeID    = Int32(episode.episodeID!)
                        newEpisode.episodeTvdb  = Int32(episode.episodeTvdb!)
                        newEpisode.episodeImdb  = (episode.episodeImdb != nil ? episode.episodeImdb! : nil)
                        newEpisode.episodeTmdb  = (episode.episodeTmdb != nil ? Int32(episode.episodeTmdb!) : 0)
                        newEpisode.episodeTvrage = (episode.episodeImdb != nil ? episode.episodeImdb! : nil)
                        newEpisode.numberAbs    = (episode.numberAbs != nil ? Int32(episode.numberAbs!) : 0)
                        newEpisode.episodeOverview  = (episode.episodeOverview != nil ? episode.episodeOverview! : nil)
                        newEpisode.rating       = episode.rating!
                        newEpisode.votes        = (episode.votes != nil ? Int32(episode.votes!) : 0)
                        newEpisode.firstAired   = (episode.firstAired != nil ? episode.firstAired! : nil)
                        newEpisode.updatedAt    = (episode.updatedAt != nil ? episode.updatedAt! : nil)
                        newEpisode.availableTranslations = (episode.availableTranslations != nil ? episode.availableTranslations! : nil)
                        
                    }
                    
                    do {
                        try self.managedObjectContext?.save()
                    } catch let error {
                        print(error)
                    }
                }
            }
            
            completion?(finished)
        }
    }

    @IBAction func actionWatched(sender: UIButton) {
        print("EpisodesViewController \(#function) - episodeID: \(sender.tag)")
        
//        if let episode = self.fetchByEpisodeID(episodeID: Int32(sender.tag)) {
//            
//            episode.watched = !episode.watched
//        }
        
        self.fetchByEpisodeID(episodeID: Int32(sender.tag))
    }
    
    func fetchByEpisodeID(episodeID: Int32){
        print("EpisodesViewController \(#function) - episodeID: \(episodeID)")
        
        let fetchRequest = NSFetchRequest<EpisodeEntity>(entityName: "EpisodeEntity")
        fetchRequest.predicate = NSPredicate(format: "episodeID == %i", episodeID)
        
        var results: [AnyObject]
        do {
            try results = managedObjectContext!.fetch(fetchRequest)
            
            let episode = results.first as? EpisodeEntity
            
            if !(episode?.watched)! {
                episode?.watched = true
            } else {
                episode?.watched = false
            }
            //episode?.watched = !(episode?.watched)!
            
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print(error)
            }
            
        } catch {
            print("Error when fetching Episode by episodeID: \(error)")
            //return nil
        }
        
        //return results.first as? EpisodeEntity
        //return episode
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<EpisodeEntity> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<EpisodeEntity> = EpisodeEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "seasonID == %i", (seasonEntity?.seasonID)!)
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 30
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<EpisodeEntity>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, withEpisode: anObject as! EpisodeEntity)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
}

// MARK: - Table view data source

extension EpisodesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEpisodeCell", for: indexPath) as! EpisodeTableViewCell
        let episodeEntity = self.fetchedResultsController.object(at: indexPath)
        self.configureCell(cell, withEpisode: episodeEntity)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withEpisode episodeEntity: EpisodeEntity) {
        
        let myEpisode = cell as! EpisodeTableViewCell
        
        myEpisode.labelEpisode.text = "Episode \(episodeEntity.number)"
        myEpisode.labelTitle.text = episodeEntity.title?.description
        myEpisode.buttonWatched.tag = Int(episodeEntity.episodeID)
        myEpisode.buttonWatched.backgroundColor = (episodeEntity.watched ? #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1) : #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1))
        myEpisode.labelOverview.text = episodeEntity.episodeOverview?.description
    }
}
