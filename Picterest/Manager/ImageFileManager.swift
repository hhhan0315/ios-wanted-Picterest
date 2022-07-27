//
//  ImageFileManager.swift
//  Picterest
//
//  Created by rae on 2022/07/27.
//

import UIKit

final class ImageFileManager {
    static let shared = ImageFileManager()
    private init() {}
    
    func saveImage(id: String, data: Data, completion: @escaping (Bool) -> Void) {
        guard let image = UIImage(data: data) else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            completion(false)
            return
        }
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            completion(false)
            return
        }
        
        do {
            guard let url = directory.appendingPathComponent("\(id).png") else {
                completion(false)
                return
            }
            
            try imageData.write(to: url)
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func getSavedImage(id: String) -> UIImage? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        
        return UIImage(contentsOfFile: URL(fileURLWithPath: directory.absoluteString).appendingPathComponent("\(id).png").path)
    }
    
    func getSavedImageURL(id: String) -> URL? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        return directory.appendingPathComponent("\(id).png")
    }
}
