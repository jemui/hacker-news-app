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
            List(networkManager.posts) { post in
                ArticleView(post: post, networkManager: networkManager)
            }
            .navigationDestination(for: Post.self ) { post in
                DetailView(url: post.url, id: post.id)
            }
            .navigationBarTitle("HACKER NEWS")
        }
        .onAppear {
            self.networkManager.fetchIds()
        }
    }
}

struct ArticleView: View {
    @State private var refreshID = UUID() //track refresh state
    
    let post: Post
    let networkManager: NetworkManager
    
    var body: some View {
        //vstack of posts
        VStack {
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
