//
//  MiddleUserDetailViewController.swift
//  Pico
//
//  Created by 신희권 on 2023/09/25.
//

import UIKit

final class AboutMeViewController: UIViewController {
    private var cellInfomation: [[String]] = [["", ""]]
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    private let introLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .picoGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let introLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let aboutMeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 3
        return collectionView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        makeConstraints()
        configCollectionView()
    }
    
    // MARK: - Config
    func config(intro: String?, eduText: String?, religionText: String?, smokeText: String?, jobText: String?, drinkText: String?) {
        var allNil = true
        
        if let intro = intro {
            introLabel.text = intro
            allNil = false
        } else {
            introLabel.text = nil
            introLabel.removeFromSuperview()
            introLabelContainerView.removeFromSuperview()
        }
        
        cellInfomation.removeAll()
        
        let infoArray: [(icon: String, text: String?)] = [
            ("graduationcap.fill", eduText),
            ("hands.sparkles.fill", religionText),
            ("smoke", smokeText),
            ("building.columns.fill", jobText),
            ("wineglass.fill", drinkText)
        ]

        // nil이 아닌 항목만 필터링하고, 옵셔널 바인딩을 사용하여 값 추출
        cellInfomation = infoArray.compactMap { icon, text in
            guard let text = text else { return nil }
            allNil = false // 변수가 하나라도 nil이 아닌 값을 가지고 있으면 allNil을 false로 설정
            return [icon, text]
        }

        // 모든 변수가 nil인 경우 뷰를 숨김
        view.isHidden = allNil

        aboutMeCollectionView.reloadData()
    }
    
    private func configCollectionView() {
        aboutMeCollectionView.register(AboutMeCollectionViewCell.self, forCellWithReuseIdentifier: "aboutMeCollectionViewCell")
        aboutMeCollectionView.delegate = self
        aboutMeCollectionView.dataSource = self
        
        if let layout = aboutMeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 3
            layout.minimumLineSpacing = 3
            let itemWidth = (view.frame.width - 3 * 2) / 3
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
}

// MARK: - UI 관련
extension AboutMeViewController {
    private func addViews() {
        view.addSubview(verticalStackView)
        [introLabelContainerView, aboutMeCollectionView].forEach { verticalStackView.addArrangedSubview($0) }
        introLabelContainerView.addSubview(introLabel)
    }
    
    private func makeConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        introLabelContainerView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(50)
        }
        
        introLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10))
        }
        
//        aboutMeCollectionView.snp.makeConstraints { make in
//            make.height.greaterThanOrEqualTo(100).priority(.low)
//        }
    }
}

extension AboutMeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellInfomation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aboutMeCollectionViewCell", for: indexPath) as? AboutMeCollectionViewCell else { return UICollectionViewCell() }
            cell.config(image: cellInfomation[indexPath.row][0], title: cellInfomation[indexPath.row][1])
        return cell
    }
    
}