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

class ShowsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var newTonightBtn: MaterialBtn!
    @IBOutlet weak var myShowBtn: MaterialBtn!
    @IBOutlet weak var allShowsBtn: MaterialBtn!
    
    var selectedBtn: UIButton!// The currently selected button, always non-nil

    var filterdShows = [TvShow]()
    var tvShowsArray = [TvShow] ()
    var searchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done

        // Do any additional setup after loading the view.
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "M/d/y"
//        let date = dateFormatter.string(from: Date())
        
        
//        let tonightQuery = showsRef.queryOrdered(byChild: "date").queryEqual(toValue: date)
//        let myQuery = showsRef
        selectedBtn = newTonightBtn
        refreshContent()
    }
    
    let showsRef = FIRDatabase.database().reference().child("shows")
    var showHandle: FIRDatabaseHandle?
    
    func refreshContent() {
        
        if let showHandle = showHandle {
            showsRef.removeObserver(withHandle: showHandle)
        }
        self.tvShowsArray.removeAll()
    
        switch selectedBtn {
        case newTonightBtn:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d/y"
            let date = dateFormatter.string(from: Date())
            let tonightQuery = showsRef.queryOrdered(byChild: "date").queryEqual(toValue: date)
            showHandle = tonightQuery.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
                
                let tvShow = TvShow(snapshot: snapshot)
                
                self.tvShowsArray.sort(by: {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mm a"
                    guard
                        let dateA = formatter.date(from: $0.0.showTime),
                        let dateB = formatter.date(from: $0.1.showTime)
                        else {
                            return false
                    }
                    return dateA < dateB
                })
                
                self.tvShowsArray.append(tvShow)
                self.collection.reloadData()
                }, withCancel: nil)
            break
        case allShowsBtn:
            let showsRef = FIRDatabase.database().reference().child("shows")
            let allShowsQuery = showsRef.queryOrdered(byChild: "name")
            showHandle = allShowsQuery.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
                let tvShow = TvShow(snapshot: snapshot)
                self.tvShowsArray.append(tvShow)
                self.collection.reloadData()
            })
            break
        case myShowBtn:
            break
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as? ShowCell {
            
            if searchMode {
                let tvShow = filterdShows[indexPath.item]
                cell.configureCell(show: tvShow)
            } else {
                let tvShow = tvShowsArray[indexPath.item]
                cell.configureCell(show: tvShow)
            }
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("clicked")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMode {
            return filterdShows.count
        }
        return tvShowsArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 160)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            searchMode = true
            let lower = searchBar.text!.lowercased()
            filterdShows = tvShowsArray.filter({$0.name.lowercased().range(of: lower) != nil})
            collection.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    @IBAction func tabBtnClicked(_ newlySelectedButton: UIButton) {
        if let lastButton = selectedBtn {
            lastButton.backgroundColor = UIColor.clear
            view.endEditing(true)
            searchMode = false
            searchBar.text = " "
        }
        
        newlySelectedButton.backgroundColor = UIColor.showMinderGray
        selectedBtn = newlySelectedButton
        
        refreshContent()
    }
    
    
}
