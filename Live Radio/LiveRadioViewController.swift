//
//  LiveRadioViewController.swift
//  Live Radio
//
//  Created by Nikolay Khramchenko on 11/23/16.
//  Copyright © 2016 nxpams. All rights reserved.
//

import UIKit
import MediaPlayer

class LiveRadioViewController : UIViewController {

    var moviePlayer : MPMoviePlayerController!;
    
    @IBOutlet weak var playStopButton: UIButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        Parameters.sharedInstance.RADIO_URL = "http://air2.radiorecord.ru:805/rock_320";
        self.playStopButton.setTitle("PLAY", for: .normal);
        
        UIApplication.shared.beginReceivingRemoteControlEvents();
        let mpRemoteCommandCenter = MPRemoteCommandCenter.shared();
        mpRemoteCommandCenter.previousTrackCommand.isEnabled = false;
        mpRemoteCommandCenter.nextTrackCommand.isEnabled = false;
        
        mpRemoteCommandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            if (self.playRadio()) {
                self.playStopButton.setTitle("STOP", for: .normal);
                return .success
            }
            return .noSuchContent;
        }
        
        mpRemoteCommandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.stopRadio();
            self.playStopButton.setTitle("PLAY", for: .normal);
            return .success;
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(LiveRadioViewController.handleRouteChange), name: NSNotification.Name.AVAudioSessionRouteChange, object: AVAudioSession.sharedInstance());
    }
    
    func playRadio() -> Bool {
        let radioURL : URL! = URL(string: Parameters.sharedInstance.RADIO_URL);
        if (radioURL != nil) {
            self.moviePlayer = MPMoviePlayerController(contentURL: URL(string: Parameters.sharedInstance.RADIO_URL)!);
            self.moviePlayer.movieSourceType = .streaming;
            self.moviePlayer.prepareToPlay();
            self.moviePlayer.play();
            
            return true;
        } else {
            self.moviePlayer = nil;
            print("ERROR: Invalid radio URL");
            return false;
        }
        
    }
    
    func stopRadio() {
        if (self.moviePlayer != nil) {
            self.moviePlayer.stop();
            self.moviePlayer = nil;
        }
    }
    
    @IBAction func playStopButtonPressed(_ sender: Any) {
        if (self.moviePlayer == nil) {
            if (self.playRadio()) {
                self.playStopButton.setTitle("STOP", for: .normal);
            }
        } else {
            self.stopRadio();
            self.playStopButton.setTitle("PLAY", for: .normal);
        }
    }
    
    func handleRouteChange(notification : Notification) {
        let dict = notification.userInfo;
        let routeDesc : AVAudioSessionRouteDescription = dict![AVAudioSessionRouteChangePreviousRouteKey] as! AVAudioSessionRouteDescription;
        let prevPort : AVAudioSessionPortDescription = routeDesc.outputs[0];
        if (prevPort.portType == AVAudioSessionPortHeadphones) {
            self.stopRadio();
            self.playStopButton.setTitle("PLAY", for: .normal);
        }
    }

}

