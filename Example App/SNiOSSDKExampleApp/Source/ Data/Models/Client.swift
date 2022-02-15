//
//  Client.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 30.08.2021.
//

import Foundation
import UIKit

struct Client {
    
    var username: String
    var email: String
    var userpic: UIImage?
    var rating: Int
    
    static func mockClients() -> [Client] {
        
        return [Client(username: "Devon Lane",
                       email: "Devon.Lane@gmail.com",
                       userpic: UIImage(named: "client_1"), rating: 555),
                Client(username: "Courtney Henry",
                       email: "Courtney.Henry@gmail.com",
                       userpic: UIImage(named: "client_2"),
                       rating: 694),
                Client(username: "Savannah Nguyen",
                       email: "Savannah.Nguyen@gmail.com",
                       userpic: UIImage(named: "client_3"),
                       rating: 454),
                Client(username: "Jerome Bell",
                       email: "Jerome.Bell@gmail.com",
                       userpic: UIImage(named: "client_4"),
                       rating: 801),
                Client(username: "Jacob Jones",
                       email: "Jacob.Jones@gmail.com",
                       userpic: UIImage(named: "client_5"),
                       rating: 680),
                Client(username: "Darlene Robertson",
                       email: "Darlene.Robertson@gmail.com",
                       userpic: UIImage(named: "client_6"),
                       rating: 451),
                Client(username: "Jane Cooper",
                       email: "Jane.Cooper@gmail.com",
                       userpic: UIImage(named: "client_7"),
                       rating: 647),
                Client(username: "Arlene McCoy",
                       email: "Arlene.McCoy@gmail.com",
                       userpic: UIImage(named: "client_8"),
                       rating: 806),
                Client(username: "Bessie Cooper",
                       email: "Bessie.Cooper@gmail.com",
                       userpic: UIImage(named: "client_9"),
                       rating: 314),
                Client(username: "Esther Howard",
                       email: "Esther.Howard@gmail.com",
                       userpic: UIImage(named: "client_10"),
                       rating: 122),
                Client(username: "Cody Fisher",
                       email: "Cody.Fisher@gmail.com",
                       userpic: UIImage(named: "client_11"),
                       rating: 410)]
    }
}
