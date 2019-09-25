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
    @IBOutlet weak var searchTypeField: UITextField!
    @IBOutlet weak var searchKeywordTextField: UITextField!
    @IBOutlet weak var addSearchFieldsButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTypePickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTypeField.inputView = searchTypePickerView
        setSearchButtonUI()
        addSearchFieldsButton.layer.cornerRadius = 18
        addSearchFieldsButton.layer.borderWidth = 2
        addSearchFieldsButton.layer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func setSearchButtonUI() {
        searchButton.layer.cornerRadius = 5
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        searchButton.layer.shadowRadius = 0
        searchButton.layer.shadowOpacity = 1.0
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
        searchTypeField.text = searchTypes[row]
    }
    
}
