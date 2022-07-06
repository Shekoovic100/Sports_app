//
//  FavouritesViewModel.swift
//  Sports World
//
//  Created by sherif on 15/06/2022.
//


import UIKit
import CoreData

class FavouritesViewModel {
    
    var sportData:[Countries]?
    var legaueDataBinding:(()->()) = {}
    var legueData:[NSManagedObject]?
    
    init(sportData:[Countries]){
        self.sportData = sportData
    }
    
//    func saveData(leagueName:String,leagueImg:String,youtubeLink:String,LeagueId:String){
//
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//
//        guard let viewContext = viewContext else {return}
//
//    guard let entity = NSEntityDescription.entity(forEntityName: "Favourites",
//                                                         in: viewContext) else { return }
//
//           let leg = NSManagedObject(entity: entity,
//                                insertInto: viewContext)
//           leg.setValue(LeagueId, forKey: "leagueId")
//           leg.setValue(leagueImg, forKey: "legueImage")
//           leg.setValue(leagueName, forKey: "leagueName" )
//           leg.setValue(youtubeLink, forKey: "LeagueYoutubeUrl")
//
//           appDelegate.saveContext()
//           print("saved")
//
//    }

    func addToFavourite(leagueName:String,leagueImg:String,youtubeLink:String,LeagueId:String){

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favourites", in: manageContext)!
        let favouriteLeague = NSManagedObject(entity: entity, insertInto: manageContext)
        favouriteLeague.setValue(leagueName, forKey: "leagueName")
        favouriteLeague.setValue(leagueImg, forKey: "legueImage")
        favouriteLeague.setValue(youtubeLink, forKey: "LeagueYoutubeUrl")
        favouriteLeague.setValue(LeagueId, forKey: "leagueId")
        appDelegate.saveContext()
        self.legaueDataBinding()
        do{

            try manageContext.save()
            self.legueData?.append(favouriteLeague)
            self.sportData = legueData as? [String] as? [Countries]
            self.legaueDataBinding()

        }catch let error{
            print(error.localizedDescription)
        }
    }

    
    func FetchData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchedRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourites")
        do{
            legueData = try manageContext.fetch(fetchedRequest)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func deleteData(leagueId:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourites")
        let predicate = NSPredicate(format: "leagueId == %@", leagueId)
        fetchRequest.predicate = predicate
        
        if let data = try? manageContext.fetch(fetchRequest){
            for index in data{
                manageContext.delete(index)
                 try? manageContext.save()
            }
        }
    }
}
