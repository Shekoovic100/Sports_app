//
//  LeagueTableViewCell.swift
//  Sports World
//
//  Created by sherif on 05/06/2022.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {


    @IBOutlet weak var cellContentView: UIView!{
        didSet{
           
            cellContentView.layer.borderColor = UIColor.black.cgColor
            cellContentView.layer.borderWidth = 1.0
            cellContentView.layer.cornerRadius = cellContentView.layer.frame.height / 4
        }
    }
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var legaueNameLBL: UILabel!
    @IBOutlet weak var leagueBadgeImageView: UIImageView!{
        didSet{
            leagueBadgeImageView.layer.cornerRadius = leagueBadgeImageView.frame.size.width / 4
        }
    }
    var alllegues: AllLeagues?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    @IBAction func youtubeButtonPressed(_ sender: UIButton) {
        
        let youtubeId = alllegues?.countries?[0].strYoutube
        var youtubeUrl = NSURL(string:"youtube://\(String(describing: youtubeId))")!
        if UIApplication.shared.canOpenURL(youtubeUrl as URL){
            UIApplication.shared.openURL(youtubeUrl as URL)
         } else{
             youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(String(describing: youtubeId))")!
             UIApplication.shared.openURL(youtubeUrl as URL)
         }
  
        }
        
 
    
    
  
}
