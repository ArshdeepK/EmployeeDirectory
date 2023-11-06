//
//  EmployeeListViewController.swift
//  EmployeeDirectory
//
//  Created by Arshdeep on 2023-07-11.
//

import UIKit

class EmployeeListViewController: UIViewController {
    struct ViewConstants {
        static let screenTitle = Strings.employeeDirectory.localized
        static let employeeIdentifier = "EmployeeIdentifier"
        static let errorStateIdentifier = "ErrorStateIdentifier"
        static let estimatedRowHeight = 60.0
    }

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        // Register employee and error state cells
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: ViewConstants.employeeIdentifier)
        tableView.register(ErrorStateTableViewCell.self, forCellReuseIdentifier: ViewConstants.errorStateIdentifier)

        return tableView
    }()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.isHidden = false
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    private let refreshControl = UIRefreshControl()
    private var viewModel: EmployeeListViewModel

    // MARK: - Init

    init(viewModel: EmployeeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Initalize closures
        reloadTableViewClosure()
        updateLoadingClosure()
        updateRefreshingClosure()

        // Fetch all employees
        viewModel.initFetchEmployees(withListType: .all)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupConstraints()
    }
}

extension EmployeeListViewController {
    // MARK: - View Setup

    private func setupUI() {
        // Set navigation bar title
        title = ViewConstants.screenTitle

        // Setup table view
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        // Setup activity indicator to load initial list
        view.addSubview(activityIndicatorView)

        // Setup refresh control to refresh list
        refreshControl.addTarget(self, action: #selector(self.refreshEmployeeList(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    // MARK: - Constraints Setup

    private func setupConstraints() {
        // Enable auto layout for table view
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Set up constraints for table view
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // Enable auto layout for activity indicator view
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        // Set up constraints for activity indicator view
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    // MARK: - View Models Closures

    private func reloadTableViewClosure() {
        // Closure to reload table view
        viewModel.reloadTableViewClosure = { [weak self] () in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch self.viewModel.viewState {
                case .loaded:
                    // Show separator
                    self.tableView.separatorStyle = .singleLine
                case .error:
                    // Hide separator
                    self.tableView.separatorStyle = .none
                }
                self.tableView.reloadData()
            }
        }
    }

    private func updateLoadingClosure() {
        // Closure to show/hide loading indicator
        viewModel.updateLoadingClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.viewModel.isLoading {
                    // Show loader
                    self.activityIndicatorView.isHidden = true
                    self.activityIndicatorView.startAnimating()
                } else {
                    // Hide loader
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }

    private func updateRefreshingClosure() {
        // Closure to hide refresh control
        viewModel.updateRefreshingClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !self.viewModel.isRefreshing {
                    // Hide refresh control
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

    // MARK: - Actions

    @objc private func refreshEmployeeList(_ sender: AnyObject) {
        // Refresh Employee List
        viewModel.isRefreshing = true
        viewModel.refreshEmployeeList()
    }
}

extension EmployeeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.viewState {
        case .loaded:
            // Otherwise, then show employee list using EmployeeTableViewCell
            if let cell: EmployeeTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: ViewConstants.employeeIdentifier) as? EmployeeTableViewCell {
                let cellViewModel = viewModel.dataForRow(at: indexPath)
                cell.configure(with: cellViewModel)
                return cell
            }
        case .error(let message):
            // If error message found, then show the message using ErrorStateTableViewCell
            if let cell: ErrorStateTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: ViewConstants.errorStateIdentifier) as? ErrorStateTableViewCell {
                cell.configure(with: message ?? "")
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension EmployeeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewConstants.estimatedRowHeight
    }
}
