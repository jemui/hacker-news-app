//
//  NetworkManager.swift
//  HackerNewsApp
//
//  Created by Jeanette on 2/10/25.
//

import Foundation

class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    @Published var idArray: [Int] = []
    private var maxArticles: Int = 5
    
    func increaseMaxArticles() {
        maxArticles += 5
    }
    
    func fetchIds() {
        let finalURL = "https://hacker-news.firebaseio.com/v0/topstories.json"
        guard let url = URL(string: finalURL) else {
            print("[d] invalid url<##>")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                
                guard let data = data else {
                    print("[d] data does not exist")
                    return
                }
                
                do {
                    let results = try decoder.decode([Int].self, from: data)
                    Task {
                        let arrayLength = min(results.count, self.maxArticles)
                        self.idArray = Array(results.prefix(arrayLength))
                      
                        //TODO: show more shows when it's not supposed to
                        for id in self.idArray {
                            self.fetchData(id: id)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func fetchData(id: Int) {
        print("[d] fetch data by id<##> \(id)")
        let endPoint = "https://hacker-news.firebaseio.com/v0/item/"
        let finalURL = "\(endPoint)\(id).json"
        print("[d] url<##> \(finalURL)")
        guard let url = URL(string: finalURL) else {
            print("[d] invalid url<##>")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                
                guard let data = data else {
                    print("[d] data does not exist")
                    return
                }
                
                do {
                    let results = try decoder.decode(Post.self, from: data)
//                    print("[d] results<##> \(results)")
                    DispatchQueue.main.async {
                        self.posts.append(results)
                    }
                } catch {
                    print(error)
                }
               
            }
            else {
                print(error!)
            }
        }
        task.resume()
    }
}
