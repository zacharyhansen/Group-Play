

//
//  ViewController.swift
//  asdf
//
//  Created by Paige Rox on 13/08/2017.
//  Copyright © 2017 RoxPaige. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    @IBOutlet weak var spotifyLogInButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    //Spotify authorization
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        myVC.query = textField.text!
        performSegue(withIdentifier: "goToResults", sender: self)
    }
    
    func updateAfterFirstLogin () {
        spotifyLogInButton.isHidden = true
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(session)
        }
    }
    
    func initializePlayer(_ authSession:SPTSession) {
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self// as! SPTAudioStreamingPlaybackDelegate
            self.player!.delegate = self// as! SPTAudioStreamingDelegate
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func setup() {
        SPTAuth.defaultInstance().clientID = "f6e7c49a219648e68e51db3505603b49"
        SPTAuth.defaultInstance().redirectURL = URL(string: "SpotifySearch://returnAfterLogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
}
