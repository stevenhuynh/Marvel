//
//  CharacterCell.swift
//  Marvel
//
//  Created by shuynh on 9/15/21.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareCell()
    }
    
    private func prepareCell() {
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        contentView.clipsToBounds = true
        favoriteImageView.isHidden = true
    }
    
    func showFavorite(_ isFavorite: Bool) {
        favoriteImageView.isHidden = !isFavorite
    }
}
