//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by christopher bijalba on 3/17/15.
//  Copyright (c) 2015 christopher bijalba. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    
    @IBOutlet weak var playSlow: UIButton!
    @IBOutlet weak var stopPlay: UIButton!
    @IBOutlet weak var playFast: UIButton!
    @IBOutlet weak var playDarthvaderAudio: UIButton!
    @IBOutlet weak var playChipmunkAudio: UIButton!
    @IBOutlet weak var playReverb: UIButton!
    @IBOutlet weak var playEcho: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true;
        audioPlayer.delegate = self
        
        // This piece of code sets the sound to always play on the Speakers
        let session = AVAudioSession.sharedInstance()
        var error: NSError?
        session.setCategory(AVAudioSessionCategoryPlayback, error: &error)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        session.setActive(true, error: &error)
    }

    override func viewWillAppear(animated: Bool) {
        // Starting states for things
        stopPlay.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlow(sender: AnyObject) {
        // Play slow function
        interruptPlaying(playSlow)  // Stop anything playing and pass the button
        
        audioPlayer.rate = 0.5      // Half speed
        audioPlayer.play()          // Play
    }

    @IBAction func playFast(sender: AnyObject) {
        // Play fast function
        interruptPlaying(playFast)
        
        audioPlayer.rate = 2;       // Double speed
        audioPlayer.play()
    }
    
    @IBAction func stopPlaying(sender: AnyObject) {
        
        interruptPlaying(stopPlay)
    
    }
    
    @IBAction func playChimpunkAudio(sender: UIButton) {
        // Play like a Chipmunk
        interruptPlaying(playChipmunkAudio)
        
        var highPitchEffect = AVAudioUnitTimePitch()
        highPitchEffect.pitch = 1000
        playAudioAndEffect(highPitchEffect)
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // Play like Darth Vader
        interruptPlaying(playDarthvaderAudio)

        var lowPitchEffect = AVAudioUnitTimePitch()
        lowPitchEffect.pitch = -1000
        playAudioAndEffect(lowPitchEffect)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        // Play with Reverb
        interruptPlaying(playReverb)

        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.Cathedral)
        reverbEffect.wetDryMix = 50
        playAudioAndEffect(reverbEffect)
    }
    
    
    @IBAction func playEchoAudio(sender: UIButton) {
        // Play with Echo
        interruptPlaying(playEcho)
        
        var delayEffect = AVAudioUnitDelay()
        delayEffect.delayTime = 0.5
        playAudioAndEffect(delayEffect)
    }

    func playAudioAndEffect(effect: NSObject){
        // Any effects for the audio engine
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect as AVAudioNode)
        
        audioEngine.connect(audioPlayerNode, to: effect as AVAudioNode, format: nil)
        audioEngine.connect(effect as AVAudioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    func stopButtonToggle(theButton:UIButton){
        // This toggles the stop button based on which button was pressed.
        // If stop is pressed, hide stop
        // Otherwise, show stop
        
        switch theButton{
        
        case stopPlay:
            stopPlay.hidden=true
        
        case playEcho, playReverb, playDarthvaderAudio, playChipmunkAudio:
            // I had no idea how to trigger anything after audio stops
            // when playing via the audioEngine... so don't show stop here
            // or else the stop button stays after audio is finished.
            // need something executable in any case statement, anyway.
            stopPlay.hidden=true
        
        default:
            // playSlow and playFast will trigger this
            stopPlay.hidden=false
    
        }
    }
    
    func interruptPlaying(theButton:UIButton){
        // Stop anything that's playing
        
        stopButtonToggle(theButton)     // Toggle button visibility based on which was pressed
        resetEngine()                   // Reset the audio engine
        audioPlayer.stop()              // Stop the audioPlayer
        audioPlayer.currentTime = 0.0   // Set player to beginning
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        // Why doesn't this exist for the audio engine? Default AudioPlayer stop
        stopPlay.hidden = true
    }
    
    func resetEngine(){
        // Function to reset the Engine
        audioEngine.stop()
        audioEngine.reset()
    }
}

