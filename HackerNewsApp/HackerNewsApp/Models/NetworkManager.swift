//
//  NetworkManager.swift
//  HackerNewsApp
//
//  Created by Jeanette on 2/10/25.
//

import Foundation

@MainActor
class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    @Published var idArray: [Int] = []
    @Published var isLoading: Bool = false
    
    private var maxArticles: Int = 5
    
    func increaseMaxArticles() {
        maxArticles += 5
    }
    
    //get list of all the top stories before getting data from each story
    func fetchIds() {
        let finalURL = "https://hacker-news.firebaseio.com/v0/topstories.json"
        guard let url = URL(string: finalURL) else {
            print("[d] invalid url<##>")
            return
        }
        
        isLoading = true
        
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
                        let arrayLength = await min(results.count, self.maxArticles)
                        let resultArray = Array(results.prefix(arrayLength))
                        
                        await MainActor.run {
                            //get data for each story id
                            resultArray.forEach { id in
                                if !self.idArray.contains(id) {
                                    self.idArray.append(id)
                                    self.fetchData(id: id)
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //get data by id
    func fetchData(id: Int) {
//        print("[d] fetch data by id<##> \(id)")
        let endPoint = "https://hacker-news.firebaseio.com/v0/item/"
        let finalURL = "\(endPoint)\(id).json"
//        print("[d] url<##> \(finalURL)")
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
                    Task {
                        
                        await MainActor.run {
                            self.posts.append(results)
                            
                            //all data is fetched for all ids
                            if self.posts.count == self.idArray.count {
                                self.isLoading = false
                            }
                               
                        }
                       
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
