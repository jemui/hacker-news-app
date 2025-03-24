//
//  LoadingView.swift
//  HackerNewsApp
//
//  Created by Jean on 3/24/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .frame(maxWidth: .infinity, alignment: .center)
        
    }
}
