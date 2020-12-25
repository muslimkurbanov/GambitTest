//
//  MenuModel.swift
//  Gambit
//
//  Created by Муслим Курбанов on 22.12.2020.
//

import Foundation

struct Menu: Decodable {
    var id: Int
    var count: Int? = 0
    var name: String?
    var image: String?
    var price: Int
//    var id: Int?
}
