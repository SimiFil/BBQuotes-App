//
//  CharacterView.swift
//  BBQuotes17
//
//  Created by Filip Simandl on 24.09.2024.
//

import SwiftUI

struct CharacterView: View {
    let character: Character
    let vm = Viewmodel()
    let show: String
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ZStack(alignment: .top) {
                    Image(show.removeCaseAndSpaces())
                        .resizable()
                        .scaledToFit()
                    
                    ScrollView {
                        TabView {
                            ForEach(character.images, id: \.self) {
                                characterImageURL in
                                AsyncImage(url: characterImageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            
                        }
                        .tabViewStyle(.page)
                        .frame(width: geo.size.width/1.2, height: geo.size.height/1.7)
                        .clipShape(.rect(cornerRadius: 25))
                        .padding(.top, 60)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(character.name)
                                .font(.title)
                            
                            Text("Portrayed by: \(character.portrayedBy)")
                                .font(.subheadline)
                            
                            Divider()
                            
                            Text("\(character.name) Character Info")
                                .font(.title2)
                            
                            Text("Born: \(character.birthday)")
                            
                            Divider()
                            
                            Text("Random Quote:")
                                .font(.title2)
                            
                            Text("\"\(vm.randomCharacterQuote.quote)\"")
                                .foregroundStyle(.orange)
                            
                            Divider()
                            
                            Text("Occupations:")
                            
                            ForEach(character.occupations, id: \.self) { occupation in
                                Text("• \(occupation)")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            Text("Nicknames:")
                            
                            if character.aliases.count > 0 {
                                ForEach(character.occupations, id: \.self) { alias in
                                    Text("• \(alias)")
                                        .font(.subheadline)
                                }
                            } else {
                                Text("None")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            DisclosureGroup("Status (spoiler alert!)") {
                                VStack(alignment: .leading) {
                                    Text(character.status)
                                        .font(.title2)
                                        .foregroundStyle(character.status == "Dead" ? .red : .green)
                                    
                                    if let death = character.death {
                                        AsyncImage(url: death.image) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(.rect(cornerRadius: 15))
                                                .onAppear {
                                                    withAnimation(.easeInOut) {
                                                        proxy.scrollTo(1, anchor: .bottom)
                                                    }
                                                }
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                        Spacer(minLength: 20)
                                        
                                        Text("How: \(death.details)")
                                            .padding(.bottom, 7)
                                        
                                        Text("Last words: \"\(death.lastWords)\"")
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .tint(.primary)
                            
                        }
                        .frame(width: geo.size.width/1.25, alignment: .leading)
                        .padding(.bottom, 50)
                        .id(1)
                        
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                await vm.getRandomQuoteFromCharacter(character.name)
            }
            
        }
    }
}

#Preview {
    CharacterView(character: Viewmodel().character, show: Constants.bbName)
}
