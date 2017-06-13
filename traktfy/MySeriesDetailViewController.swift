//
//  MySeriesDetailViewController.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 12/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit
import CoreData

class MySeriesDetailViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonFollow: RoundedButton!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelGenre: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    var showEntity: ShowEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MySeriesDetailViewController \(#function) - traktID: \((showEntity?.traktID)!)")
        
        self.config()
    }
    
    func config() {
        
        self.labelTitle.text = self.showEntity?.showTitle?.description
        
        self.labelOverview.text = self.showEntity?.showOverview?.description
        self.labelYear.text = "\((self.showEntity?.showYear)!)"
        self.managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueListEpisodes" {
            
            print("MySeriesDetailViewController \(#function)")
            
            let episodesViewController = segue.destination as! EpisodesViewController
            
            episodesViewController.seasonEntity = sender as? SeasonEntity
        }
        
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<SeasonEntity> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<SeasonEntity> = SeasonEntity.fetchRequest()
        
//        let entity = NSEntityDescription.entity(forEntityName: "SeasonEntity", in: self.managedObjectContext!)
//        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "showID == %i", (showEntity?.traktID)!)
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "seasonNumber", ascending: true)
        
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
    var _fetchedResultsController: NSFetchedResultsController<SeasonEntity>? = nil
    
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
            self.configureCell(tableView.cellForRow(at: indexPath!)!, withSeason: anObject as! SeasonEntity)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

}

// MARK: - Table view data source

extension MySeriesDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mySeasonCell", for: indexPath) as! SeasonTableViewCell
        let seasonEntity = self.fetchedResultsController.object(at: indexPath)
        self.configureCell(cell, withSeason: seasonEntity)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withSeason seasonEntity: SeasonEntity) {
        
        let mySeries = cell as! SeasonTableViewCell
        
        mySeries.labelSeason.text = "Season \(seasonEntity.seasonNumber)"
        mySeries.labelTitle.text = seasonEntity.seasonTitle?.description
        mySeries.labelOverview.text = seasonEntity.seasonOverview?.description
    }
}

extension MySeriesDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let seasonEntity = self.fetchedResultsController.object(at: indexPath)
        
        print("MySeriesDetailViewController \(#function) - season.seasonTitle: \(String(describing: seasonEntity.seasonTitle?.description)) - traktID: \(seasonEntity.showID.description)")
        
        self.performSegue(withIdentifier: "segueListEpisodes", sender: seasonEntity)
    }
}
