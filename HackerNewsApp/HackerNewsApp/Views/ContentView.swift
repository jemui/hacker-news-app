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
                               .font(.largeTitle.bold()) // Set title font
                               .foregroundColor(Color(red: 0.36, green: 0.45, blue: 0.52)) // Title color
                               .shadow(color: .white, radius: 8, x: 0, y: 2) // Shadow effect
                       }
                   }
                   .shadow(radius: 5)
                   
                
               }
           }
           .onAppear {
               self.networkManager.fetchIds()
           }
           .scrollContentBackground(.hidden)
       }
}
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
struct ArticleView: View {
    @State private var refreshID = UUID() //track refresh state
    
    let post: Post
    let networkManager: NetworkManager
    
    var body: some View {
        //vstack of posts
        NavigationLink(value: post) {
            //vstack of post title and author
            VStack {
                let isVisited = VisitedLinks.shared.links.contains(post.id)
             
                Text(post.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(isVisited ? .gray : .black)
                    .id(refreshID)
                    .onAppear {
                        refreshID = UUID() // refresh when text reappears
                    }
                
                Text(post.by)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                    
            }

        }

        
        //add show more button to add more articles
        if post == networkManager.posts.last {
            Button("Show More") {
                networkManager.increaseMaxArticles()
                self.networkManager.fetchIds()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        
            if networkManager.isLoading {
                LoadingView()
            }
        }
    }
}

#Preview {
    ContentView()
}
