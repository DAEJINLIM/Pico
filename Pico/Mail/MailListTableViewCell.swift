//
//  MailListTableViewCell.swift
//  Pico
//
//  Created by 양성혜 on 2023/09/25.
//

import UIKit

final class MailListTableViewCell: UITableViewCell {
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "chu")
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private let infoStackView = UIStackView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.picoSubTitleFont
        label.textColor = .picoFontBlack
        return label
    }()
    
    private let message: UILabel = {
        let label = UILabel()
        label.font = UIFont.picoDescriptionFont
        label.textColor = .picoFontBlack
        return label
    }()
    
    private let mbtiLabel = UILabel()
    
    private let dateStackView = UIStackView()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.picoDescriptionFont
        label.textColor = .picoFontBlack
        return label
    }()
    
    private let newLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.picoDescriptionFont
        label.textColor = .red
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        makeConstraints()
        getData()
        
    }
    
    func addViews() {
        
        [userImage, infoStackView, dateStackView].forEach {
            contentView.addSubview($0)
        }
        
        [nameLabel, message, mbtiLabel].forEach {
            infoStackView.addSubview($0)
        }
        
        [dateLabel, newLabel].forEach {
            dateStackView.addSubview($0)
        }
        
    }
    
    func makeConstraints() {
        
        userImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70.0)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(userImage).offset(10)
            make.leading.equalTo(userImage.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(infoStackView)
        }
        
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.leading.equalTo(nameLabel.snp.trailing).offset(5)
            make.trailing.equalTo(infoStackView.snp.trailing)
        }
        
        message.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(infoStackView.snp.trailing)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.leading.equalTo(infoStackView.snp.trailing)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(dateStackView)
        }
        
        newLabel.snp.makeConstraints { make in
            make.top.equalTo(message.snp.top)
            make.leading.trailing.equalTo(dateStackView)
        }
    }
    
    func getData() {
        nameLabel.text = "강아지는왈왈, 29"
        mbtiLabel.text = "istp"
        message.text = "하이용"
        dateLabel.text = "9/24"
        newLabel.text = "new"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
