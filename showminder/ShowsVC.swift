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
import UserNotifications

class ShowsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var newTonightBtn: MaterialBtn!
    @IBOutlet weak var myShowBtn: MaterialBtn!
    @IBOutlet weak var allShowsBtn: MaterialBtn!
    
    var selectedBtn: UIButton!// The currently selected button, always non-nil

    var filteredEpisodes = [Episode]()
    var episodes = [Episode] ()
    var searchMode = false
    var showNotifications = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        // requesting notification autherization
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler:
                {(granted, error) in
                   if granted{
                     print("permission granted")
                   } else {
                     print(error.debugDescription)
                    }
            })
        } else {
            showUpdateAlert("Software Update Nessesary", msg: "In order to recieve notifications, your IOS must 10.0 or higher.")
        }

        selectedBtn = newTonightBtn
    }
    
    var showsRef = FIRDatabase.database().reference().child("shows")
    var showHandle: FIRDatabaseHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshContent()
    }
    
    func refreshContent() {
        
        if let showHandle = showHandle {
            showsRef.removeObserver(withHandle: showHandle)
        }
        self.episodes.removeAll()
    
        switch selectedBtn {
        case newTonightBtn:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d/y"
            let date = dateFormatter.string(from: Date())
            let dateKey = date.replacingOccurrences(of: "/", with: "-")
            
            showsRef = DataService.ds.REF_EPISODES_BY_DATE.child(dateKey)
            showHandle = showsRef.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
                self.episodes.append(Episode(snapshot: snapshot))
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            })
            
        case allShowsBtn:
            
            self.showsRef = DataService.ds.REF_EPISODES_NEXT
            self.showHandle = self.showsRef.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
                self.episodes.append(Episode(snapshot: snapshot))
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            })
            
        case myShowBtn:
            self.collection.reloadData()
            self.showsRef = DataService.ds.REF_SHOWS_BY_FOLLOWER.child(DataService.ds.currentUserId())
            self.showHandle = self.showsRef.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
                
                // If the show is being followed b
                if let isFollowing = snapshot.value as? Bool, isFollowing == true {
                    DataService.ds.REF_EPISODES_NEXT.child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                        if snapshot.exists() {
                            self.episodes.append(Episode(snapshot: snapshot))
                            DispatchQueue.main.async {
                                self.collection.reloadData()
                            }
                        }
                    })
                }
                
            })
            
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as? ShowCell {
            
            if searchMode {
                let tvShow = filteredEpisodes[indexPath.item]
                cell.configureCell(episode: tvShow)
            } else {
                let tvShow = episodes[indexPath.item]
                cell.configureCell(episode: tvShow)
            }
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var episode: Episode!
        
        if searchMode {
            episode = filteredEpisodes[indexPath.row]
        } else {
            episode = episodes[indexPath.row]
        }
        
        performSegue(withIdentifier: "ShowDetailVC" , sender: episode)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMode {
            return filteredEpisodes.count
        }
        return episodes.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            searchMode = true
            let lower = searchText.lowercased()
            filteredEpisodes = episodes.filter({$0.name.lowercased().range(of: lower) != nil})
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
            searchBar.text = ""
        }
        
        newlySelectedButton.backgroundColor = UIColor.showMinderGray
        selectedBtn = newlySelectedButton
        
        refreshContent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailVC" {
            if let detailsVC = segue.destination as? ShowDetailVC {
                if let episode = sender as? Episode {
                    detailsVC.episode = episode
                }
            }
        }
    }
    
    func showUpdateAlert(_ title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
