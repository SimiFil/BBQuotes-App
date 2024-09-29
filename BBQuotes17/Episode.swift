//
//  Episode.swift
//  BBQuotes17
//
//  Created by Filip Simandl on 26.09.2024.
//

import Foundation

struct Episode: Decodable {
    let episode: Int // 101 - 1: season, 01: episode
    let title: String
    let image: URL
    let synopsis: String
    let directedBy: String
    let airDate: String
    let writtenBy: String
    
    var seasonEpisode: String {
        var episodeString = String(episode) // "101"
        let season = episodeString.removeFirst() // season: "1", episodeString: "01"
        
        if episodeString.first == "0" {
            episodeString = String(episodeString.removeLast())
        }
        
        return "Season \(season), Episode \(episodeString)"
    }
}
