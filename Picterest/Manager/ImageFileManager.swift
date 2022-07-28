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
    
    func saveImage(id: String, data: Data, completion: @escaping (Bool) -> Void) {
        guard let image = UIImage(data: data) else {
            completion(false)
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            completion(false)
            return
        }
        
        let fileURL = directoryURL.appendingPathComponent(id).appendingPathExtension("png")
        
        do {
            try imageData.write(to: fileURL)
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func fetchImage(id: String) -> UIImage? {
        let fileURL = directoryURL.appendingPathComponent(id).appendingPathExtension("png")
        return UIImage(contentsOfFile: fileURL.path)
    }
}
