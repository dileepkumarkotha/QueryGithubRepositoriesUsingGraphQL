//
//  ResultsViewModel.swift
//  GithubQuery
//
//  Created by dkotha on 9/19/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation

protocol ResultsUpdateDelegate: class {
    func onSuccess(with newIndexPaths: [IndexPath]?)
    func onFailure(_ error: Error)
}

class RepositoriesViewModel {
    weak var delegate: ResultsUpdateDelegate?
    var repositories: [RepositoryDetails] = []
    var totalCount: Int = 0
    private var pageInfo: SearchRepositoriesQuery.Data.Search.PageInfo?
    private var isFetchInProgress = false

    init(delegate: ResultsUpdateDelegate) {
        self.delegate = delegate
    }

    func repository(at index: Int) -> RepositoryDetails {
        return repositories[index]
    }
    // MARK: - Data loading
    
    func loadRepositories(queryString: String, count: Int = 20, afterCursor: String? = nil) {
        guard !isFetchInProgress else {
            return
        }

        isFetchInProgress = true

        Apollo.shared.client.fetch(query: SearchRepositoriesQuery(queryString: queryString, count: count, afterCursor: pageInfo?.endCursor)) { result in
            switch result {
            case .success(let graphQLResult):
                self.isFetchInProgress = false
                let newRepositories = graphQLResult.data?.search.edges?.filter { $0?.node?.asRepository?.fragments.repositoryDetails != nil }.map { ($0?.node?.asRepository?.fragments.repositoryDetails)! } ?? []
                self.repositories += newRepositories
                self.pageInfo = graphQLResult.data?.search.pageInfo
                self.totalCount = graphQLResult.data?.search.repositoryCount ?? 0
                
                if self.repositories.count > 20 {
                    self.delegate?.onSuccess(with: self.indexPathsToLoad(from: newRepositories))
                } else {
                    self.delegate?.onSuccess(with: .none)
                }

            case .failure(let error):
                print("Error while fetching query: \(error.localizedDescription)")
                self.isFetchInProgress = false
                self.delegate?.onFailure(error)
            }
        }
    }

    private func indexPathsToLoad(from newRepositories: [RepositoryDetails]) -> [IndexPath] {
        let startIndex = repositories.count - newRepositories.count
        let endIndex = startIndex + newRepositories.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
