//
//  SelectPurseViewController.swift
//  Boursobook
//
//  Created by David Dubez on 31/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SelectPurseViewController: UIViewController {

    // MARK: Properties
    var userPurses = [Purse]()
    let purseAPI = PurseAPI()
    let userAPI = UserAPI()

    // MARK: IBOutlet
    @IBOutlet weak var purseListTableView: UITableView!
    @IBOutlet weak var createActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var createNewPurseButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var selectPurseStackView: UIStackView!
    @IBOutlet weak var selectPurseActivityIndicator: UIActivityIndicatorView!

    // MARK: IBAction
    @IBAction func didTapCreatePurse(_ sender: UIButton) {
        self.toogleCreateActivity(loading: true)
        choosePurseName()
    }
    @IBAction func didTapLogOutButton(_ sender: UIButton) {
        confirmLogOut()
    }

    // MARK: OverRide
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        purseListTableView.reloadData()
        InMemoryStorage.shared.onPurseUpdate = { () in
            self.purseListTableView.reloadData()
        }
    }

    // MARK: Functions

    private func toogleCreateActivity(loading: Bool) {
        createActivityIndicator.isHidden = !loading
        createNewPurseButton.isHidden = loading
    }

    private func toogleSelectActivity(loading: Bool) {
        selectPurseActivityIndicator.isHidden = !loading
        selectPurseStackView.isHidden = loading
    }

    private func setStyleOfVC() {
        purseListTableView.layer.cornerRadius = 10
        logOutButton.layer.cornerRadius = 10
        addGradientTo(view: purseListTableView)
    }

    private func choosePurseName() {
        let alert = UIAlertController(title: NSLocalizedString("New purse création", comment: ""),
                                      message: nil,
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""),
                                       style: .default) { _ in
                                        guard let nameTextFieldValue = alert.textFields?[0].text else {
                                            return
                                        }
                                        self.validChosenPurseName(name: nameTextFieldValue)
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default) { _ in
                                            self.toogleCreateActivity(loading: false)
        }

        alert.addTextField { textName in
            textName.placeholder = NSLocalizedString("Enter the name", comment: "")
            textName.keyboardType = .default
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)

    }

    private func validChosenPurseName(name: String) {
        InMemoryStorage.shared.isPurseNameExist(name: name) { (error, exist) in
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else if exist {
                self.toogleCreateActivity(loading: false)
                self.displayAlert(message:
                    NSLocalizedString(
                        "Sorry, but the name allready exist !",
                        comment: ""),
                                  title: NSLocalizedString("Error !", comment: ""))
            } else {
                self.createNewPurse(name: name)
            }
        }
    }

    private func createNewPurse(name: String) {
        InMemoryStorage.shared.createPurse(name: name) { (error) in
            self.toogleCreateActivity(loading: false)
            if let error = error {
                self.displayAlert(message: NSLocalizedString(error.message, comment: ""),
                                  title: NSLocalizedString("Error !", comment: ""))
            } else {
                self.displayAlert(message: NSLocalizedString("New purse was created", comment: ""),
                                  title: NSLocalizedString("Done !", comment: ""))
            }
        }
    }

    private func confirmLogOut() {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to log out ?",
                                                                 comment: ""),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)
        let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
            self.logOut()
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func logOut() {
        userAPI.signOut { (error) in
            if let error = error {
                self.displayAlert(message: NSLocalizedString(error.message, comment: ""),
                                  title: NSLocalizedString("Error !", comment: ""))
            } else {
                InMemoryStorage.shared.stopPurseListen()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func addGradientTo(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: view.bounds.size)
        view.layer.addSublayer(gradientLayer)

        let newColors = [UIColor.white.cgColor, UIColor.green.cgColor]
        let colorsAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
        colorsAnimation.fromValue = gradientLayer.colors
        colorsAnimation.toValue = newColors
        colorsAnimation.duration = 5.0
        colorsAnimation.delegate = self
        colorsAnimation.fillMode = .forwards
        colorsAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorsAnimation, forKey: "colors")
    }

    // MARK: - Navigation

}

// MARK: - TableView for list of purse
extension SelectPurseViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPurses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "purseListCell",
                                                       for: indexPath) as? PurseListTableViewCell else {
                                                        return UITableViewCell()
        }
        let purse = userPurses[indexPath.row]
        cell.configure(with: purse)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toogleSelectActivity(loading: true)
        let selectedPurse = userPurses[indexPath.row]

        InMemoryStorage.shared.loadUsefulDataFor(purse: selectedPurse) { (error) in
            self.toogleSelectActivity(loading: false)
            if let error = error {
                self.displayAlert(message: NSLocalizedString(error.message, comment: ""),
                                  title: NSLocalizedString("Error !", comment: ""))
            } else {
                self.performSegue(withIdentifier: "segueToInfo", sender: nil)
            }
        }
    }
}

// MARK: - Animation
extension SelectPurseViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {

        }
    }
}
