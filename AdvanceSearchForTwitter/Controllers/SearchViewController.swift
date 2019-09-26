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
        return pickerView
    }()
    
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
        let indexPath = IndexPath(row: (4-searchTypes.count), section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        cell.searchTypeTextField.isUserInteractionEnabled = false
        cell.searchTypeTextField.backgroundColor = UIColor.lightGray
        searchTypes.removeAll { (type) -> Bool in
            type == cell.searchTypeTextField.text
        }
        tableView.reloadData()
    }
        
}

// MARK: UITableView Delegate Methods
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (5 - searchTypes.count)
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.defaultReuseIdentifier, for: indexPath) as! SearchCell
            cell.searchTypeTextField.inputView = searchTypePickerView
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.defaultReuseIdentifier, for: indexPath) as! ButtonCell
            cell.searchButton.layer.cornerRadius = 5
            cell.addSearchFieldButton .addTarget(self, action: #selector(addSearchFieldButtonPressed), for: .touchUpInside)
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
