//
//  ShowDetailViewController.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 10/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit
import CoreData

class ShowDetailViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonFollow: UIButton!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelGenre: UILabel!
    @IBOutlet weak var labelOverview: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    var seasonArray: [Season] = []
    
    var show: Show?
    var showEntity: ShowEntity?
    
//    var show: Show? {
//        didSet {
//            self.config()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ShowDetailViewController \(#function) - \((self.show?.showTitle)!)")
        
        self.labelTitle.text = (self.show?.showTitle)!
        
        self.config()
    }

    func config() {
        
        print("ShowDetailViewController \(#function)")
        
//        if self.show == nil {
//            return
//        }
        
        self.managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        if self.fetchShowByID(traktID: (self.show?.traktID)!) != nil {
            self.buttonFollow.isSelected = true
            self.buttonFollow.backgroundColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
            self.buttonFollow.isEnabled = false
        }
        
        self.getSeasons(traktID: (self.show?.traktID)!)
    }
    
    func fetchShowByID(traktID: Int) -> ShowEntity? {
        
        print("ShowDetailViewController \(#function)")
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowEntity")
        fetchRequest.predicate = NSPredicate(format: "traktID == %i", traktID)
        
        var results: [AnyObject]
        do {
            try results = managedObjectContext!.fetch(fetchRequest)
        } catch {
            print("Error when fetching Show by traktID: \(error)")
            return nil
        }
        
        return results.first as? ShowEntity
    }
    
    @IBAction func followNewShow(_ sender: UIButton) {
        
        print("ShowDetailViewController \(#function) - self.show?.traktID: \((self.show?.traktID)!)")
        
        self.buttonFollow.isSelected = true
        self.buttonFollow.backgroundColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
        self.buttonFollow.isEnabled = false
        
        //let newShow = NSEntityDescription.insertNewObject(forEntityName: "ShowEntity", into: self.managedObjectContext!) as? ShowEntity
    
        let newShow = ShowEntity(context: self.managedObjectContext!)
        
        newShow.type       = (self.show?.type)!
        newShow.score      = Double((self.show?.score)!)
        newShow.showTitle  = (self.show?.showTitle)!
        newShow.showYear   = Int16((self.show?.showYear)!)
        newShow.traktID    = Int32((self.show?.traktID)!)
        newShow.traktSlug  = (self.show?.traktSlug)!
        newShow.traktImdb  = (self.show?.traktImdb)!
        newShow.traktTmdb  = Int32((self.show?.traktTmdb)!)
        newShow.traktTvrage  = (self.show?.traktTvrage != nil ? (self.show?.traktTvrage)! : nil)
        newShow.showOverview = (self.show?.showOverview)!
        
        newShow.firstAired      = (self.show?.firstAired)!
        newShow.airsDay         = (self.show?.airsDay)!
        newShow.airsTime        = (self.show?.airsTime)!
        newShow.airsTimezone    = (self.show?.airsTimezone)!
        newShow.runtime         = Int32((self.show?.runtime)!)
        newShow.certification   = (self.show?.certification)!
        newShow.network         = (self.show?.network)!
        newShow.country         = (self.show?.country)!
        newShow.trailer         = (self.show?.trailer != nil ? (self.show?.trailer)! : nil)
        newShow.homepage        = (self.show?.homepage != nil ? (self.show?.homepage)! : nil)
        newShow.status          = (self.show?.status)!
        newShow.rating          = (self.show?.rating)!
        newShow.votes           = Int32((self.show?.votes)!)
        newShow.updatedAt       = (self.show?.updatedAt)!
        newShow.language        = (self.show?.language)!
        newShow.availableTranslations = (self.show?.availableTranslations)!
        newShow.genres          = (self.show?.genres)!
        newShow.airedEpisodes   = Int32((self.show?.airedEpisodes)!)
        
        do {
            try self.managedObjectContext?.save()
        } catch let error {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getSeasons(traktID: Int, completion: ((_ finished: Bool) -> Void)? = nil) {
        
        _ = Service.shared.getShowSeasons(traktID: traktID, extendedOptions: "full") { (finished, seasons) in
            
            if finished && seasons != nil {
                
                if (seasons?.count)! > 0 {
                    
                    self.seasonArray.append(contentsOf: seasons!)
                    self.tableView.reloadData()
                    self.tableView.flashScrollIndicators()
                }
            }
            
            completion?(finished)
        }

        
    }
}

// MARK: - UITableViewDelegate

extension ShowDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.seasonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let season = self.seasonArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as! SeasonTableViewCell
        
        cell.labelSeason.text = "\(season.number ?? 0)"
        cell.labelTitle.text = season.title
        cell.labelOverview.text = season.seasonOverview
        
        return cell
        
    }
}

extension ShowDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let season = self.seasonArray[indexPath.row]
        
        print("ShowDetailViewController \(#function) - Title: \(String(describing: season.title!)) - showID: \(season.showID ?? 0)")
        
        self.performSegue(withIdentifier: "segueShowDetail", sender: show)
    }
    
}
