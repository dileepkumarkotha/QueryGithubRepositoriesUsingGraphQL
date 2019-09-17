//
//  RespositoryCell.swift
//  GithubQuery
//
//  Created by dkotha on 9/18/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import Apollo

class RespositoryCell: UITableViewCell {

    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var ownerLoginName: UILabel!
    @IBOutlet weak var ownerAvatar: UIImageView!
    @IBOutlet weak var numberOfStars: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with repository: RepositoryDetails) {
        repositoryName.text = repository.name
        ownerLoginName.text = repository.owner.login
        numberOfStars.text = String(repository.stargazers.totalCount)
        ownerAvatar.downloadImage(from: repository.owner.avatarUrl)
    }

}
