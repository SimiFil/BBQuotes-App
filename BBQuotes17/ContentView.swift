//
//  ContentView.swift
//  BBQuotes17
//
//  Created by Filip Simandl on 15.09.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FetchView(show: Constants.bbName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label(Constants.bbName, systemImage: "tortoise")
                }
            
            FetchView(show: Constants.bcsName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label(Constants.bcsName, systemImage: "briefcase")
                }
            
            FetchView(show: Constants.ecName)
                .toolbarBackground(.visible, for: .tabBar)
                .tabItem {
                    Label(Constants.ecName, systemImage: "car")
                }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
