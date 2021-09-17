//
//  CharacterDetailsViewController.swift
//  Marvel
//
//  Created by shuynh on 9/15/21.
//

import UIKit

enum ActionType: Int {
    case favorite
    case unfavorite
}

class CharacterDetailsViewController: UITableViewController {
    @IBOutlet weak var characterHeaderView: UIView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var character: Character?
    var thumbnail: UIImage?
    var completion: ((ActionType) -> Void)? = nil
    
    private var details: [[CharacterDetail]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = thumbnail {
            characterImageView.image = image
        }
        for _ in 0...3 {
            details.append([])
        }
        
        updateFavoriteButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchCharacterDetails()
    }
    
    private func updateFavoriteButton() {
        guard let c = character else { return }
        
        let isFavorite = FavoritesService.shared.isFavorite(c)
        favoriteButton.tag = isFavorite ? 1 : 0
        let normalImage = isFavorite ? #imageLiteral(resourceName: "icon_favorite_highlighted") : #imageLiteral(resourceName: "icon_favorite_normal")
        let highlightedImage = isFavorite ? #imageLiteral(resourceName: "icon_favorite_normal") : #imageLiteral(resourceName: "icon_favorite_highlighted")
        favoriteButton.setImage(normalImage, for: .normal)
        favoriteButton.setImage(highlightedImage, for: .highlighted)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let c = character else { return }
        let add = sender.tag <= 0
        var action: ActionType = .favorite
        if add {
            FavoritesService.shared.addFavorite(c)
        } else {
            FavoritesService.shared.deleteFavorite(c)
            action = .unfavorite
        }
        updateFavoriteButton()
        completion?(action)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Comics" }
        if section == 1 { return "Series" }
        if section == 2 { return "Stories" }
        return "Events"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterDetailCell", for: indexPath) as! CharacterDetailCell
        cell.tag = indexPath.row
        cell.collectionView.tag = indexPath.section
        cell.collectionView.reloadData()
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension CharacterDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterDetailCollectionCell", for: indexPath) as! CharacterDetailCollectionCell
        cell.tag = indexPath.row
        cell.imageView.image = #imageLiteral(resourceName: "icon_placeholder")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let detail = details[collectionView.tag][indexPath.row]
        guard let url = detail.thumbnail?.completeURL else {
            return
        }
        ThumbnailService.shared.downloadThumbnail( url, completion: { thumbnail in
            if let image = thumbnail {
                (cell as? CharacterDetailCollectionCell)?.imageView.image = image
            }
        })
    }
}

// MARK: - Fetch character details
extension CharacterDetailsViewController {
    private func fetchCharacterDetails() {
        guard let characterId = character?.id else {
            return
        }
        
        showLoading()
        let sections = ["comics", "series", "stories", "events"]
        DispatchQueue.global().async {
            let group = DispatchGroup()
            for (index, section) in sections.enumerated() {
                group.enter()
                ApiService.shared.fetchCharacterDetails(for: characterId, section: section) { [weak self] response in
                    guard let `self` = self else { return }
                    switch response {
                      case .success(let details):
                        self.details[index] = details.data.results
                      case .failure(let error):
                        print("An error occurred when getting character details for \(section) with \(error)")
                      }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.tableView.reloadData()
                self.hideLoading()
            }
        }
    }
}
