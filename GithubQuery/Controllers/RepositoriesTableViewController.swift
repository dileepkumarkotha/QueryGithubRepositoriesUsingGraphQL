//
//  ResultsTableViewController.swift
//  GithubQuery
//
//  Created by dkotha on 9/18/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import Apollo

class RepositoriesTableViewController: UITableViewController, DisplayableAlert {

    var activityIndicator: UIActivityIndicatorView!
    var viewModel: RepositoriesViewModel!
    var queryString: String = "graphql"

    override func loadView() {
        super.loadView()
        /// Setup activity indicator
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .gray
        tableView.backgroundView = activityIndicator
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        viewModel = RepositoriesViewModel(delegate: self)
        activityIndicator.startAnimating()
        // Fetch the initial set of repositories to display in tableview
        viewModel.loadRepositories(queryString: queryString)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RespositoryCell else {
            fatalError("Could not dequeue RepositoryCell")
        }
        
        let repository = viewModel.repository(at: indexPath.row)
        cell.configure(with: repository)
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Fetch more repositores if available after reaching the end of the current list.
        if viewModel.repositories.count < viewModel.totalCount,
            indexPath.row + 1 >= viewModel.repositories.count {
            activityIndicator.startAnimating()
            viewModel.loadRepositories(queryString: queryString)
        }
    }
}

extension RepositoriesTableViewController: ResultsUpdateDelegate {
    
    func onSuccess(with newIndexPaths: [IndexPath]?) {
        activityIndicator.stopAnimating()
        guard let newIndexPaths = newIndexPaths else {
            if viewModel.repositories.isEmpty {
                let action = UIAlertAction(title: "OK", style: .default) { _ in
                    // Pop to initial view controller on this action when no repositories are found
                    self.navigationController?.popViewController(animated: true)
                    }
                showAlert(with: nil, message: "Unable to find repositories matching with search term", actions: [action])
            } else {
                tableView.reloadData()
            }
            return
        }
        tableView.beginUpdates()
        tableView.insertRows(at: newIndexPaths, with: .bottom)
        tableView.endUpdates()
    }

    func onFailure(_ error: Error) {
        activityIndicator.stopAnimating()
        let action = UIAlertAction(title: "OK", style: .default)
        showAlert(with: nil, message: "Error fetching data", actions: [action])
    }
}
