//
//  LikeRepository.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/27/24.
//
import UIKit

import RealmSwift
import Kingfisher

final class LikeRepository {
    private var realm = try! Realm()
    static let shard = LikeRepository()
    private init() {}
    func getLikeList() -> [LikeList] {
        let data = Array(realm.objects(LikeList.self))
        return data
    }
    func getImage(_ id: String) -> UIImage? {
        let image = self.loadImageToDocument(filename: id)
        return image
        
    
    }
    func toggleLike(_ item: ImageDTO) {
        //false이면 좋아요 안눌린거임! -> 추가해야죠?
        //true이면 좋아요 눌렸던거 -> 지워줘야죠?
        if checklist(item.imageId) {
            let data = realm.objects(LikeList.self).where {
                $0.imageId == item.imageId
            }
            try! realm.write {
                //삭제
                removeImageFromDocument(filename: item.imageId)
                removeImageFromDocument(filename: item.imageId + item.createdAt)
                realm.delete(data)
                
            }
        }else{
            let result = LikeList(imageId: item.imageId, createdAt: item.createdAt, width: item.width, height: item.height, userName: item.user.name, userProfileImage: item.user.profileImage.medium)
            try! realm.write {
                //저장
                realm.add(result)
                if let url = URL(string: item.urls.small), let userURL =  URL(string: item.user.profileImage.medium){
                    downloadImage(from: url) { image in
                        if let image {
                            self.saveImageToDocument(image: image, filename: item.imageId)
                            print("성공!!!!!!")
                        }
                    }
                    downloadImage(from: userURL) { image in
                        if let image {
                            self.saveImageToDocument(image: image, filename: item.imageId + item.createdAt)
                            print("성공!")
                        }
                    }
                }
                
            }
        }
    }
    
    func checklist(_ id: String) -> Bool {
        let data = realm.objects(LikeList.self).where {
            $0.imageId == id
        }
        if data.isEmpty {
            return false
        }else{
            return true
        }
    }
    
}

// MARK: - 파일매니저 부분
private extension LikeRepository {
    func loadImageToDocument(filename: String) -> UIImage? {
        guard let document = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return nil}
        
        let fileURL = document.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            
            return UIImage(systemName: "star.fill")
        }
    }
    func saveImageToDocument(image: UIImage, filename: String) {
        guard let document = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return }
        let fileURL = document.appendingPathComponent("\(filename).jpg")
        guard let data = image.jpegData(compressionQuality: 0.5) else {return}
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error!!!!", error)
        }
    }
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }

        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("file remove error", error)
            }
            
        } else {
            print("file no exist")
        }
        
    }
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Image download error: \(String(describing: error))")
                    completion(nil)
                    return
                }
                let image = UIImage(data: data)
                completion(image)
            }
            task.resume()
        }
    
}
