//
//  ImageFileManager.swift
//  Picterest
//
//  Created by rae on 2022/07/27.
//

import UIKit

final class ImageFileManager {
    static let shared = ImageFileManager()
    private init() {
        createDirectory()
    }
    
    private let fileManager = FileManager.default
    private lazy var directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SavePhoto")
    
    private func createDirectory() {
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: false)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveImage(id: String, data: Data) {
        guard let image = UIImage(data: data) else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }
        
        let fileURL = directoryURL.appendingPathComponent(id).appendingPathExtension("png")
        
        do {
            try imageData.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchImageURLString(id: String) -> String {
        return directoryURL.appendingPathComponent(id).appendingPathExtension("png").path
    }
    
    func fetchImage(id: String) -> UIImage? {
        return UIImage(contentsOfFile: fetchImageURLString(id: id))
    }
    
    func existImageInFile(id: String, completion: @escaping (Bool) -> Void) {
        let path = fetchImageURLString(id: id)
        fileManager.fileExists(atPath: path) ? completion(true) : completion(false)
    }
    
    func deleteImage(id: String) {
        do {
            try fileManager.removeItem(atPath: fetchImageURLString(id: id))
        } catch {
            print(error.localizedDescription)
        }
    }
}
