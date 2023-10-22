//
//  PictureManager.swift
//  Pico
//
//  Created by LJh on 10/16/23.
//
import UIKit
import Photos

final class PictureManager {
    // !!!: 멘토링 질문
    // 앱에서 설정으로 이동으로 설정에서 앱의 사진 권한을 변경하면 Message from debugger: Terminated due to signal 9 이라는 메시지와 함께 팅겨버림 .. 아무리 찾아도 나오지 않아요 ㅠㅠㅠㅠ
    func unauthorized(in viewController: UIViewController) {
        DispatchQueue.main.async {
            viewController.showCustomAlert(alertType: .canCancel, titleText: "사진 라이브러리 권한 필요", messageText: "사진을 선택하려면 사진 라이브러리 권한이 필요합니다. 설정에서 권한을 변경할 수 있습니다.", confirmButtonText: "설정으로 이동", comfrimAction: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })
        }
    }

    func requestPhotoLibraryAccess(in viewController: UIViewController) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .authorized:
                break
            case .denied, .restricted, .notDetermined, .limited:
                self.unauthorized(in: viewController)
            @unknown default:
                self.unauthorized(in: viewController)
            }
        }
    }
}
