//
//  ImageLoader.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//

import UIKit
import Foundation

final class ImageLoader {
    static let shared = ImageLoader()

    let cache = NSCache<NSURL, UIImage>()
    private var running = [NSURL: [((UIImage?) -> Void)]]()
    
    private let sync = DispatchQueue(label: "com.randomusers.imageloader")

    func load(
        _ url: URL,
        completion: @escaping (UIImage?) -> Void
    ) {
        let key = url as NSURL

        if let img = cache.object(forKey: key) {
            completion(img)
            return
        }

        var shouldStartRequest = false
        sync.sync {
            if var list = running[key] {
                list.append(completion)
                running[key] = list
            } else {
                running[key] = [completion]
                shouldStartRequest = true
            }
        }
        
        guard shouldStartRequest else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self else { return }
            let img = data.flatMap(UIImage.init)
            if let img {
                cache.setObject(img, forKey: key)
            }

            sync.sync {
                let completions = self.running[key] ?? []
                self.running[key] = nil
                completions.forEach { $0(img) }
            }
        }.resume()
    }
}
