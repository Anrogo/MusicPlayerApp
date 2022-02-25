//
//  Song.swift
//  MusicPlayer
//
//  Created by Antonio Rodríguez González on 2/24/22.
//

import Foundation

struct Song {
    var name: String = ""
    var author: String = ""
    var filename: String = ""
    var image: String = ""

    
    init(name: String,author: String, filename: String, image: String){
        self.name = name
        self.author = author
        self.filename = filename
        self.image = image
    }
    
    //Method static to insert, and import, songs data
    static func songs() -> [Song] {
        var songs = [Song]()
        //Add each object of type Song
        songs.append(Song(name: "Warriors World 2014", author: "Imagine Dragons", filename: "Imagine_Dragons_Warriors_Worlds_2014", image: "warriors"))
        songs.append(Song(name: "Ringtone Donald Duck", author: "Unknown", filename: "tone", image: "Donald"))
        songs.append(Song(name: "Inspiration music", author: "Rafael Krux", filename: "inspiration-music", image: "rafael_krux"))
/*        songs.append(Song(name: "Believer", author: "Imagine Dragons", filename: "Believer", image: "believer"))
        songs.append(Song(name: "I'm an albatraoz", author: "AronChupa, Little Sis Nora", filename: "Albatraoz", image: "albatraoz"))
 */
        return songs
    }
}
