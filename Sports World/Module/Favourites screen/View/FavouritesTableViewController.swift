//
//  FavouritesTableViewController.swift
//  Sports World
//
//  Created by sherif on 15/06/2022.
//

import UIKit
import SDWebImage

class FavouritesTableViewController: UITableViewController {
    
    var favouriteViewModel:FavouritesViewModel?
    var sportData:[Countries]?
    
    
    //MARK:-applife cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouriteViewModel = FavouritesViewModel(sportData: sportData ?? [])
        favouriteViewModel?.legaueDataBinding = { [weak self]  in
            guard let self = self else{return}
            DispatchQueue.main.async {
                self.favouriteViewModel?.FetchData()
                self.tableView.reloadData()
            }
            
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return favouriteViewModel?.legueData?.count ?? 0

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")as? FavouriteCell else{return
            UITableViewCell()
        }
        cell.leagueImgView.sd_setImage(with: URL(string: (favouriteViewModel?.legueData?[indexPath.row].value(forKey: "legueImage") as? String ?? "")) ,  placeholderImage: UIImage(named: Constants.placeholderImage))
        cell.leagueNameLBL.text = favouriteViewModel?.legueData?[indexPath.row].value(forKey: "leagueName") as? String
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.leagueDetailsSegue, sender: nil)
    }

}
//MARK:- favouritesController Extension
extension FavouritesTableViewController {
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == Constants.leagueDetailsSegue{
            guard let selectedIndexPath = sender as? NSIndexPath else{ return }
            let detailLeagueVC = segue.destination as! LeagueDetailsViewController
            guard let leagueCoreData = favouriteViewModel?.legueData?[selectedIndexPath.row]else {return}
            let leagueDetails = LeagueCoredataModel(leagueName: leagueCoreData.value(forKey: "leagueName")as! String, leagueImg: leagueCoreData.value(forKey: "legueImage")as! String, leagueId: leagueCoreData.value(forKey: "leagueId")as! String, youtubeUrl: leagueCoreData.value(forKey: "leagueYoutubeUrl")as! String)
            
            detailLeagueVC.LeagueId = leagueDetails.leagueId
            detailLeagueVC.leagueStr = leagueDetails.leagueName
            detailLeagueVC.strImage = leagueDetails.leagueImg
            detailLeagueVC.urlYoutube = leagueDetails.youtubeUrl
        }
    }
    
}
