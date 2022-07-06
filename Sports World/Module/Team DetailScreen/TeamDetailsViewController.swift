//
//  TeamDetailsViewController.swift
//  Sports World
//
//  Created by sherif on 14/06/2022.
//

import UIKit
import SDWebImage
class TeamDetailsViewController: UIViewController {
   
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var countryLBL: UILabel!
    @IBOutlet weak var leagueLBL: UILabel!
    @IBOutlet weak var stadiumLBL: UILabel!
    @IBOutlet weak var SportLBL: UILabel!
    
    var teamInfo:Teams?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamDetailsInfo()
        
    }
    
    func teamDetailsInfo(){
        teamImageView.sd_setImage(with: URL(string: "\(teamInfo?.strTeamBadge ?? "")"), placeholderImage: UIImage(named: Constants.placeholderImage))
        countryLBL.text = teamInfo?.strCountry
        leagueLBL.text = teamInfo?.strLeague
        SportLBL.text = teamInfo?.strSport
        stadiumLBL.text = teamInfo?.strStadium
    }

}
