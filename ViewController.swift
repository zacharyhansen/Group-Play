//
//  ViewController.swift
//  asdf
//
//  Created by Paige Rox on 13/08/2017.
//  Copyright © 2017 RoxPaige. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var query = ""
    let youTubeApiKey = "AIzaSyCubBdSYXilzArkc9dgwQexrP4Zk_yRy-k"
    let spotifyAccessToken = "BQCK9WSDTx5KcjpC_K9Y0Sxio2KKgFQRF8T9uWtS3yRFNkVzE31nJRmAPvc5b2vq8YJBpkP89O_KewXmbOCUoHUAdEa_8KAhC4nCcIgf40GFIPQFuBirN3_erpKoRIZ_SQ-cXVVezfhH"
    var youTubeArray: Array<Dictionary<String, AnyObject>> = []
    var spotifyArray: Array<Dictionary<String, AnyObject>> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        query = "Ocean to city"
        self.youTubeArray = getYouTubeResults(query: query)
        self.spotifyArray = getSpotifyResults(query: query)
        displaySearchResults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getYouTubeResults(query: String) -> Array<Dictionary<String, AnyObject>> {
        let rewrittenQuery = query.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(rewrittenQuery)&type=video&maxResults=10&key=\(youTubeApiKey)"
        let targetURL = URL(string: urlString)
        var results : Array<Dictionary<String, AnyObject>> = []
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
                var videoDetailsDict = Dictionary<String, AnyObject>()
                videoDetailsDict["title"] = snippetDict["title"]
                videoDetailsDict["image"] = ((snippetDict["thumbnails"] as! Dictionary<String, AnyObject>)["default"] as! Dictionary<String, AnyObject>)["url"]
                videoDetailsDict["artist"] = snippetDict["channelTitle"]
                videoDetailsDict["id"] = (items[i]["id"] as! Dictionary<String, AnyObject>)["videoId"]
                results.append(videoDetailsDict)
            }
            // results revert back to empty array after closure ends..
        }
        task.resume()
        return results
    }
    
    func getSpotifyResults(query: String) -> Array<Dictionary<String, AnyObject>> {
        let rewrittenQuery = query.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://api.spotify.com/v1/search?q=\(rewrittenQuery)&type=track,artist&limit=10"
        let targetURL = URL(string: urlString)
        var requestURL = URLRequest(url: targetURL!)
        requestURL.addValue("Bearer \(spotifyAccessToken)", forHTTPHeaderField: "Authorization")
        var results : Array<Dictionary<String, AnyObject>> = []
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
                var songDetailsDict = Dictionary<String, AnyObject>()
                songDetailsDict["title"] = snippetDict["name"]
                songDetailsDict["image"] = (snippetDict["album"]?["images"] as! Array<Dictionary<String, AnyObject>>)[0]["url"]
                songDetailsDict["artist"] = (snippetDict["artists"] as! Array<Dictionary<String, AnyObject>>)[0]["name"]
                songDetailsDict["id"] = snippetDict["uri"]
                results.append(songDetailsDict)
            }
            // results revert back to empty array after closure ends..
        }
        task.resume()
        return results
    }
    
    func displaySearchResults() {
        // still working on this
    }

}
