//
//  HomeViewModel.swift
//  Pico
//
//  Created by 임대진 on 10/5/23.
//
import RxSwift
import RxRelay
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class HomeViewModel {
    
    var otherUsers = BehaviorRelay<[User]>(value: [])
    var myLikes = BehaviorRelay<[Like.LikeInfo]>(value: [])
    static var filterGender: [GenderType] = []
    static var filterMbti: [MBTIType] = []
    static var filterAgeMin: Int = 19
    static var filterAgeMax: Int = 61
    static var filterDistance: Int = 501
    private let loginUser = UserDefaultsManager.shared.getUserData()
    private let disposeBag = DisposeBag()
    
    init() {
        loadFilterDefault()
        loadUsers()
        loadMyLikesRx()
    }
    
    private func loadUsers() {
        var gender: [GenderType] = []
        
        if HomeViewModel.filterGender.isEmpty {
            gender = GenderType.allCases
        } else {
            gender = HomeViewModel.filterGender
        }
        
        DispatchQueue.global().async {
            let dbRef = Firestore.firestore()
            let query = dbRef.collection("users")
                .whereField("id", isNotEqualTo: self.loginUser.userId)
                .whereField("gender", in: gender.map { $0.rawValue })
            
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print(error)
                } else {
                    var users = [User]()
                    for document in querySnapshot!.documents {
                        if let user = try? document.data(as: User.self) {
                            users.append(user)
                        }
                    }
                    self.otherUsers.accept(users)
                    
                }
            }
        }
    }
    private func loadMyLikesRx() {
        FirestoreService.shared.loadDocumentRx(collectionId: .likes, documentId: UserDefaultsManager.shared.getUserData().userId, dataType: Like.self)
            .map { like -> [Like.LikeInfo] in
                if let like = like {
                    return like.sendedlikes ?? []
                }
                return []
            }
            .bind(to: myLikes)
            .disposed(by: disposeBag)
    }
    
    private func loadFilterDefault() {
        if let filterAgeMin = UserDefaults.standard.object(forKey: UserDefaultsManager.Key.filterAgeMin.rawValue) as? Int {
            HomeViewModel.filterAgeMin = filterAgeMin
        }

        if let filterAgeMax = UserDefaults.standard.object(forKey: UserDefaultsManager.Key.filterAgeMax.rawValue) as? Int {
            HomeViewModel.filterAgeMax = filterAgeMax
        }

        if let filterDistance = UserDefaults.standard.object(forKey: UserDefaultsManager.Key.filterDistance.rawValue) as? Int {
            HomeViewModel.filterDistance = filterDistance
        }
        
        if let genderData = UserDefaults.standard.object(forKey: UserDefaultsManager.Key.filterGender.rawValue) as? Data,
           let filterGender = try? JSONDecoder().decode([GenderType].self, from: genderData) {
            HomeViewModel.filterGender = filterGender
        }

        if let mbtiData = UserDefaults.standard.object(forKey: UserDefaultsManager.Key.filterMbti.rawValue) as? Data,
           let filterMbti = try? JSONDecoder().decode([MBTIType].self, from: mbtiData) {
            HomeViewModel.filterMbti = filterMbti
        }
    }
}
