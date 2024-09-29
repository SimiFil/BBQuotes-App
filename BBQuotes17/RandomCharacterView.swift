//
//  RandomCharacterView.swift
//  BBQuotes17
//
//  Created by Filip Simandl on 28.09.2024.
//

import SwiftUI

struct RandomCharacterView: View {
    let character: Character
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(character.name)
                .font(.title)
            
            AsyncImage(url: character.images.first?.standardized) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 15))
            } placeholder: {
                ProgressView()
            }
            
            Text("Productions: ")
                .font(.title3)
                .minimumScaleFactor(0.5)
                .padding(.bottom, 5)

            ForEach(character.productions, id: \.self) { production in
                Text("📌 \(production)")
            }
        }
        .padding()
        .foregroundStyle(.white)
        .background(.black.opacity(0.6))
        .clipShape(.rect(cornerRadius: 15))
        .padding(.horizontal, 10)
    }
}

#Preview {
    RandomCharacterView(character: Viewmodel().character)
}
