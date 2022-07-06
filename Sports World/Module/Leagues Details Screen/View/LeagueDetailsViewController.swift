//
//  LeagueDetailsViewController.swift
//  Sports World
//
//  Created by sherif on 06/06/2022.
//

import UIKit

class LeagueDetailsViewController: UIViewController {
    
    //MARK:-outlets :
    @IBOutlet weak var upComingCollectionView: UICollectionView!
    @IBOutlet weak var latestResultCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    //MARK:-vars
    
    var allEventsViewModel:AllEventsViewModel?
    var allresultViewModel:AllResultViewModel?
    var allTeamsViewModel : TeamsViewModel?
    var favouritesViewModel:FavouritesViewModel?
    
    var LeagueId:String?
    var leagueStr:String?
    var strImage:String?
    var urlYoutube:String?
    var arrLeagues:Countries?
    //MARK:-App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allEventsViewModel = AllEventsViewModel(services: APIServices())
        allresultViewModel = AllResultViewModel(services: APIServices())
        allTeamsViewModel = TeamsViewModel(services: APIServices())

        passDataToFirstCollection()
        passDataToSecondCollection()
        passDataToThirdCollection()
        
        allEventsViewModel?.fetchEvent(leagueId: LeagueId ?? "")
        allresultViewModel?.fetchResults(leagueId: LeagueId ?? "")
        allTeamsViewModel?.fetchTeams(StrLeague: leagueStr ?? "")
    }
    
    //MARK:-Function Helper
    
    
    //coreData
    
    @IBAction func addToFavourites(_ sender: UIBarButtonItem) {
        
        guard let leagueName  =  arrLeagues?.strLeague ,
              let leagueImage =  arrLeagues?.strBadge,
              let youtubeLink =  arrLeagues?.strYoutube,
              let leagueId    =  arrLeagues?.idLeague else {return}
        
        favouritesViewModel?.addToFavourite(leagueName: leagueName, leagueImg: leagueImage, youtubeLink: youtubeLink, LeagueId:leagueId )

        
//        favouritesViewModel?.saveData(leagueName: leagueName, leagueImg: leagueImage, youtubeLink: youtubeLink, LeagueId: leagueId)
    }
    
    
    func passDataToFirstCollection(){
        
        allEventsViewModel?.bindingResultEvents = { [weak self] in
            guard let self =  self  else{return}
            DispatchQueue.main.async {
                self.upComingCollectionView.reloadData()
            }
        }
    }
    
    
    func passDataToSecondCollection(){
        
        allresultViewModel?.bindingResults = { [weak self] in
            guard let self =  self  else{return}
            DispatchQueue.main.async {
                self.latestResultCollectionView.reloadData()
            }
        }
    }
    
    
    func passDataToThirdCollection(){
        
        allTeamsViewModel?.bindingResultTeams = { [weak self] in
            guard let self =  self  else{return}
            DispatchQueue.main.async {
                self.teamsCollectionView.reloadData()
            }
        }
    }
    
  
    
}
//MARK:- Extensions
extension LeagueDetailsViewController :
    UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == upComingCollectionView {
            
            return allEventsViewModel?.numberOfItemInsection() ?? 0
            
        }else if collectionView == latestResultCollectionView{
            
            return allresultViewModel?.numberOfItemInsection() ?? 0
        }else{
            
            return allTeamsViewModel?.numberOfItemInsection() ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == upComingCollectionView {
            // First Collection Latest Events
            guard  let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentififer, for: indexPath) as? UPComingEventCollectionCell else{ return
                UICollectionViewCell()
            }
            cell.eventNameLBL.text = allEventsViewModel?.EventsData?.events?[indexPath.row].strEvent
            cell.eventDateLBL.text = allEventsViewModel?.EventsData?.events?[indexPath.row].dateEvent
            cell.eventTimeLBL.text = allEventsViewModel?.EventsData?.events?[indexPath.row].strTimestamp
            return cell
            
        }else if collectionView == latestResultCollectionView{   // SecondCollectionView Latest Result
            
            guard  let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentififer, for: indexPath) as? LatestResultCollectionCell else{ return
                UICollectionViewCell()
            }
            cell.fisrScoreLBL.text = allresultViewModel?.resultData?.events?[indexPath.row].intHomeScore
            cell.secondScoreLBL.text = allresultViewModel?.resultData?.events?[indexPath.row].intAwayScore
            if let image = allresultViewModel?.resultData?.events?[indexPath.row].strThumb{
                cell.resultImageView.sd_setImage(with: URL(string: (image)), placeholderImage: UIImage(named: Constants.placeholderImage))
            }
            return cell
        }else{
            guard  let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentififer, for: indexPath) as? TeamsCollectionCell else{ return
                UICollectionViewCell()
            }
            
            if let image = allTeamsViewModel?.TeamsData?.teams[indexPath.row].strTeamBadge{
                cell.teamsImageView.sd_setImage(with: URL(string: (image)), placeholderImage: UIImage(named: Constants.placeholderImage))
            }
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == teamsCollectionView{
            
            self.performSegue(withIdentifier: Constants.TeamDetailsSegue, sender: indexPath)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == upComingCollectionView {
            
            return CGSize(width: upComingCollectionView.bounds.size.width - 30 , height: 200)
            
        }else if collectionView == latestResultCollectionView {
            
            return CGSize(width: latestResultCollectionView.bounds.size.width - 30 , height: 200)
            
        }else{
            return CGSize(width: teamsCollectionView.bounds.size.width - 30 , height: 200)
        }
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }

   
    
    
}
//MARK:-league details Extension 
extension LeagueDetailsViewController{
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.TeamDetailsSegue{
            guard let selectedIndexPath = sender as? NSIndexPath else{ return }
            guard let teamDetailsVC = segue.destination as? TeamDetailsViewController else {return}
            teamDetailsVC.teamInfo = allTeamsViewModel?.TeamsData?.teams[selectedIndexPath.row]
            }
            
        }
  
    
}
