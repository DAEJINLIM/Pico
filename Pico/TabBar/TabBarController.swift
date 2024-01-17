//
//  TabBarController.swift
//  Pico
//
//  Created by 최하늘 on 2023/09/25.
//

import UIKit
import SnapKit
import FirebaseFirestore

final class TabBarController: UITabBarController {
    
    private var previouslyClickedTap: String = "home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        addShadowToTabBar()
        UITabBar.appearance().backgroundColor = .secondarySystemBackground
        UITabBar.appearance().tintColor = .picoBlue
        NotificationService.shared.registerRemoteNotification()
        
        previousMatching()
    }
    
    private func configureTabBar() {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        let chattingViewController = UINavigationController(rootViewController: RoomTableListController())
        let likeViewController = UINavigationController(rootViewController: LikeViewController())
        let entViewController = UINavigationController(rootViewController: EntViewController())
        let mypageViewController = UINavigationController(rootViewController: MypageViewController())
        
        homeViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        chattingViewController.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "message.fill"), tag: 1)
        likeViewController.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart.fill"), tag: 2)
        entViewController.tabBarItem = UITabBarItem(title: "게임", image: UIImage(systemName: "gamecontroller.fill"), tag: 3)
        mypageViewController.tabBarItem = UITabBarItem(title: "마이", image: UIImage(systemName: "person.fill"), tag: 4)
        
        homeViewController.navigationBar.prefersLargeTitles = false
        chattingViewController.navigationBar.prefersLargeTitles = false
        likeViewController.navigationBar.prefersLargeTitles = false
        entViewController.navigationBar.prefersLargeTitles = false
        mypageViewController.navigationBar.prefersLargeTitles = false
        
        self.viewControllers = [homeViewController, chattingViewController, likeViewController, entViewController, mypageViewController]
        delegate = self
    }
    
    private func addShadowToTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor.clear
        appearance.backgroundColor = .secondarySystemBackground
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .picoBlue
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 6
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator(viewControllers: tabBarController.viewControllers)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController), selectedIndex == 0 {
            if let homeViewController = tabBarController.viewControllers?[selectedIndex] as? UINavigationController {
                if let rootViewController = homeViewController.viewControllers.first as? HomeViewController {
                    if previouslyClickedTap == "home" && rootViewController.doingReloadingHome == false {
                        rootViewController.reloadView()
                        previouslyClickedTap = "home"
                    }
                    if previouslyClickedTap != "home" {
                        previouslyClickedTap = "home"
                    }
                }
            }
        } else {
            previouslyClickedTap = "notHome"
        }
    }
}

extension TabBarController {
    /// 채팅생기기전의 매칭된 사람들
    private func previousMatching() {
        print("previousMatching")
        let chatModel = ChattingDetailViewModel()
        
        let dbRef = Firestore.firestore()
            .collection(Collections.likes.name)
            .document(UserDefaultsManager.shared.getUserData().userId)
        
        DispatchQueue.global().async {
            dbRef.getDocument { document, error in
                if error != nil { return }
                
                if let document {
                    if let datas = try? document.data(as: Like.self).sendedlikes {
                        datas.filter { $0.likeType == .matching }.forEach { likeInfo in
                            FirestoreService.shared.loadDocument(collectionId: .chatRoom, documentId: UserDefaultsManager.shared.getUserData().userId, dataType: ChatRoom.self) { result in
                                switch result {
                                case .success(let room):
                                    if let room {
                                        if !room.roomInfo.contains(where: { $0.opponentId == likeInfo.likedUserId }) {
                                            chatModel.saveChattingData(receiveUserId: likeInfo.likedUserId, message: "서로 매칭되었습니다", sendedDate: likeInfo.createdDate)
                                        }
                                    } else {
                                        chatModel.saveChattingData(receiveUserId: likeInfo.likedUserId, message: "서로 매칭되었습니다", sendedDate: likeInfo.createdDate)
                                    }
                                    
                                case .failure(let err):
                                    print("previousMatching: \(err.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
