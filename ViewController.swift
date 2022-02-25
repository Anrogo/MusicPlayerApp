//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Antonio Rodríguez González on 2/23/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    //Interface elements
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    //Song elements
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    
    //Array with Song Objects
    let songsArray: [Song] = Song.songs()
    
    //Default song always the first, 0
    var currentSong = 0
    
    //Boolean controlling reproduction
    var isPaused: Bool = false
    
    //Initialising my object of AVAudioPlayer
    var player: AVAudioPlayer!
    
    //Timer control
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initial values for buttons
        btnPause.isHidden = true
        btnPlay.isHidden = false
        
        //First song
        updateSong()
    }
    //Create the player for each song
    func initPlayer(soundName: String) {
        //Guard let to avoid risks (such as nil value exceptions)
        guard let url = Bundle.main.url(forResource: "\(soundName)", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        //Create it based on the url
        player = try? AVAudioPlayer(contentsOf: url)
        
        if player != nil { //If it's not null

            player.delegate = self
            //Song info
            print(player.duration)
            print(player.format)
            print(player.volume)
            
        } else {
            print("Player is null")
        }
    }
    
    //When press backward, change to the previous song
    @IBAction func Backward(_ sender: UIButton) {
        if currentSong == 0 {
            currentSong = songsArray.count - 1
        } else {
            currentSong -= 1
        }
        if !isPaused {
            btnPlay.isHidden = false
            btnPause.isHidden = true
        }
        updateSong()
        reset()
    }
    
    //Button Action to play the song through another method
    @IBAction func Play(_ sender: UIButton) {
        playAudio()
    }
    
    //button Action to pause the song
    @IBAction func Pause(_ sender: UIButton) {
        //When press pause button hidden it and display play button
        btnPlay.isHidden = false
        btnPause.isHidden = true
        if player != nil {
            player.stop()
            print(player.currentTime)
            isPaused = true
            print("Pausado")
        }
    }
    //Button Action when press forward, change to the next song
    @IBAction func Forward(_ sender: UIButton) {
        
        if currentSong == songsArray.count - 1 {
            currentSong = 0
        } else {
            currentSong += 1
        }
        if !isPaused {
            btnPlay.isHidden = false
            btnPause.isHidden = true
        }
        updateSong()
        reset()
    }
    
    //Method to update the slider indicating the timeline of song
    @IBAction func seekTime(_ sender: UISlider) {
        //print(sender.value)
        let timeInterval = TimeInterval(Float(sender.value) * Float(self.player.duration))
        //print(timeInterval)
        player.currentTime = timeInterval
        if !isPaused {
            player.play(atTime: timeInterval)
        }
    }
    
    //Main method for playing each song
    func playAudio(){
        
        //When press play button hidden it and display pause button
        btnPlay.isHidden = true
        btnPause.isHidden = false
        
        if !isPaused {
            initPlayer(soundName: songsArray[currentSong].filename)
            if player != nil {
                print("Reproduciendo..")
                player.play()
                //Timer to control playback time and pause or move the timeline
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(displayCurrentTime), userInfo: nil, repeats: true)
                updateTimeLabel(label: durationLabel, seconds: Int(player.duration))
            } else {
                //When encounters an error will not allow playback
                print("No ha sido posible reproducir la canción")
                btnPlay.isHidden = false
                btnPause.isHidden = true
            }
        } else {
            player.play()
            isPaused = false
        }
    }
    
    @objc func displayCurrentTime(){
        //print("Current time: \(player.currentTime)")
        //print("Duration: \(player.duration)")
        updateTime()
    }
    
    //Method to reset values, change the song and playing automatically
    func updateSong(){
        songTitleLabel.text = "\(songsArray[currentSong].name) - \(songsArray[currentSong].author)"
        songImageView.image = UIImage(named: songsArray[currentSong].image)
        
    }
    
    //Update slider timeline
    func updateTime(){
        timeSlider.value = Float(player.currentTime/player.duration)
        updateTimeLabel(label: currentTimeLabel, seconds: Int(player.currentTime))
        //print(player.currentTime)
    }
    
    func updateTimeLabel(label: UILabel, seconds: Int){
        var remainingSeconds = 0
        if seconds < 10 {
            label.text = "00:0\(seconds)"
        } else {
            if seconds > 60 {
                let minutes = seconds/60
                remainingSeconds = seconds - (minutes * 60)
                label.text = "0\(minutes):\(remainingSeconds)"
            } else {
                label.text = "00:\(seconds)"
            }
        }
    }
    
    //Reset values of slider, timer and pause control
    func reset(){
        timeSlider.value = 0
        timer?.invalidate()
        timer = nil
        isPaused = false
        currentTimeLabel.text = "00:00"
    }
    
    //Method to be executed when playback is finished
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //Adjusted for variables and values
        btnPlay.isHidden = false
        btnPause.isHidden = true
        currentSong = (currentSong + 1 == songsArray.count) ? 0 : currentSong + 1
        print("Reproducción terminada")
        //Go to the next song and plays it
        updateSong()
        reset()
        playAudio()
    }
}

