//
//  UserCell.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//

import UIKit

final class UserCell: UITableViewCell {
    static let reuseId = "UserCell"

    private let avatar = UIImageView()
    private let nameLbl = UILabel()
    private let emailLbl = UILabel()
    private var imgTask: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        avatar.layer.cornerRadius = 20
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false

        nameLbl.font = .preferredFont(forTextStyle: .body)
        emailLbl.font = .preferredFont(forTextStyle: .caption1)
        emailLbl.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [nameLbl, emailLbl])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(avatar)
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalToConstant: 40),

            stack.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
        imgTask?.cancel()
    }

    func configure(with user: User) {
        nameLbl.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        emailLbl.text = user.email
        
        if let url = URL(string: user.picture.thumbnail) {
            ImageLoader.shared.load(url) { [weak self] img in
                DispatchQueue.main.async {
                    self?.avatar.image = img
                }
            }
        }
    }
    
}
