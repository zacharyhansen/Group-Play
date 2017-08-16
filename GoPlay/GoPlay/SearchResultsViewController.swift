//
//  ViewController.swift
//  asdf
//
//  Created by Paige Rox on 13/08/2017.
//  Copyright © 2017 RoxPaige. All rights reserved.
//

import UIKit
import Foundation

class SearchResultsViewController: UITableViewController {
    
    var query = "Ocean+to+City"
    let youTubeApiKey = "AIzaSyCubBdSYXilzArkc9dgwQexrP4Zk_yRy-k"
    let spotifyAccessToken = "BQBpqaa6b2zhlZbek47iJOI0oewfhUeLEAd1YGFB10_CjMxksJNxNoWw-w7o7Q_GXAngrSq-vVQoajEjnf7mhG0JPg6Qf91Wii4vwGK2965zpu_XrayRF0oIEXiPUszWCe5fpibAcR5P"
    var results = [Song]()
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getYouTubeResults(query: query)
        getSpotifyResults(query: query)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getYouTubeResults(query: String) -> Void {
        let rewrittenQuery = query.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(rewrittenQuery)&type=video&maxResults=10&key=\(youTubeApiKey)"
        let targetURL = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: targetURL!) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            let resultsDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, AnyObject>
            let items: Array<Dictionary<String, AnyObject>> = resultsDictionary["items"] as! Array<Dictionary<String, AnyObject>>
            for i in 0 ..< items.count {
                let snippetDict = items[i]["snippet"] as! Dictionary<String, AnyObject>
                let newSong = Song()
                newSong.title = snippetDict["title"] as! String
                newSong.image = ((snippetDict["thumbnails"] as! Dictionary<String, AnyObject>)["default"] as! Dictionary<String, AnyObject>)["url"] as! String
                newSong.artist = snippetDict["channelTitle"] as! String
                newSong.songID = (items[i]["id"] as! Dictionary<String, AnyObject>)["videoId"] as! String
                self.results.append(newSong)
            }
        }
        task.resume()
    }
    
    func getSpotifyResults(query: String) -> Void {
        let rewrittenQuery = query.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://api.spotify.com/v1/search?q=\(rewrittenQuery)&type=track,artist&limit=10"
        let targetURL = URL(string: urlString)
        var requestURL = URLRequest(url: targetURL!)
        requestURL.addValue("Bearer \(spotifyAccessToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            let resultsDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, AnyObject>
            let tracks: Array<Dictionary<String, AnyObject>> = resultsDictionary["tracks"]!["items"] as! Array<Dictionary<String, AnyObject>>
            for i in 0 ..< tracks.count {
                let snippetDict = tracks[i] as Dictionary<String, AnyObject>
                let newSong = Song()
                newSong.title = snippetDict["name"] as! String
                newSong.image = (snippetDict["album"]?["images"] as! Array<Dictionary<String, AnyObject>>)[0]["url"] as! String
                newSong.artist = (snippetDict["artists"] as! Array<Dictionary<String, AnyObject>>)[0]["name"] as! String
                newSong.songID = snippetDict["uri"] as! String
                self.results.append(newSong)
            }
        }
        task.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultsViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultsViewCell  else {
            fatalError("The dequeued cell is not an instance of SearchResultsViewCell.")
        }
        let result = results[indexPath.row]
        cell.title.text = result.title
        let url = URL(string: result.image)
        let data = try? Data(contentsOf: url!)
        cell.songImage.image = UIImage(data: data!)
        cell.artist.text = result.artist
        return cell
    }
    
    func addToQueue() {
        // still working on this
        // don't forget to add userID to song
    }
    
}
