//
//  SaleViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SaleViewController: UIViewController {

    // MARK: - Properties
    var inSaleArticles = [Article]()
    var currentSale = Sale()
    let saleAPI = SaleAPI()
    let articleAPI = ArticleAPI()

    // MARK: - IBOutlets
    @IBOutlet weak var numberOfRegisteredArticleLabel: UILabel!
    @IBOutlet weak var numberCheckedSwitch: UISwitch!
    @IBOutlet weak var totalAmountSaleLabel: UILabel!
    @IBOutlet weak var selectedArticleTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var savingActivityIndicator: UIActivityIndicatorView!

    // MARK: - IBActions
    @IBAction func didTapAddArticleButton(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToScanQRCode", sender: nil)
    }
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        saveTheSale()
    }
    @IBAction func didTapResetButton(_ sender: UIButton) {
       resetTransaction()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numberCheckedSwitch.isOn = false
        loadInSaleArticles()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saleAPI.stopListen()
        articleAPI.stopListen()
    }

    deinit {
        saleAPI.stopListen()
        articleAPI.stopListen()
    }

    // MARK: - Functions
    private func loadInSaleArticles() {

        if !InMemoryStorage.shared.uniqueIdOfArticlesInCurrentSales.isEmpty {
            toogleLoadingActivity(loading: true)
            articleAPI.loadNoSoldArticlesFor(purse: InMemoryStorage.shared.inWorkingPurse) { (error, loadedArticles) in
                self.toogleLoadingActivity(loading: false)
                if let error = error {
                    self.displayAlert(
                        message: error.message,
                        title: NSLocalizedString(
                            "Error !", comment: ""))
                } else {
                    guard let articles = loadedArticles else {
                        return
                    }
                    self.inSaleArticles.removeAll()
                    self.currentSale = Sale()

                    for uniqueIdArticle in InMemoryStorage.shared.uniqueIdOfArticlesInCurrentSales {
                        for article in articles where article.uniqueID == uniqueIdArticle {
                            self.inSaleArticles.append(article)
                            self.currentSale.numberOfArticle += 1
                            self.currentSale.amount += article.price
                            self.currentSale.articles.updateValue(true, forKey: uniqueIdArticle)
                        }
                    }
                    self.updateValues()
                }
            }
        }
    }

    private func updateValues() {
        numberOfRegisteredArticleLabel.text = String(currentSale.numberOfArticle)
        totalAmountSaleLabel.text = String(currentSale.amount)
        selectedArticleTableView.reloadData()
    }

    private func saveTheSale() {
        toogleSavingActivity(saving: true)

        if InMemoryStorage.shared.uniqueIdOfArticlesInCurrentSales.isEmpty {
            toogleSavingActivity(saving: false)
            self.displayAlert(message: NSLocalizedString("Nothing To Save !",
                                                         comment: ""),
                              title: NSLocalizedString("Warning", comment: ""))
        } else {
            if numberCheckedSwitch.isOn {
                saleAPI.createSale(purse: InMemoryStorage.shared.inWorkingPurse,
                                   user: InMemoryStorage.shared.userLogIn,
                                   sale: currentSale) { (error) in
                    self.toogleSavingActivity(saving: false)
                    if let error = error {
                        self.displayAlert(
                            message: error.message,
                            title: NSLocalizedString(
                                "Error !", comment: ""))
                    } else {
                        self.displayAlert(
                            message: NSLocalizedString("The sale was saved", comment: ""),
                            title: NSLocalizedString("Done !", comment: ""))
                        self.resetTransaction()
                        self.numberCheckedSwitch.isOn = false
                    }
                }
            } else {
                toogleSavingActivity(saving: false)
                self.displayAlert(message: NSLocalizedString("Please check the number !",
                                                             comment: ""),
                                  title: NSLocalizedString("Warning", comment: ""))
            }
        }
    }

    private func resetTransaction() {
        InMemoryStorage.shared.uniqueIdOfArticlesInCurrentSales.removeAll()
        currentSale = Sale()
        numberCheckedSwitch.isOn = false
        inSaleArticles = [Article]()
        updateValues()
    }

    private func setStyleOfVC() {
        selectedArticleTableView.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        resetButton.layer.cornerRadius = 10
    }

    private func toogleLoadingActivity(loading: Bool) {
           loadingActivityIndicator.isHidden = !loading
           selectedArticleTableView.isHidden = loading
    }

    private func toogleSavingActivity(saving: Bool) {
           savingActivityIndicator.isHidden = !saving
           saveButton.isHidden = saving
    }

    // MARK: - Navigation
   @IBAction func unwindToBuyVC(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToScanQRCode" {
            if let scanQRCodeVC = segue.destination as? ScanQrCodeViewController {
                scanQRCodeVC.currentSale = currentSale
            }
        }
    }
}

// MARK: - TableView for list of article
extension SaleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSaleArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionActicleListCell",
                                                       for: indexPath) as? TransactionActicleListTableViewCell else {
                                                        return UITableViewCell()
        }

        let article = inSaleArticles[indexPath.row]

        cell.configure(with: article)

        return cell
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let articleToDelete = inSaleArticles[indexPath.row]
            for (index, uniqueId) in InMemoryStorage.shared
                .uniqueIdOfArticlesInCurrentSales.enumerated()
                        where uniqueId == articleToDelete.uniqueID {
                InMemoryStorage.shared.uniqueIdOfArticlesInCurrentSales.remove(at: index)
                loadInSaleArticles()
            }
        }
    }

    // MARK: - AlertControler
    private func displayAlertConfirmCompted() {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""),
                                      message: NSLocalizedString("Please check the number ?",
                                                                 comment: ""),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)

        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}