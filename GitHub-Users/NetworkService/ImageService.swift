//
//  URL+DownloadImage.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

extension URL {
    var djbHash: Int {
        return self.absoluteString.utf8
            .map {return $0}
            .reduce(5381) {
                ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    
    var djbHashString: String {
        String(djbHash)
    }
}

class ImagePersister {
    
    private let cache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let rootUrl: URL
    
    init() {
        guard let url = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Error - could not access filesystem")
        }
        rootUrl = url
    }
    
}
extension ImagePersister {
    
    // MARK: - Data Accessors
    
    func set(_ data: Data, forKey key: String) {
        let nsData = NSData(data: data)
        let nsString = NSString(string: key)
        cache.setObject(nsData, forKey: nsString)
        self.save(data, forKey: key)
    }
    
    func get(forKey key: String) -> Data? {
        let nsString = NSString(string: key)
        if let data = cache.object(forKey: nsString) {
            return Data(referencing: data)
        }
        else if let diskData = load(forKey: key) {
            let nsData = NSData(data: diskData)
            cache.setObject(nsData, forKey: nsString)
            return diskData
        }
        return nil
    }
    
    // MARK: - Disk Accessors
    
    private func load(forKey key: String) -> Data? {
        let url = rootUrl.appendingPathComponent(key)
        return try? Data(contentsOf: url)
    }
    
    private func save(_ data: Data, forKey key: String) {
        let url = rootUrl.appendingPathComponent(key)
        try? data.write(to: url)
    }
    
}

class ImageService {
    
    private let session = URLSession(configuration: .default)
    private var currentDownloads = Set<URL>()
    private var lock = NSLock()
    private let persister = ImagePersister()
    
    func download(url: URL, _ completion: @escaping (Data?) -> Void) {
        let key = url.djbHashString
        if let saved = persister.get(forKey: key) {
            completion(saved)
            return
        }
        if let diskData = persister.get(forKey: key) {
            completion(diskData)
            return
        }
        completion(nil)
        if currentDownloads.contains(url) {
            return
        }
        let dataTask = session.dataTask(with: url) { (data, _, _) in
            completion(data)
            self.lock.lock(); defer { self.lock.unlock() }
            if let data = data {
                self.persister.set(data, forKey: key)
            }
            self.currentDownloads.remove(url)
        }
        currentDownloads.insert(url)
        dataTask.resume()
    }
    
}

