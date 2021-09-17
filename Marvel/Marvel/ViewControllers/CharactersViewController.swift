//
//  CharactersViewController.swift
//  Marvel
//
//  Created by shuynh on 9/15/21.
//

import UIKit

private let reuseIdentifier = "characterCell"

class CharactersViewController: UICollectionViewController {
    private var characters = [Character]()
    private var total = 0
    private var offset = 0
    
    private var selectedImage: UIImage?
    private var selectedFrame: CGRect?
    private var initialFetch = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if initialFetch {
            initialFetch = false
            fetchCharacters()
        }
    }
    
    // MARK: - Characters Fetchers
    func fetchCharacters() {
        showLoading()
        ApiService.shared.fetchCharacters(offset) { [weak self] response in
            guard let `self` = self else { return }
            switch response {
              case .success(let characters):
                self.total = characters.data.total
                self.characters.append(contentsOf: characters.data.results)
                self.offset = self.characters.count
                self.collectionView.reloadData()
                self.hideLoading()
              case .failure(let error):
                print("An error occurred when getting characters: \(error)")
                self.hideLoading()
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterDetailsViewControllerSegue" {
            guard let controller = segue.destination as? CharacterDetailsViewController, let cell = sender as? CharacterCell else {
                return
            }
            controller.thumbnail = cell.imageView.image
            controller.character = characters[cell.tag]
            controller.completion = { [weak self] action in
                guard let `self` = self else { return }
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let character = characters[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterCell
        cell.tag = indexPath.row
        cell.showFavorite(FavoritesService.shared.isFavorite(character))
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        if indexPath.row > characters.count - 2  {
            fetchCharacters()
        }
        
        guard let url = character.thumbnail.completeURL else {
            return
        }
        ThumbnailService.shared.downloadThumbnail( url, completion: { thumbnail in
            if let image = thumbnail {
                (cell as? CharacterCell)?.imageView.image = image
                if indexPath.row == 0 {
                    self.selectedImage = image
                    self.selectedFrame = collectionView.convert(cell.frame, to: collectionView.superview)
                }
            }
        })
    }
}

extension CharactersViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return nil
    }

}
