//
//  ClientListTableViewCell.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 30.08.2021.
//

import Foundation
import UIKit


class ClientListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var userpicImageView: UIImageView!
    
    var client: Client! {
        didSet {
            
            fill()
        }
    }
    
    private func fill() {
        
        nameLabel.text = client.username
        rateLabel.text = "\(client.rating)"
        userpicImageView.image = client.userpic
    }
}
