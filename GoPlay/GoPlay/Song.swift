//
//  Song.swift
//  asdf
//
//  Created by Paige Rox on 15/08/2017.
//  Copyright © 2017 RoxPaige. All rights reserved.
//

import Foundation
import UIKit

class Song {
    
    var title = ""
    var artist = ""
    var image = ""
    var songID = ""
    var senderID = ""
    
    public var description: String { return "title: \(title), artist: \(artist), image: \(image), songID: \(songID), senderID: \(senderID)" }
    
    init(image: String, title: String, artist: String, songID: String, senderID: String) {
        self.image = image
        self.title = title
        self.artist = artist
        self.songID = songID
        self.senderID = senderID
    }
    
    init() {
        
    }
}
