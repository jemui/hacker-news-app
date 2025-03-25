//
//  ContentView.swift
//  HackerNewsApp
//
//  Created by Jeanette on 2/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var networkManager = NetworkManager()

    var body: some View {
        
        NavigationStack {
            ZStack {
                BackgroundView()
                
                if networkManager.isLoading {
                    LoadingView()
                }
                
                ListView(networkManager: networkManager)
            }
        }
        .onAppear {
            self.networkManager.fetchIds()
        }
        .scrollContentBackground(.hidden)
    }
}

//list view of navigation stack
struct ListView: View {
    @ObservedObject var networkManager: NetworkManager
    
    var body: some View {
        List(networkManager.posts) { post in
            ArticleView(post: post, networkManager: networkManager)
        }
        .navigationDestination(for: Post.self ) { post in
            DetailView(url: post.url, id: post.id)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Hacker News")
                    .padding(.top)
                    .font(.largeTitle.bold())
                    .foregroundColor(Color(red: 0.36, green: 0.45, blue: 0.52))
                    .shadow(color: .white, radius: 8, x: 0, y: 2)
            }
        }
        .shadow(radius: 5)
    }
  
}

//gradient bg
struct BackgroundView: View {
    var body: some View {
        let colorA = Color(red: 0.78, green: 0.91, blue: 1.00)
        let colorB = Color(red: 1.00, green: 0.87, blue: 0.68)
     
        LinearGradient(gradient: Gradient(colors: [colorA, colorB]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}


#Preview {
    ContentView()
}
