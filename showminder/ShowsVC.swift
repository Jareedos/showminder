//
//  ShowsVC.swift
//  showminder
//
//  Created by Jared Sobol on 9/22/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AlamofireImage

class ShowsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collection: UICollectionView!

    var items = [TvShow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self

        // Do any additional setup after loading the view.
        FIRDatabase.database().reference().child("shows").observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
            let tvShow = TvShow(snapshot: snapshot)
            self.items.append(tvShow)
            self.collection.reloadData()
            }, withCancel: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as? ShowCell {
            let tvShow = items[indexPath.item]
            
            cell.showImg.image = #imageLiteral(resourceName: "tv_show_image_is_not_available")
            cell.showImg.af_cancelImageRequest()
            if let imageURL = tvShow.imageURL {
                cell.showImg.af_setImage(withURL: imageURL)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("clicked")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }

}
