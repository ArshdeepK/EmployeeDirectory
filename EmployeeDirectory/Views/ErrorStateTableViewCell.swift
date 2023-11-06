//
//  ErrorStateTableViewCell.swift
//  EmployeeDirectory
//
//  Created by Arshdeep on 2023-07-12.
//

import UIKit

class ErrorStateTableViewCell: UITableViewCell {
    struct ViewConstants {
        static let paddingConstant = 10.0
    }

    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.themeColor
        label.textAlignment = .center
        label.numberOfLines = 0
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
        contentView.addSubview(errorLabel)

        // Remove cell background color
        backgroundColor = .clear
    }

    // MARK: - Constraints Setup

    func setupConstraints() {
        // Enable auto layout for photo image view
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        // Set up constraints for photo image view
        errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewConstants.paddingConstant).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewConstants.paddingConstant).isActive = true
        errorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewConstants.paddingConstant).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewConstants.paddingConstant).isActive = true
    }

    // MARK: - Configure Cell

    func configure(with text: String) {
        // Set values.
        errorLabel.text = text
    }
}
