//
//  ImageViewController.swift
//  lazyLoadingwithImages
//
//  Created by Bhanuja Tirumareddy on 02/07/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let BaseUrl = "https://qgkpjarwfl.execute-api.us-east-1.amazonaws.com/dev/getNormalVideoFiles"
    @IBOutlet weak var imageCollectionview: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var searhImageView: UIImageView!
    let queryService = QueryService()
    var searchResults: [GetDataModel] = []
    
       override func viewDidLoad() {
           super.viewDidLoad()
    loadDatawithUrl(url: BaseUrl, limit: "6")
        
           // Do any additional setup after loading the view.
       }
    func loadDatawithUrl(url: String, limit: String) {
        let AIView = Utility.Shared.showActivityIndicatory(uiView: self.view)
        
        queryService.getDataWith(url: url,limit: limit) { [weak self] results, errorMessage in
            
            AIView.removeFromSuperview()
            if let results = results {
                self?.searchResults = results
                self?.imageCollectionview.reloadData()
            }
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
                Utility.Shared.showSimpleAlert(OnViewController: self, Message: errorMessage)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.cellIdentifiers.downloadcellIdentifier, for: indexPath as IndexPath) as! ImageCollectionViewCell
         let track = searchResults[indexPath.row]
         cell.configure(track: track)
               return cell
    }
    
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 4;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 1;
    }
    
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.searchResults.count - 1 {  //numberofitem count
            updateNextSet()
        }
    }

    func updateNextSet(){
        print("On Completetion")

        loadDatawithUrl(url: BaseUrl, limit: String(self.searchResults.count + 6))
        
        //requests another set of data (20 more items) from the server.
        //DispatchQueue.main.async(execute: imageCollectionview.reloadData)
    }
}
