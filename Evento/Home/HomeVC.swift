//
//  HomeVC.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import IHProgressHUD
import Kingfisher

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let headerTitles = ["Album", "Artist", "Song"]
    let SectionHeaderHeight: CGFloat = 45
    
    var albumElements : AlbumSearch?
    var artistElements : ArtistSearch?
    var trackElements : TrackSearch?
    
    var albumData : [AlbumDef] = []
    var artistData : [ArtistDef] = []
    var trackData : [TrackDef] = []
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#162945")
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        
        IHProgressHUD.set(defaultAnimationType: .flat)
        IHProgressHUD.set(defaultStyle: .dark)
        IHProgressHUD.set(defaultMaskType: .black)
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Albums, Artists or Songs"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = headerTitles[section]

        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let header = cell as! HomeTableSectionHeader
        header.lb_title.text = title

        return cell
    }
    
    /* func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    } */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return albumData.count
        case 1:
            return artistData.count
        case 2:
            return trackData.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "climaCell", for: indexPath) as! HomeTableCell
        
        switch indexPath.section {
        case 0:
            cell.lb_title.text = albumData[indexPath.row].title
            cell.lb_artist.text = albumData[indexPath.row].artist
            cell.iv_cover.kf.setImage(with: URL(string: albumData[indexPath.row].image))
        case 1:
            cell.lb_title.text = artistData[indexPath.row].name
            cell.lb_artist.text = artistData[indexPath.row].url
            cell.iv_cover.kf.setImage(with: URL(string: artistData[indexPath.row].image))
        case 2:
            cell.lb_title.text = trackData[indexPath.row].name
            cell.lb_artist.text = trackData[indexPath.row].artist
            cell.iv_cover.kf.setImage(with: URL(string: trackData[indexPath.row].image))
        default:
            cell.lb_title.text = ""
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "toDetail", sender: "Album")
        case 1:
            performSegue(withIdentifier: "toDetail", sender: "Artist")
        case 2:
            performSegue(withIdentifier: "toDetail", sender: "Song")
        default:
            print()
        }
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let receivedString = sender as! String
        
        if segue.identifier == "toDetail" {
            let destinationVC = segue.destination as! DetailVC
            let idx = self.tableView.indexPathForSelectedRow!.row
            destinationVC.retrieveMethod = receivedString
            if receivedString == "Album" {
                destinationVC.artist = albumData[idx].artist
                destinationVC.album = albumData[idx].title
            }
            if receivedString == "Artist" {
                destinationVC.artist = artistData[idx].name
            }
            if receivedString == "Song" {
                destinationVC.artist = trackData[idx].artist
                destinationVC.track = trackData[idx].name
            }
        }
    }
    
    func getAlbumData(text : String) {
        
        DispatchQueue.global(qos: .utility).async {
            IHProgressHUD.show()
        }
        
        let requestString = "http://ws.audioscrobbler.com/2.0/?method=album.search&album=\(text)&api_key=e88ffdb9ae32bcf0dc2c1da618efa5df&format=json"
        let urlEncoded = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var imageURL : String = ""
        
        albumData = [AlbumDef]()
        
        // Album Fetch Request
        AF.request(urlEncoded!, method: .get, parameters: nil) //urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        guard let responseJSON = value as? [String: AnyObject] else {
                            print("Error reading response")
                            return
                        }
                        self.albumElements = Mapper<AlbumSearch>().map(JSON: responseJSON)
                        //self.isExistDays()
                        if self.albumElements?.results != nil {
                            let albumInfo = self.albumElements?.results?.albumMatches?.album
                            for element in albumInfo! {
                                for imageElement in element.image! {
                                    if imageElement.size == "small" {
                                        imageURL = imageElement.text ?? ""
                                    }
                                }
                                self.albumData.append(AlbumDef(
                                    title: "\(element.name ?? "")",
                                    artist: "\(element.artist ?? "")",
                                    url: "\(element.url ?? "")",
                                    image: "\(imageURL)"
                                    )
                                )
                            }
                        }
                        self.getArtistData(text:text)
                    case .failure(let error):
                        print(error)
                }
            }
        
    }
    
    func getArtistData(text : String) {
        
        let requestString = "http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=\(text)&api_key=e88ffdb9ae32bcf0dc2c1da618efa5df&format=json"
        let urlEncoded = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var imageURL : String = ""
        
        artistData = [ArtistDef]()

        // Artist Fetch Request
        AF.request(urlEncoded!, method: .get, parameters: nil) //urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        guard let responseJSON = value as? [String: AnyObject] else {
                            print("Error reading response")
                            return
                        }
                        self.artistElements = Mapper<ArtistSearch>().map(JSON: responseJSON)
                        //self.isExistDays()
                        if self.artistElements?.results != nil {
                            let artistInfo = self.artistElements?.results?.artistMatches?.artist
                            for element in artistInfo! {
                                for imageElement in element.image! {
                                    if imageElement.size == "small" {
                                        imageURL = imageElement.text ?? ""
                                    }
                                }
                                self.artistData.append(ArtistDef(
                                    name: "\(element.name ?? "")",
                                    url: "\(element.url ?? "")",
                                    image: "\(imageURL)"
                                    )
                                )
                            }
                            self.getTrackData(text:text)
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        
    }
    
    func getTrackData(text : String) {
        
        let requestString = "http://ws.audioscrobbler.com/2.0/?method=track.search&track=\(text)&api_key=e88ffdb9ae32bcf0dc2c1da618efa5df&format=json"
        let urlEncoded = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var imageURL : String = ""
        
        trackData = [TrackDef]()
        
        // Track Fetch Request
        AF.request(urlEncoded!, method: .get, parameters: nil) //urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        guard let responseJSON = value as? [String: AnyObject] else {
                            print("Error reading response")
                            return
                        }
                        self.trackElements = Mapper<TrackSearch>().map(JSON: responseJSON)
                        //self.isExistDays()
                        if self.trackElements?.results != nil {
                            let trackInfo = self.trackElements?.results?.trackMatches?.track
                            for element in trackInfo! {
                                for imageElement in element.image! {
                                    if imageElement.size == "small" {
                                        imageURL = imageElement.text ?? ""
                                    }
                                }
                                self.trackData.append(TrackDef(
                                    name: "\(element.name ?? "")",
                                    artist: "\(element.artist ?? "")",
                                    url: "\(element.url ?? "")",
                                    image: "\(imageURL)"
                                    )
                                )
                            }
                            IHProgressHUD.dismiss()
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                }
            }

    }
    
}

extension HomeVC: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    if searchBar.text != "" { getAlbumData(text:searchBar.text!) }
  }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

struct AlbumDef {
    var title : String
    var artist : String
    var url : String
    var image : String
}


struct ArtistDef {
    var name : String
    var url : String
    var image : String
}

struct TrackDef {
    var name : String
    var artist : String
    var url : String
    var image : String
}
