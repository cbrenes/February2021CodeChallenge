//
//  ImagesListTableViewCell.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//

import UIKit

class ImageListTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: CustomImageViewWithCache!
    @IBOutlet weak var loadingStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    /**
     Draw the correct information the cell

     - Parameter item: If this parameter is nil, the code will show a loading view, otherwise it will download the image
     
     */
    func setupCell(item: ImagesList.DataSource.ViewModel.Succes.DisplayObject?) {
        guard let item = item else {
            thumbnailImageView.isHidden = true
            loadingStackView.isHidden = false
            return
        }
        thumbnailImageView.isHidden = false
        loadingStackView.isHidden = true
        thumbnailImageView.downloadImage(url: item.thumbnailUrl)
    }
}
