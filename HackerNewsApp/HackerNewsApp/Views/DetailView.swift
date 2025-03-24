//
//  DetailView.swift
//  HackerNewsApp
//
//  Created by Jeanette on 2/10/25.
//

import SwiftUI
import WebKit

struct DetailView: View {
    
    let url: String?
    let id: Int?
    @State var isLoading = true
    
    var body: some View {
        if isLoading {
            LoadingView()
        }
        
        WebView(urlString: url, id: id) {
            isLoading = false
        }
    }
}

#Preview {
    DetailView(url: "www.google.com", id: 0)
}
