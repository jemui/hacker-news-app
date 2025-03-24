//
//  WebView.swift
//  HackerNewsApp
//
//  Created by Jeanette on 2/11/25.
//

import Foundation
import SwiftUI
import WebKit   

struct WebView: UIViewRepresentable {
    
    let urlString: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let safeString = urlString else {
            print("[d] safestring doesnt exist")
            return
        }
        guard let url = URL(string: safeString) else {
            print("[d] url doesnt exist")
            return
        }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
