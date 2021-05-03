//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/5/3.
//

import UIKit

class LandscapeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let searchCellId = "SearchCollectionCell"


    lazy var search = SearchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell = UINib(nibName: "SearchCollectionCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: searchCellId)
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LandscapeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search.resultsNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellId, for: indexPath) as? SearchCollectionViewCell
                
        if let result = search.getResult(by: indexPath.item) {
            cell?.configure(with: result)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let result = search.getResult(by: indexPath.item) {
            print("select Item: \(indexPath.item), name: \(result.name)")
        }
    }
    
}


