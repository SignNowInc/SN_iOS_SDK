//
//  ContractTableViewCell.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 29.09.2021.
//

import Foundation
import UIKit

class ContractTableViewCell: UITableViewCell {
    
    var contract: ContractProvider.ContractData! {
        didSet {
            fill()
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var clientUserpicImageView: UIImageView!
    
    private func fill() {
        
        nameLabel.text = contract.document.metaData.name
        clientUserpicImageView.image = contract.client.userpic
        thumbnailImageView.image = contract.thumbnail
    }
}
