//
//  FetchView.swift
//  BBQuotes17
//
//  Created by Filip Simandl on 23.09.2024.
//

import SwiftUI

struct FetchView: View {
    let vm = Viewmodel()
    let show: String
    
    @State var showCharacterInfo: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.removeCaseAndSpaces())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                
                VStack {
                    VStack {
                        Spacer(minLength: 60)
                        
                        switch vm.fetchStatus {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .successQuote:
                            Text("\"\(vm.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                AsyncImage(url: vm.character.images.randomElement()) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                                
                                Text(vm.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                        case .successCharacter:
                            RandomCharacterView(character: vm.randomCharacter)
                        case .failed(let error):
                            Text("Error: \(error.localizedDescription)")
                        }
                        
                        Spacer(minLength: 20)
                    }
                    
                    HStack {
                        Button {
                            Task {
                                await vm.getQuoteData(for: show)
                            }
                            
                        } label: {
                            Text("Get Random Quote")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        .frame(minWidth: 120)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await vm.getEpisodeData(for: show)
                            }
                            
                        } label: {
                            Text("Get Random Episode")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        .frame(minWidth: 120)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await vm.getRandomCharacterData(from: show)
                            }
                            
                        } label: {
                            Text("Get Character Data")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        .frame(minWidth: 120)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer(minLength: 125)
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .onAppear {
            Task {
                await vm.getQuoteData(for: show)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showCharacterInfo) {
            CharacterView(character: vm.character, show: show)
        }
    }
}

#Preview {
    FetchView(show: Constants.bcsName)
        .preferredColorScheme(.dark)
}
