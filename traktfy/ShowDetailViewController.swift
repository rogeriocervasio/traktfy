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
    @IBOutlet weak var buttonFollow: RoundedButton!
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
        self.labelYear.text = "\((self.show?.showYear)!)"
        self.labelOverview.text = (self.show?.showOverview)!
        
        self.config()
    }

    func config() {
        
        print("ShowDetailViewController \(#function)")
        
//        if self.show == nil {
//            return
//        }
        
        self.managedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        if self.fetchShowByID(traktID: (self.show?.traktID)!) != nil {
//            self.buttonFollow.isSelected = true
            self.buttonFollow.backgroundColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
//            self.buttonFollow.setTitleColor(#colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1), for: .normal)
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
        
//        self.buttonFollow.isSelected = true
        self.buttonFollow.backgroundColor = #colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1)
//        self.buttonFollow.setTitleColor(#colorLiteral(red: 0.2176683843, green: 0.8194433451, blue: 0.2584097683, alpha: 1), for: .selected)
        self.buttonFollow.isEnabled = false
        
        //let newShow = NSEntityDescription.insertNewObject(forEntityName: "ShowEntity", into: self.managedObjectContext!) as? ShowEntity
    
        let newShow = ShowEntity(context: self.managedObjectContext!)
        
        newShow.type       = (self.show?.type)!
        newShow.score      = Double((self.show?.score)!)
        newShow.showTitle  = (self.show?.showTitle)!
        newShow.showYear   = Int16((self.show?.showYear)!)
        newShow.traktID    = Int32((self.show?.traktID)!)
        newShow.traktSlug  = (self.show?.traktSlug)!
        newShow.traktImdb  = (self.show?.traktImdb != nil ? (self.show?.traktImdb)! : nil)
        newShow.traktTmdb  = (self.show?.traktTmdb != nil ? Int32((self.show?.traktTmdb)!) : nil)!
        newShow.traktTvrage  = (self.show?.traktTvrage != nil ? (self.show?.traktTvrage)! : nil)
        newShow.showOverview = (self.show?.showOverview)!
        
        newShow.firstAired      = (self.show?.firstAired != nil ? (self.show?.firstAired)! : nil)
        newShow.airsDay         = (self.show?.airsDay)!
        newShow.airsTime        = (self.show?.airsTime)!
        newShow.airsTimezone    = (self.show?.airsTimezone)!
        newShow.runtime         = Int32((self.show?.runtime)!)
        newShow.certification   = (self.show?.certification)!
        newShow.network         = (self.show?.network)!
        newShow.country         = (self.show?.country)!
        newShow.trailer         = (self.show?.trailer != nil ? (self.show?.trailer)! : nil)
        newShow.homepage        = (self.show?.homepage != nil ? (self.show?.homepage)! : nil)
        newShow.status          = (self.show?.status != nil ? (self.show?.status)! : nil)
        newShow.rating          = (self.show?.rating)!
        newShow.votes           = Int32((self.show?.votes)!)
        newShow.updatedAt       = (self.show?.updatedAt != nil ? (self.show?.updatedAt)! : nil)
        newShow.language        = (self.show?.language)!
        newShow.availableTranslations = (self.show?.availableTranslations)!
        newShow.genres          = (self.show?.genres)!
        newShow.airedEpisodes   = Int32((self.show?.airedEpisodes)!)
        
        if self.seasonArray.count > 0 {
            for season in seasonArray {
                
                let newSeason = SeasonEntity(context: self.managedObjectContext!)
                
                newSeason.watched       = false
                newSeason.showID        = Int32((self.show?.traktID)!)
                newSeason.seasonNumber  = Int32(season.seasonNumber!)
                newSeason.seasonID      = Int32(season.seasonID!)
                newSeason.seasonTvdb    = (season.seasonTvdb != nil ? Int32(season.seasonTvdb!) : 0)
                newSeason.seasonTmdb    = (season.seasonTmdb != nil ? Int32(season.seasonTmdb!) : 0)
                newSeason.seasonTvrage  = (season.seasonTvrage != nil ? season.seasonTvrage! : nil)
                newSeason.seasonRating  = season.seasonRating!
                newSeason.seasonVotes   = Int32(season.seasonVotes!)
                newSeason.episodeCount  = Int32(season.episodeCount!)
                newSeason.airedEpisodes = Int32(season.airedEpisodes!)
                newSeason.seasonTitle   = (season.seasonTitle != nil ? season.seasonTitle! : nil)
                newSeason.seasonOverview = (season.seasonOverview != nil ? season.seasonOverview! : nil)
                newSeason.firstAired    = (season.firstAired != nil ? season.firstAired! : nil)
            }
        }
        
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
                    let filteredSeasons = seasons?.filter({ $0.seasonNumber! > 0})
                    self.seasonArray.append(contentsOf: filteredSeasons!)
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
        
        cell.labelSeason.text = "\(season.seasonNumber ?? 0)"
        cell.labelTitle.text = season.seasonTitle
        cell.labelOverview.text = season.seasonOverview
        
        return cell
        
    }
}

extension ShowDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let season = self.seasonArray[indexPath.row]
        
        print("ShowDetailViewController \(#function) - Title: \(String(describing: season.seasonTitle!))")
        
        self.performSegue(withIdentifier: "segueShowDetail", sender: show)
    }
    
}
