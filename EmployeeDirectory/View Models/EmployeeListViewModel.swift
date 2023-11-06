//
//  EmployeeListViewModel.swift
//  EmployeeDirectory
//
//  Created by Arshdeep on 2023-07-11.
//

import Foundation
import UIKit

enum EmployeeListType {
    case all
    case malformed
    case empty
}

enum ViewState {
    case loaded
    case error(String?)
}

class EmployeeListViewModel {
    var employees: [Employee] = []
    private var groups: [String] = []
    private var employeeCellViewModels: [EmployeeCellViewModel] = []
    private var groupedEmployeeCellViewModels: [GroupedEmployeeCellViewModel] = []
    private var refreshCount = 0

    var isLoading: Bool = false {
        didSet {
            updateLoadingClosure?()
        }
    }

    var isRefreshing: Bool = false {
        didSet {
            updateRefreshingClosure?()
        }
    }

    var viewState: ViewState = .loaded {
        didSet {
            reloadTableViewClosure?()
        }
    }

    var reloadTableViewClosure: (() -> Void)?
    var updateLoadingClosure: (() -> Void)?
    var updateRefreshingClosure: (() -> Void)?

    private let client: NetworkClient

    // MARK: - Init

    init(client: NetworkClient = NetworkClient()) {
        self.client = client
    }

    // MARK: - Reset List

    private func resetEmployeeList() {
        employees = []
        employeeCellViewModels = []
        groupedEmployeeCellViewModels = []
        groups = []
        reloadTableViewClosure?()
    }

    // MARK: - Refresh List

    func refreshEmployeeList() {
        employees = []
        viewState = ViewState.error(nil)
        refreshCount += 1

        // Refetch employee list to refresh table view
        switch refreshCount % 3 {
        case 0:
            fetchEmployees(withListType: .all)
        case 1:
            fetchEmployees(withListType: .malformed)
        case 2:
            fetchEmployees(withListType: .empty)
        default:
            break
        }
    }

    // MARK: - Fetch List

    func initFetchEmployees(withListType listType: EmployeeListType) {
        // Check if internet available
        if !NetworkMonitor.shared.isReachable {
            // Stop refreshing if internet not available
            if isRefreshing {
                isRefreshing = false
            }

            // Show error message if internet not available
            viewState = ViewState.error(Strings.noNetworkConnection.localized)
        } else {
            if refreshCount == 0 {
                // Show center screen loader if not refreshing
                isLoading = true
            }
            fetchEmployees(withListType: listType)
        }
    }

    private func fetchEmployees(withListType listType: EmployeeListType) {
        client.fetchEmployees(withListType: listType) { result in
            self.hideLoaders()
            switch result {
            case let .success(employeeResponse):
                self.employees = employeeResponse.employees ?? []
                self.handleSuccessResponse()
            case let .failure(error):
                self.viewState = ViewState.error(error.localizedDescription)
            }
        }
    }

    // MARK: - Hide Loaders on Response

    private func hideLoaders() {
        // Hide center screen loader
        if isLoading {
            isLoading = false
        }
        // Hide refresh control
        if isRefreshing {
            isRefreshing = false
        }
    }

    // MARK: - Handle List Success Response

    private func handleSuccessResponse() {
        if employees.count == 0 {
            viewState = ViewState.error(Strings.noEmployeesFound.localized)
        } else if isAnyEmployeeMalformed() {
            resetEmployeeList()
            viewState = ViewState.error(Strings.malformedEmployeesFound.localized)
        } else {
            viewState = ViewState.loaded
            createEmployeesList()
        }
    }

    // MARK: - Check if any employee malformed

    func isAnyEmployeeMalformed() -> Bool {
        let count = employees.filter { employee in
             return employee.uuid == nil || employee.fullName == nil || employee.team == nil || employee.emailAddress == nil
        }.count
        return count > 0
    }

    // MARK: - Create employees list

    func createEmployeesList() {
        // Fill employee cell view model array from employee data fetched from API.
        employeeCellViewModels = employees.map({ employee in
                        .init(
                            fullName: employee.fullName ?? "",
                            photoUrl: employee.photoUrl ?? "",
                            bio: employee.biography ?? "",
                            team: employee.team ?? "",
                            phone: Strings.contactNumber.localized + ": " + (employee.phoneNumber ?? ""),
                            email: employee.emailAddress ?? ""
                        )
                })

        // Create grouped employee cell view models.
        groupedEmployeeCellViewModels =
                Dictionary(grouping: employeeCellViewModels, by: { $0.team })
                    .sorted(by: { $0.key < $1.key })
                    .map { GroupedEmployeeCellViewModel(group: $0.key, employees: $0.value) }

        // Reload list.
        reloadTableViewClosure?()
    }

    // MARK: - Employee List Datasource & Delegate

    func numberOfSections() -> Int {
        switch viewState {
        case .loaded:
            return groupedEmployeeCellViewModels.count
        case .error:
            return 1
        }
    }

    func numberOfRows(in section: Int) -> Int {
        switch viewState {
        case .loaded:
            return groupedEmployeeCellViewModels[section].employees.count
        case .error:
            return 1
        }
    }

    func dataForRow(at indexPath: IndexPath) -> EmployeeCellViewModel {
        let employeeCellViewModel = groupedEmployeeCellViewModels[indexPath.section].employees[indexPath.row]
        return employeeCellViewModel
    }

    func titleForHeader(in section: Int) -> String {
        switch viewState {
        case .loaded:
            return groupedEmployeeCellViewModels[section].group
        case .error:
            return ""
        }
    }
}

struct EmployeeCellViewModel {
    let fullName: String
    let photoUrl: String
    let bio: String
    let team: String
    let phone: String
    let email: String
}

struct GroupedEmployeeCellViewModel {
    let group: String
    let employees: [EmployeeCellViewModel]
}
