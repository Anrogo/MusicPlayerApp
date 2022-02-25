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
    
    //Song elements
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    
    //Array with object of Song
    let songsArray: [Song] = Song.songs()
    
    //Default song always
    var currentSong = 0
    
    //Boolean controling reproduction
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
        
        //for song in songsArray {
            //print(song.name)
            //print(song.author)
        //}
        
 
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
        updateSong()
        reset()
    }
    
    //Button Action to play the song
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
        }
    }
    //Button Action when press forward, change to the next song
    @IBAction func Forward(_ sender: UIButton) {
        
        if currentSong == songsArray.count - 1 {
            currentSong = 0
        } else {
            currentSong += 1
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
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayCurrentTime), userInfo: nil, repeats: true)
            } else {
                print("No ha sido posible reproducir la canción")
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
        songTitleLabel.text = songsArray[currentSong].name
        songImageView.image = UIImage(named: songsArray[currentSong].image)
    }
    
    //Update slider timeline
    func updateTime(){
        timeSlider.value = Float(player.currentTime/player.duration)
        print(timeSlider.value)
    }
    
    //Reset values
    func reset(){
        isPaused = false
        timer?.invalidate()
        timer = nil
        timeSlider.value = 0
    }
    
    //Method to be executed when playback is finished
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //Adjusted for variables and values
        btnPlay.isHidden = false
        btnPause.isHidden = true
        currentSong += 1
        print("Reproducción terminada")
        reset()
        //Go to the next song and plays it
        updateSong()
        playAudio()
    }
}

