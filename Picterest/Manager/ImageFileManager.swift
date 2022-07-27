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
        
//        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
//            completion(false)
//            return
//        }
        
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(false)
            return
        }
        
        let fileURL = directoryURL.appendingPathComponent("\(id).png")
        
        do {
//            guard let url = directory.appendingPathComponent("\(id).png") else {
//                completion(false)
//                return
//            }
            
//            try imageData.write(to: url)
            try imageData.write(to: fileURL)
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func getSavedImageURL(id: String) -> String? {
//        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
//            return nil
//        }
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = directoryURL.appendingPathComponent("\(id).png")
        return fileURL.path
    }
    
    func getSavedImage(urlString: String) -> UIImage? {
//        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
//            return nil
//        }
//
//        return UIImage(contentsOfFile: URL(fileURLWithPath: directory.absoluteString).appendingPathComponent("\(id).png").path)
        return UIImage(contentsOfFile: urlString)
    }
}
