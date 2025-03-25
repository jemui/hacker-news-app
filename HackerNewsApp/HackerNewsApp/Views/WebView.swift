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
    let id: Int?
    var onLoadFinished: (() -> Void)?
    
    var isLoading: Bool = false
    var webView: WKWebView = WKWebView()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
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
        guard let id = id else {
            print("[d] title doesnt exist")
            return
        }
       
        
        if !VisitedLinks.shared.links.contains(id) {
            VisitedLinks.shared.links.append(id)
        }
      
        let request = URLRequest(url: url)
        uiView.load(request)
      
    }
}

//handles loading state
extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true //show loading when page starts
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false //hide loading when finished
            
            if let callback = parent.onLoadFinished {
                callback()
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false //hide even if there's an error
            
            if let callback = parent.onLoadFinished {
                callback()
            }
        }
    }

}
