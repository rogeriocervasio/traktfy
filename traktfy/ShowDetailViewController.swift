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

}
