//
//  ViewController.swift
//  MusicPlayer
//
//  Created by user190722 on 2/23/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    
    //Boolean controling reproduction
    var isPaused: Bool = false
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initial values for buttons
        btnPause.isHidden = true
        btnPlay.isHidden = false
        
 
    }
    
    func initPlayer(soundName: String) {
        //Song file testing
        guard let url = Bundle.main.url(forResource: "\(soundName)", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        player = try? AVAudioPlayer(contentsOf: url)
            
        if player != nil {

                player.delegate = self
                
                print(player.duration)
                print(player.format)
                print(player.volume)
            
        } else {
                print("Player is null")

        }
    }
    
    @IBAction func Backward(_ sender: UIButton) {
        //When press backward, change to the previous song
        print("Canción anterior")
    }
    
    @IBAction func Play(_ sender: UIButton) {
        //When press play button hidden it and display pause button
        btnPlay.isHidden = true
        btnPause.isHidden = false
        //initPlayer(soundName: "Imagine_Dragons_Warriors_Worlds_2014")
        initPlayer(soundName: "Imagine_Dragons_Warriors_Worlds_2014")
        if player != nil {
            player.play()
        } else {
            print("No ha sido posible reproducir la canción")
        }
        
    }
    
    @IBAction func Pause(_ sender: UIButton) {
        //When press pause button hidden it and display play button
        btnPlay.isHidden = false
        btnPause.isHidden = true
        if player != nil {
            player.stop()
            print(player.currentTime)
        }
    }
    
    @IBAction func Forward(_ sender: UIButton) {
        //When press forward, change to the next song
        print("Canción siguiente")
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        btnPlay.isHidden = false
        btnPause.isHidden = true
        print("Reproducción terminada")
    }
}

