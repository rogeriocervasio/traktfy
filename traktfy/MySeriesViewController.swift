//
//  MySeriesViewController.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 02/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit
import CoreData

class MySeriesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewSeries(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
        
        self.managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func addNewSeries(_ sender: Any) {
//        //
//    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueShowExpand" {
            
            print("MySeriesViewController \(#function)")
            
            let mySeriesDetailViewController = segue.destination as! MySeriesDetailViewController
            
            mySeriesDetailViewController.showEntity = sender as? ShowEntity
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mySeriesCell", for: indexPath) as! MySeriesTableViewCell
        let showEntity = self.fetchedResultsController.object(at: indexPath)
        self.configureCell(cell, withShow: showEntity)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let showEntity = self.fetchedResultsController.object(at: indexPath)
        
        print("MySeriesViewController \(#function) - show.showTitle: \(String(describing: showEntity.showTitle?.description)) - traktID: \(showEntity.traktID.description)")
        
        self.performSegue(withIdentifier: "segueShowExpand", sender: showEntity)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func configureCell(_ cell: UITableViewCell, withShow showEntity: ShowEntity) {
        let mySeries = cell as! MySeriesTableViewCell
        mySeries.labelTitle.text = showEntity.showTitle?.description
        let year = (showEntity.showYear > 0 ? "\(showEntity.showYear)" : "")
        let country = (showEntity.country != nil ? "| "+(showEntity.country?.description)! : "")
        let status = (showEntity.status != nil ? "| "+(showEntity.status?.description)! : "")
        
        mySeries.labelDetail.text = "\(year) \(String(describing: country)) \(String(describing: status))"
        
        let genresArray = showEntity.genres
        var genres = ""
        
        for genre in genresArray! {
            if genres.isEmpty {
                genres = genre
            } else {
                genres += ", \(genre)"
            }
        }
        
        mySeries.labelGenre.text = genres
        
        if let watchedEpisodesCount = self.fetchWatchedEpisodesByShowID(showID: showEntity.traktID) {
            if watchedEpisodesCount > 0 {                
                //print("watchedEpisodesCount: \(showEntity.airedEpisodes)/\(watchedEpisodesCount)")
                let percentageWatched = Double(watchedEpisodesCount*100)/Double(showEntity.airedEpisodes)
                mySeries.labelEpisodes.text = String(format: "Episódios assistidos \(watchedEpisodesCount)/\(showEntity.airedEpisodes) (%.1f%%)", percentageWatched)
            } else {
                mySeries.labelEpisodes.text = "Nenhum episódio assistido"
            }
        }
    }
    
    func fetchWatchedEpisodesByShowID(showID: Int32) -> Int? {
        //print("MySeriesViewController \(#function) - showID: \(showID)")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EpisodeEntity")
        fetchRequest.predicate = NSPredicate(format: "showID == %i AND watched == true", Int(showID))
        //fetchRequest.predicate = NSPredicate(format: "watched == true")
        
        var results: [AnyObject]
        do {
            try results = managedObjectContext!.fetch(fetchRequest)
        } catch {
            print("Error when fetching Episodes by showID: \(error)")
            return nil
        }
        
        return results.count
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<ShowEntity> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<ShowEntity> = ShowEntity.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "showTitle", ascending: false)
        
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
    var _fetchedResultsController: NSFetchedResultsController<ShowEntity>? = nil
    
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
            self.configureCell(tableView.cellForRow(at: indexPath!)!, withShow: anObject as! ShowEntity)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
