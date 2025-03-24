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
    
    var body: some View {
        WebView(urlString: url)
    }
}

#Preview {
    DetailView(url: "www.google.com")
}
