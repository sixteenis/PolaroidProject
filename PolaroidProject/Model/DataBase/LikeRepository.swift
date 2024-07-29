//
//  LikeRepository.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/27/24.
//
// TODO: 저장 실패할 경우 사용자에게 피드백 주기
import UIKit

import RealmSwift
import Kingfisher

final class LikeRepository {
    private var realm = try! Realm()
    static let shard = LikeRepository()
    private init() {}
    
    var completion: (() -> ())?
    
    // TODO: 이 함수 리팩토링 하기!
    func getLikeLists() -> [LikeList] {
        let data = Array(realm.objects(LikeList.self))
        return data
    }
    func getLikeList(_ id: String) -> LikeList {
        let data = realm.objects(LikeList.self).where {
            $0.imageId == id
        }
        guard let result = data.first else {return LikeList()}
        return result
    }
    
    func getImage(_ id: String) -> UIImage? {
        let image = self.loadImageToDocument(filename: id)
        return image
    }
    
    func saveLike(_ item: ImageDTO, _ color: SearchColor? = nil) {
        NetworkManager.shard.requestStatistics(id: item.imageId) { [weak self] respon in
            guard let self else { return }
            switch respon {
            case .success(let success):
                let result = LikeList(imageId: item.imageId, filterColor: color?.colorIndex,createdAt: item.createdAt, width: item.width, height: item.height, userName: item.user.name, viewsTotal: success.views.total, downloadTotal: success.downloads.total)
                try! self.realm.write {
                    self.realm.add(result)
                    self.completion?()
                }
                DispatchQueue.global().async {
                    if let url = URL(string: item.urls.small), let userURL =  URL(string: item.user.profileImage.medium){
                        self.downloadImage(from: url) { image in
                            if let image {
                                self.saveImageToDocument(image: image, filename: item.imageId)
                                print("성공!!!!!!")
                            }
                        }
                        self.downloadImage(from: userURL) { image in
                            if let image {
                                self.saveImageToDocument(image: image, filename: item.imageId + item.createdAt)
                                print("성공!")
                            }
                        }
                    }
                }
            case .failure(_):
                print("램 데이터로 전환 실패!!!!")
                self.completion?()
            }
        }
    }
    
    func toggleLike(_ item: LikeList) {
        if checklist(item.imageId) {
            let data = realm.objects(LikeList.self).where {
                $0.imageId == item.imageId
            }
            try! realm.write {
                //삭제
                self.removeImageFromDocument(filename: item.imageId)
                self.removeImageFromDocument(filename: item.imageId + item.createdAt)
                
                realm.delete(data)
                self.completion?()
            }
        }else{
            try! realm.write {
                realm.add(item)
                self.completion?()
            }
        }
        
    }
    func toggleLike(_ item: ImageDTO, color: SearchColor?, completion: @escaping (Bool) -> ()) {
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
                completion(false)
            }
        }else{
            completion(true)
            saveLike(item, color)
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
    
    func resetAll() {
        try! realm.write {
            realm.deleteAll()
            removeAllFilesInDocumentDirectory()
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
    func removeAllFilesInDocumentDirectory() {
            guard let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else { return }

            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
                for fileURL in fileURLs {
                    try FileManager.default.removeItem(at: fileURL)
                }
                print("모든 파일이 삭제.")
            } catch {
                print("전체 파일 삭제 중 오류 발생: \(error)")
            }
        }
    
}
