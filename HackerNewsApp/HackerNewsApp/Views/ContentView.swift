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
        NavigationView {
            List(networkManager.posts) { post in
                NavigationLink(destination: DetailView(url: post.url)) {
                    VStack {
                        Text(post.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(post.by)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                    }
                }
                
                if post == networkManager.posts.last {
                    Button("Show More") {
                        networkManager.increaseMaxArticles()
                        self.networkManager.fetchIds()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

            }
            .navigationBarTitle("HACKER NEWS")
            
                        
        }
        .onAppear {
            self.networkManager.fetchIds()
        }
       
       
    }
}

#Preview {
    ContentView()
}
