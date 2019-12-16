//
//  RecomendacionesVC.swift
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

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iv_albumHeader: UIImageView!
    @IBOutlet weak var lb_artist: UILabel!
    @IBOutlet weak var lb_albumName: UILabel!
    @IBOutlet weak var lb_albumArtist: UILabel!
    @IBOutlet weak var tv_wiki: UITextView!
    
    var retrieveMethod : String?
    
    var artist : String?
    var album : String?
    var track : String?
    
    var albumElements : AlbumDetail?
    var artistElements : ArtistDetail?
    var trackElements : TrackDetail?
    
    var albumData: [AlbumTrackDef] = [AlbumTrackDef]()
    var artistData: [ArtistSimilarDef] = [ArtistSimilarDef]()
    var trackData: [TrackDetailDef] = [TrackDetailDef]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#162945")
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.title = retrieveMethod
        
        tableView?.estimatedRowHeight = 92
        tableView?.rowHeight = UITableView.automaticDimension
        
        switch retrieveMethod {
        case "Album":
            getAlbumData()
        case "Artist":
            getArtistData()
        case "Song":
            getTrackData()
        default:
            print()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch retrieveMethod {
        case "Album":
            return albumData.count
        case "Artist":
            return artistData.count
        case "Song":
            return trackData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
        switch retrieveMethod {
        case "Album":
            cell.lb_trackName.text = albumData[indexPath.row].name
        case "Artist":
            cell.lb_trackName.text = artistData[indexPath.row].name
        case "Song":
            cell.lb_trackName.text = trackData[indexPath.row].name
        default:
            cell.lb_trackName.text = ""
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func getAlbumData() {
        
        DispatchQueue.global(qos: .utility).async {
            IHProgressHUD.show()
        }
        
        let requestString = "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=e88ffdb9ae32bcf0dc2c1da618efa5df&artist=\(artist!)&album=\(album!)&format=json"
        
        var imageURL : String = ""
        
        // Album Fetch Request
        let urlEncoded = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(urlEncoded!, method: .get, parameters: nil) //urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        guard let responseJSON = value as? [String: AnyObject] else {
                            print("Error reading response")
                            return
                        }
                        self.albumElements = Mapper<AlbumDetail>().map(JSON: responseJSON)
                        //self.isExistDays()
                        if self.albumElements?.album != nil {
                            let albumInfo = self.albumElements?.album
                            for imageElement in (albumInfo?.image)! {
                                if imageElement.size == "large" {
                                    imageURL = imageElement.text ?? ""
                                }
                            }
                            self.iv_albumHeader.kf.setImage(with: URL(string: imageURL))
                            self.lb_artist.text = ""
                            self.lb_albumName.text = albumInfo?.name
                            self.lb_albumArtist.text = albumInfo?.artist
                            self.tv_wiki.text = albumInfo?.wiki?.content
                            for trackElement in (albumInfo?.tracks?.track)! {
                                self.albumData.append(AlbumTrackDef(
                                    name: "\(trackElement.name ?? "")",
                                    url: "\(trackElement.url ?? "")"
                                    )
                                )
                            }
                        }
                        IHProgressHUD.dismiss()
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
        
    }
    
    func getArtistData() {
        
        DispatchQueue.global(qos: .utility).async {
            IHProgressHUD.show()
        }
        
        let requestString = "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&api_key=e88ffdb9ae32bcf0dc2c1da618efa5df&artist=\(artist!)&format=json"
        
        var imageURL : String = ""
        
        // Album Fetch Request
        let urlEncoded = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(urlEncoded!, method: .get, parameters: nil) //urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        guard let responseJSON = value as? [String: AnyObject] else {
                            print("Error reading response")
                            return
                        }
                        self.artistElements = Mapper<ArtistDetail>().map(JSON: responseJSON)
                        //self.isExistDays()
                        if self.artistElements?.artist != nil {
                            let artistInfo = self.artistElements?.artist
                            for imageElement in (artistInfo?.image)! {
                                if imageElement.size == "large" {
                                    imageURL = imageElement.text ?? ""
                                }
                            }
                            self.iv_albumHeader.kf.setImage(with: URL(string: imageURL))
                            self.lb_artist.text = ""
                            self.lb_albumName.text = artistInfo?.name
                            self.lb_albumArtist.text = ""
                            self.tv_wiki.text = artistInfo?.bio?.content
                            for similarElement in (artistInfo?.similar?.artist)! {
                                for imageElement in (similarElement.image)! {
                                    if imageElement.size == "large" {
                                        imageURL = imageElement.text ?? ""
                                    }
                                }
                                self.artistData.append(ArtistSimilarDef(
                                    name: "\(similarElement.name ?? "")",
                                    url: "\(similarElement.url ?? "")",
                                    image: "\(imageURL)"
                                    )
                                )
                            }
                        }
                        IHProgressHUD.dismiss()
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
        
    }
    
    func getTrackData() {
        
        DispatchQueue.global(qos: .utility).async {
            IHProgressHUD.show()
        }
        
        let requestString = "http://ws.audioscrobbler.com/2.0/?method=track.getinfo&api_key=e88ffdb9ae32bcf0dc2c1da618efa5df&artist=\(artist!)&track=\(track!)&format=json"
        
        var imageURL : String = ""
        
        // Album Fetch Request
        let urlEncoded = requestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(urlEncoded!, method: .get, parameters: nil) //urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        guard let responseJSON = value as? [String: AnyObject] else {
                            print("Error reading response")
                            return
                        }
                        self.trackElements = Mapper<TrackDetail>().map(JSON: responseJSON)
                        //self.isExistDays()
                        if self.trackElements?.track != nil {
                            let trackInfo = self.trackElements?.track
                            for imageElement in (trackInfo?.album?.image)! {
                                if imageElement.size == "large" {
                                    imageURL = imageElement.text ?? ""
                                }
                            }
                            self.iv_albumHeader.kf.setImage(with: URL(string: imageURL))
                            self.lb_artist.text = self.artist
                            self.lb_albumName.text = self.track
                            self.lb_albumArtist.text = trackInfo?.album?.title
                            self.tv_wiki.text = trackInfo?.wiki?.content
                            for toptagElement in (trackInfo?.toptags?.tag)! {
                                self.trackData.append(TrackDetailDef(
                                    name: "\(toptagElement.name ?? "")",
                                    url: "\(toptagElement.url ?? "")"
                                    )
                                )
                            }
                        }
                        IHProgressHUD.dismiss()
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
        
    }
    
}

struct AlbumTrackDef {
    var name : String
    var url : String
}

struct ArtistSimilarDef {
    var name : String
    var url : String
    var image : String
}

struct TrackDetailDef {
    var name : String
    var url : String
}
