//
//  Viewmodel.swift
//  BBQuotes17
//
//  Created by Filip Simandl on 17.09.2024.
//

import Foundation

@Observable
class Viewmodel {
    enum FetchStatus {
        case notStarted
        case fetching
        case successQuote
        case successEpisode
        case successCharacter
        case failed(error: Error)
    }
    
    private(set) var fetchStatus: FetchStatus = .notStarted
    private let fetcher = FetchService()
    
    var quote: Quote
    var randomCharacterQuote: Quote
    var character: Character
    var randomCharacter: Character
    var episode: Episode
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)
        
        let randomCharacterQuoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        randomCharacterQuote = try! decoder.decode(Quote.self, from: randomCharacterQuoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Character.self, from: characterData)
        
        let randomCharacterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        randomCharacter = try! decoder.decode(Character.self, from: randomCharacterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(Episode.self, from: episodeData)
    }
    
    func getQuoteData(for show: String) async {
        fetchStatus = .fetching
        
        do {
            quote = try await fetcher.fetchQuote(from: show)
            
            character = try await fetcher.fetchCharacter(quote.character)
            
            character.death = try await fetcher.fetchDeath(for: character.name)
            
            fetchStatus = .successQuote
        } catch {
            fetchStatus = .failed(error: error)
        }
    }
    
    func getEpisodeData(for show: String) async {
        fetchStatus = .fetching
        
        do {
            if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
                episode = unwrappedEpisode
                
                fetchStatus = .successEpisode
            }
        } catch {
            fetchStatus = .failed(error: error)
        }
    }
    
    func getRandomCharacterData(from production: String) async {
        fetchStatus = .fetching
        
        while true {
            do {
                randomCharacter = try await fetcher.fetchRandomCharacter()
            } catch {
                fetchStatus = .failed(error: error)
            }
            
            if randomCharacter.productions.contains(production) {
                fetchStatus = .successCharacter
                break
            }
        }
    }
    
    func getRandomQuoteFromCharacter(_ characterName: String) async {
        fetchStatus = .fetching
        
        do {
            randomCharacterQuote = try await fetcher.fetchQuoteFromCharacter(characterName)
            
            fetchStatus = .successEpisode
        } catch {
            fetchStatus = .failed(error: error)
        }
    }
}
