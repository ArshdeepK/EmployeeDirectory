//
//  EmployeeTableViewCell.swift
//  EmployeeDirectory
//
//  Created by Arshdeep on 2023-07-11.
//

import UIKit
import SDWebImage

class EmployeeTableViewCell: UITableViewCell {
    struct ViewConstants {
        static let nameFontSize = 16.0
        static let detailFontSize = 12.0
        static let photoSize = 40.0
        static let photoBorderWidth = 2.0
        static let horizontalSidePaddingConstant = 20.0
        static let verticalSidePaddingConstant = 10.0
        static let horizontalSpacingConstant = 10.0
        static let verticalSpacingConstant = 5.0
        static let contactFontSize = 10.0
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.themeColor
        label.font = UIFont.boldSystemFont(ofSize: ViewConstants.nameFontSize)
        label.numberOfLines = 0
        return label
    }()

    let bioLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.themeColor
        label.font = UIFont.systemFont(ofSize: ViewConstants.detailFontSize)
        label.numberOfLines = 0
        return label
    }()

    let teamLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.themeColor
        label.font = UIFont.systemFont(ofSize: ViewConstants.detailFontSize)
        label.numberOfLines = 0
        return label
    }()

    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = ViewConstants.photoSize / 2
        imageView.layer.borderWidth = ViewConstants.photoBorderWidth
        imageView.layer.borderColor = Colors.themeColor.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()

    private let contactStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = ViewConstants.verticalSpacingConstant
        return stackView
    }()

    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.themeColor
        label.font = UIFont.systemFont(ofSize: ViewConstants.contactFontSize)
        return label
    }()

    private let emailAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.themeColor
        label.font = UIFont.systemFont(ofSize: ViewConstants.contactFontSize)
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // View Setup
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup

    func setupUI() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bioLabel)
        contentView.addSubview(contactStackView)
        contactStackView.addArrangedSubview(phoneNumberLabel)
        contactStackView.addArrangedSubview(emailAddressLabel)
    }

    // MARK: - Constraints Setup

    func setupConstraints() {
        applyPhotoImageViewConstaints()
        applyNameLabelConstraints()
        applyBioLabelConstraints()
        applyContactStackViewConstraints()
    }

    func applyPhotoImageViewConstaints() {
        // Enable auto layout for photo image view
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        // Set up constraints for photo image view
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewConstants.horizontalSidePaddingConstant).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -ViewConstants.horizontalSpacingConstant).isActive = true
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewConstants.verticalSidePaddingConstant).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: ViewConstants.photoSize).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: ViewConstants.photoSize).isActive = true
    }

    func applyNameLabelConstraints() {
        // Enable auto layout for name label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Set up constraints for name label
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewConstants.horizontalSidePaddingConstant).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewConstants.verticalSidePaddingConstant).isActive = true
    }

    func applyBioLabelConstraints() {
        // Enable auto layout for bio label
        bioLabel.translatesAutoresizingMaskIntoConstraints = false

        // Set up constraints for name label
        bioLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0).isActive = true
        bioLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 0).isActive = true
        bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: ViewConstants.verticalSpacingConstant).isActive = true
    }

    func applyContactStackViewConstraints() {
        // Enable auto layout for name label
        contactStackView.translatesAutoresizingMaskIntoConstraints = false

        // Set up constraints for stack view
        contactStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0).isActive = true
        contactStackView.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor, constant: 0).isActive = true
        contactStackView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: ViewConstants.verticalSpacingConstant).isActive = true
        contactStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewConstants.verticalSidePaddingConstant).isActive = true
    }

    // MARK: - Configure Cell

    func configure(with cellViewModel: EmployeeCellViewModel) {
        // Set values.
        nameLabel.text = cellViewModel.fullName
        bioLabel.text = cellViewModel.bio
        phoneNumberLabel.text = cellViewModel.phone
        emailAddressLabel.text = cellViewModel.email

        let placeholderImage = #imageLiteral(resourceName: "user_icon")
        photoImageView.sd_setImage(with: URL(string: cellViewModel.photoUrl), placeholderImage: placeholderImage)
    }
}
