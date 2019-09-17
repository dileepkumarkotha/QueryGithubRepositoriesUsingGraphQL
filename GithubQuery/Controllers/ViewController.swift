//
//  ViewController.swift
//  GithubQuery
//
//  Created by dkotha on 9/16/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DisplayableAlert {
    private enum SegueIdentifiers {
        static let list = "ListViewController"
    }

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.list,
            let listViewController = segue.destination as? RepositoriesTableViewController,
            let searchText = searchTextField.text,
            !searchText.isEmpty {
            listViewController.queryString = searchText
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
