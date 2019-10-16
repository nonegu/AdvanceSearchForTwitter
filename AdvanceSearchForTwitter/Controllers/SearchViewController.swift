//
//  SearchViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 25.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: Properties
    var searchTypes = ["from", "to", "hashtag", "mentioned"]
    let searchTypePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pickerView.alpha = 0.8
        
        return pickerView
    }()
    lazy var searchTypePickerViewToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: searchTypePickerView.frame.size.width, height: 25))
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(toolbarDoneButtonPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(toolbarCancelButtonPressed))
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        return toolbar
    }()
    var searchParameters = [String: String]()
    var searchResults = [Tweet]()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTypePickerView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @objc func addSearchFieldButtonPressed() {
        if isSearchFieldValid() {
            let indexPath = IndexPath(row: (4-searchTypes.count), section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! SearchCell
            cell.searchTypeTextField.isUserInteractionEnabled = false
            cell.searchTypeTextField.backgroundColor = UIColor.lightGray
            searchTypes.removeAll { (type) -> Bool in
                type == cell.searchTypeTextField.text
            }
            tableView.reloadData()
        } else {
            displayAlert(title: "Search Type Error", with: "Please select a valid type from the list.")
        }
    }
    
    @objc func searchButtonPressed() {
        if isSearchFieldValid() {
            for cellNum in 0..<(5 - searchTypes.count) {
                let indexPath = IndexPath(row: cellNum, section: 0)
                let cell = tableView.cellForRow(at: indexPath) as! SearchCell
                searchParameters[cell.searchTypeTextField.text!] = cell.searchKeywordTextField.text
            }
            TwitterAPI.get(searchParameters: searchParameters, completion: handleSearchResults(results:error:))
        } else {
            displayAlert(title: "Search Type Error", with: "Please select a valid type from the list.")
        }
    }
    
    @objc func toolbarDoneButtonPressed() {
        let row = searchTypePickerView.selectedRow(inComponent: 0)
        let indexPath = IndexPath(row: (4-searchTypes.count), section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        cell.searchTypeTextField.text = searchTypes[row]
        cell.searchTypeTextField.resignFirstResponder()
    }
    
    @objc func toolbarCancelButtonPressed() {
        let indexPath = IndexPath(row: (4-searchTypes.count), section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        cell.searchTypeTextField.resignFirstResponder()
    }
    
    func handleSearchResults(results: [Tweet], error: Error?) {
        guard error == nil else {
            print(error!)
            return
        }
        print(results)
        searchResults = results
        performSegue(withIdentifier: "showResults", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            let searchResultsVC = segue.destination as! SearchResultsViewController
            searchResultsVC.tweets = searchResults
        }
    }
    
    func isSearchFieldValid() -> Bool {
        let lastIndexPath = IndexPath(row: (4-searchTypes.count), section: 0)
        let lastCell = tableView.cellForRow(at: lastIndexPath) as! SearchCell
        return searchTypes.contains(lastCell.searchTypeTextField.text!)
    }
        
}

// MARK: UITableView Delegate Methods
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return searchTypes.count > 0 ? (5 - searchTypes.count) : 4
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.defaultReuseIdentifier, for: indexPath) as! SearchCell
            cell.searchTypeTextField.inputView = searchTypePickerView
            cell.searchTypeTextField.inputAccessoryView = searchTypePickerViewToolbar
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.defaultReuseIdentifier, for: indexPath) as! ButtonCell
            cell.searchButton.layer.cornerRadius = 5
            cell.searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
            cell.addSearchFieldButton.addTarget(self, action: #selector(addSearchFieldButtonPressed), for: .touchUpInside)
            cell.addSearchFieldButton.layer.cornerRadius = 17.5
            cell.addSearchFieldButton.layer.borderWidth = 1.5
            cell.addSearchFieldButton.layer.borderColor = UIColor.white.cgColor
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else {
            return 100
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 && indexPath.row > 0 {
            let delete = deleteAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [delete])
        } else {
            return nil
        }
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            let cell = self?.tableView.cellForRow(at: IndexPath(item: indexPath.row - 1, section: indexPath.section)) as! SearchCell
            cell.searchTypeTextField.isUserInteractionEnabled = true
            cell.searchTypeTextField.backgroundColor = UIColor.white
            if let searchType = cell.searchTypeTextField.text {
                self?.searchTypes.append(searchType)
            }
            self?.tableView.reloadData()
            completion(true)
        }
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = UIColor.red

        return action
    }
    
}

// MARK: UIPickerView Delegate Methods
extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let indexPath = IndexPath(row: (4-searchTypes.count), section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        cell.searchTypeTextField.text = searchTypes[row]
    }
    
}
