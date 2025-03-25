//
//  ArticleView.swift
//  HackerNewsApp
//
//  Created by Jean on 3/25/25.
//

import SwiftUI

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
                        //refresh when text reappears to update color when visited
                        refreshID = UUID()
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
