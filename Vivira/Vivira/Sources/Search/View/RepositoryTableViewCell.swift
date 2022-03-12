//
//  RepositoryTableViewCell.swift
//  Vivira
//
//  Created by Hamza Ahmed on 10/03/2022.
//

import UIKit
import Kingfisher

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    @IBOutlet weak var repositoryUrlLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var repositoryTitleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    let placeholderImage = "placeholder-image"
    
    var cellViewModel : RepositoryTableCellViewModel! {
        didSet{
            configCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configCell() {
        avatarImageView.kf.setImage (
            with: cellViewModel.getImageLink(),
            placeholder:UIImage(named: placeholderImage),
            options:[.cacheOriginalImage]
        )
        
        repositoryTitleLabel.text = cellViewModel.getRepositoryTitle()
        repositoryNameLabel.text = cellViewModel.getRepositoryName()
        ownerNameLabel.text = cellViewModel.getOwnerName()
        repositoryUrlLabel.text = cellViewModel.getRepositoryLink()
        repositoryDescriptionLabel.text = cellViewModel.getRepositoryDescription()
    }
}
