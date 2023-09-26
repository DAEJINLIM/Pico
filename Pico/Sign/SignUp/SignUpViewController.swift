//
//  SignUpViewController.swift
//  Pico
//
//  Created by 최하늘 on 2023/09/25.
//

import UIKit
import SwiftUI

final class SignUpViewController: UIViewController {
    
    private var userMbti: [String] = ["", "", "", ""]
    
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .picoBetaBlue
        view.progressTintColor = .picoBlue
        view.progress = 0.142
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let notifyLabel: UILabel = {
        let label = UILabel()
        label.text = "성격유형을 선택하세요."
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.picoTitleFont
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private let mbtiFirstButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
        button.setTitleColor(.picoAlphaBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.tag = 0
        button.clipsToBounds = true
        return button
    }()
    
    private let mbtiSecondButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
        button.setTitleColor(.picoAlphaBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.tag = 1
        button.clipsToBounds = true
        return button
    }()
    
    private let mbtiThirdButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
        button.setTitleColor(.picoAlphaBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.tag = 2
        button.clipsToBounds = true
        return button
    }()
    
    private let mbtiFourthButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
        button.setTitleColor(.picoAlphaBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.tag = 3
        button.clipsToBounds = true
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = CommonButton(type: .custom)
        button.setTitle("다음", for: .normal)
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubViews()
        makeConstraints()
        configButton()
    }
    
    // MARK: - config
    private func configButton() {
        mbtiFirstButton.addTarget(self, action: #selector(tappedMbtiButton), for: .touchUpInside)
        mbtiSecondButton.addTarget(self, action: #selector(tappedMbtiButton), for: .touchUpInside)
        mbtiThirdButton.addTarget(self, action: #selector(tappedMbtiButton), for: .touchUpInside)
        mbtiFourthButton.addTarget(self, action: #selector(tappedMbtiButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
    }
    
    @objc private func tappedNextButton(_ sender: UIButton) {
        tappedButtonAnimation(sender)
//        if !userMbti.contains("") {
            let viewController = SignUpPhoneNumberViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
//        }
    }
    
    private func showMbtiModal(_ sender: UIButton) {
        let modalVC = MbtiModalViewController()
       
        if let sheet = modalVC.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom { _ in
                        return 300
                    }
                ]
            } else {
                sheet.detents = [.medium()]
            }
        }
        modalVC.delegate = self
        switch sender.tag {
        case 0:
            modalVC.firstSubTitleText = "외향형"
            modalVC.secondSubTitleText = "내향형"
            modalVC.firstTitleText = "E"
            modalVC.secondTitleText = "I"
            modalVC.num = 0
        case 1:
            modalVC.firstSubTitleText = "감각형"
            modalVC.secondSubTitleText = "직관형"
            modalVC.firstTitleText = "S"
            modalVC.secondTitleText = "N"
            modalVC.num = 1
        case 2:
            modalVC.firstSubTitleText = "사고형"
            modalVC.secondSubTitleText = "감정형"
            modalVC.firstTitleText = "T"
            modalVC.secondTitleText = "F"
            modalVC.num = 2
        case 3:
            modalVC.firstSubTitleText = "판단형"
            modalVC.secondSubTitleText = "인식형"
            modalVC.firstTitleText = "J"
            modalVC.secondTitleText = "P"
            modalVC.num = 3
        default:
            break
        }
        present(modalVC, animated: true, completion: nil)
    }
    
    @objc private func tappedMbtiButton(_ sender: UIButton) {
        tappedButtonAnimation(sender)
        showMbtiModal(sender)
    }
}

extension SignUpViewController: SignViewControllerDelegate {
    
    func choiceMbti(mbti: String, num: Int) {
        switch num {
        case 0:
            userMbti[num] = mbti
            mbtiFirstButton.setTitle(mbti, for: .normal)
        case 1:
            userMbti[num] = mbti
            mbtiSecondButton.setTitle(mbti, for: .normal)
        case 2:
            userMbti[num] = mbti
            mbtiThirdButton.setTitle(mbti, for: .normal)
        case 3:
            userMbti[num] = mbti
            mbtiFourthButton.setTitle(mbti, for: .normal)
        default:
            return
        }
    }
}

// MARK: - UI 관련
extension SignUpViewController {
    
    private func addSubViews() {
        for stackViewItem in [mbtiFirstButton, mbtiSecondButton, mbtiThirdButton, mbtiFourthButton] {
            stackView.addArrangedSubview(stackViewItem)
        }
        
        for viewItem in [ progressView, notifyLabel, stackView, nextButton] {
            view.addSubview(viewItem)
        }
    }
    
    private func makeConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(10)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(8)
        }
        
        notifyLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(50)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(notifyLabel.snp.bottom).offset(10)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(75)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(safeArea).offset(-30)
            make.height.equalTo(50)
        }
    }
}
