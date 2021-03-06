//
//  Article.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Article: RemoteDataBaseModel {

    // MARK: - Properties
    static let collection = "articles"

    var title: String
    var sort: String
    var author: String
    var description: String
    var purseName: String
    var isbn: String
    var code: String
    var price: Double
    var sellerUniqueId: String
    var sold: Bool
    var returned: Bool
    var uniqueID: String

    var dictionary: [String: Any] {
        let values: [String: Any] = ["title": title,
                                     "code": code,
                                     "sort": sort,
                                     "author": author,
                                     "description": description,
                                     "purseName": purseName,
                                     "isbn": isbn,
                                     "price": price,
                                     "sold": sold,
                                     "returned": returned,
                                     "uniqueID": uniqueID,
                                     "sellerUniqueId": sellerUniqueId]
        return values
    }

    static let sort = ["Book", "Comic", "Novel", "Guide", "Game", "Compact Disk", "DVD", "Video Game", "Other"]

 // MARK: - Initialisation
    init(title: String, sort: String, author: String, description: String,
         purseName: String, isbn: String, code: String,
         price: Double, sellerUniqueId: String, sold: Bool, returned: Bool,
         uniqueID: String) {
        self.title = title
        self.sort = sort
        self.author = author
        self.description = description
        self.purseName = purseName
        self.isbn = isbn
        self.code = code
        self.price = price
        self.sellerUniqueId = sellerUniqueId
        self.sold = sold
        self.returned = returned
        self.uniqueID = uniqueID
    }

    init(title: String, sort: String, author: String,
         description: String, isbn: String, price: Double) {
        self.title = title
        self.sort = sort
        self.author = author
        self.description = description
        self.isbn = isbn
        self.price = price
        self.purseName = ""
        self.code = ""
        self.sellerUniqueId = ""
        self.sold = false
        self.returned = false
        self.uniqueID = ""
    }

    required init?(dictionary: [String: Any]) {
        guard
            let titleValue = dictionary["title"] as? String,
            let codeValue = dictionary["code"] as? String,
            let sortValue = dictionary["sort"] as? String,
            let authorValue = dictionary["author"] as? String,
            let descriptionValue = dictionary["description"] as? String,
            let purseNameValue = dictionary["purseName"] as? String,
            let isbnValue = dictionary["isbn"] as? String,
            let priceValue = dictionary["price"] as? Double,
            let soldValue = dictionary["sold"] as? Bool,
            let returnedValue = dictionary["returned"] as? Bool,
            let uniqueIDValue = dictionary["uniqueID"] as? String,
            let sellerUniqueIdValue = dictionary["sellerUniqueId"] as? String else {
                return nil
        }

        title = titleValue
        code = codeValue
        sort = sortValue
        author = authorValue
        description = descriptionValue
        purseName = purseNameValue
        isbn = isbnValue
        price = priceValue
        sold = soldValue
        returned = returnedValue
        sellerUniqueId = sellerUniqueIdValue
        uniqueID = uniqueIDValue
    }
}
