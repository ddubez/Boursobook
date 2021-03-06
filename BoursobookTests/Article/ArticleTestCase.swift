//
//  ArticleTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 23/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import Firebase
@testable import Boursobook

class ArticleTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInitArticleSouldReturnArticle() {
        //Given
        let title = "titre article"
        let sort = "Book"
        let author = "DURANS"
        let description = "un livre sympa"
        let purseName = "APE 2019"
        let isbn = "1234567890123"
        let code = "AAAA 0001"
        let price = 2.4
        let sellerUniqueId = "AAAA 44FGDRGERT"
        let sold = true
        let uniqueID = "23456643RRRRR"
        let returned = true

        //When
        let article = Article(title: title, sort: sort,
                              author: author, description: description,
                              purseName: purseName, isbn: isbn,
                              code: code, price: price,
                              sellerUniqueId: sellerUniqueId,
                              sold: sold,
                              returned: returned,
                              uniqueID: uniqueID)

        //Then
        XCTAssertEqual(article.title, title)
        XCTAssertEqual(article.sort, sort)
        XCTAssertEqual(article.author, author)
        XCTAssertEqual(article.description, description)
        XCTAssertEqual(article.purseName, purseName)
        XCTAssertEqual(article.isbn, isbn)
        XCTAssertEqual(article.code, code)
        XCTAssertEqual(article.price, price)
        XCTAssertEqual(article.sellerUniqueId, sellerUniqueId)
        XCTAssertEqual(article.sold, sold )
        XCTAssertEqual(article.returned, returned )
        XCTAssertEqual(article.uniqueID, uniqueID)
    }

    func testShortInitArticleSouldReturnArticle() {
        //Given
        let title = "titre article"
        let sort = "Book"
        let author = "DURANS"
        let description = "un livre sympa"
        let isbn = "1234567890123"
        let price = 2.4

        //When
        let article = Article(title: title, sort: sort, author: author,
        description: description, isbn: isbn, price: price)

        //Then
        XCTAssertEqual(article.title, title)
        XCTAssertEqual(article.sort, sort)
        XCTAssertEqual(article.author, author)
        XCTAssertEqual(article.description, description)
        XCTAssertEqual(article.isbn, isbn)
        XCTAssertEqual(article.price, price)
        XCTAssertEqual(article.code, "")
        XCTAssertEqual(article.purseName, "")
        XCTAssertEqual(article.sellerUniqueId, "")
        XCTAssertEqual(article.sold, false )
        XCTAssertEqual(article.returned, false )
        XCTAssertEqual(article.uniqueID, "")
    }

    func testInitArticleWithDictionarySouldReturnArticle() {
        //Given
        let title = "titre article"
        let sort = "Book"
        let author = "DURANS"
        let description = "un livre sympa"
        let purseName = "APE 2019"
        let isbn = "1234567890123"
        let code = "AAAA 0001"
        let price = 2.4
        let sellerUniqueId = "AAAA 44FGDRGERT"
        let sold = false
        let returned = true
        let uniqueID = "ID Article - fake article For test"

        let articleDataDictionary = FakeDataDictionary().article

        //When
        guard let article = Article(dictionary: articleDataDictionary) else {
            XCTFail("error in init of article")
            return
        }

        //Then
        XCTAssertEqual(article.title, title)
        XCTAssertEqual(article.sort, sort)
        XCTAssertEqual(article.author, author)
        XCTAssertEqual(article.description, description)
        XCTAssertEqual(article.purseName, purseName)
        XCTAssertEqual(article.isbn, isbn)
        XCTAssertEqual(article.code, code)
        XCTAssertEqual(article.price, price)
        XCTAssertEqual(article.sellerUniqueId, sellerUniqueId)
        XCTAssertEqual(article.sold, sold )
        XCTAssertEqual(article.returned, returned )
        XCTAssertEqual(article.uniqueID, uniqueID)
    }

    func testInitArticleWithEmptyDictionarySouldReturnNil() {
        //Given
        let emptyDataDictionary = FakeDataDictionary().empty

        //When
        guard let article = Article(dictionary: emptyDataDictionary) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNil(article)
        XCTFail("transaction is initialised")

    }

    func testGetDictionarySouldReturnGoodValues() {
        //Given
        let fakeArticleDataDictionary = FakeDataDictionary().article

        //When
        guard let article = Article(dictionary: fakeArticleDataDictionary) else {
        XCTFail("error in init article")
        return
        }
        let dictionaryValues = article.dictionary

        //Then
        XCTAssertEqual(dictionaryValues["title"] as? String, fakeArticleDataDictionary["title"] as? String)
        XCTAssertEqual(dictionaryValues["sort"] as? String, fakeArticleDataDictionary["sort"] as? String)
        XCTAssertEqual(dictionaryValues["author"] as? String, fakeArticleDataDictionary["author"] as? String)
        XCTAssertEqual(dictionaryValues["description"] as? String, fakeArticleDataDictionary["description"] as? String)
        XCTAssertEqual(dictionaryValues["purseName"] as? String, fakeArticleDataDictionary["purseName"] as? String)
        XCTAssertEqual(dictionaryValues["isbn"] as? String, fakeArticleDataDictionary["isbn"] as? String)
        XCTAssertEqual(dictionaryValues["code"] as? String, fakeArticleDataDictionary["code"] as? String)
        XCTAssertEqual(dictionaryValues["sellerCode"] as? String, fakeArticleDataDictionary["sellerCode"] as? String)
        XCTAssertEqual(dictionaryValues["uniqueID"] as? String, fakeArticleDataDictionary["uniqueID"] as? String)

        XCTAssertEqual(dictionaryValues["price"] as? Double, fakeArticleDataDictionary["price"] as? Double)

        XCTAssertEqual(dictionaryValues["sold"] as? Bool, fakeArticleDataDictionary["sold"] as? Bool)

        XCTAssertEqual(dictionaryValues["returned"] as? Bool, fakeArticleDataDictionary["returned"] as? Bool)
        }
}
