//
//  Song.swift
//  MusicPlayer
//
//  Created by user190722 on 2/24/22.
//

import Foundation

class Song {
    var name: String = ""
    var author: String = ""
    var paused: Bool = false
    var time: Int = 0
    
    init(name: String,author: String, paused: Bool, time: Int){
        self.name = name
        self.author = author
        self.paused = paused
        self.time =  time
    }
    
    static func songs() -> [Song] {
        var songs = [Song]()
        let song = Song(name: "Warriors World 2014", author: "Imagine Dragons", paused: false, time: 0)
        songs.append(song)
        return songs
    }
}
