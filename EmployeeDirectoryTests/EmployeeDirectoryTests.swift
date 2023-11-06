//
//  EmployeeDirectoryTests.swift
//  EmployeeDirectoryTests
//
//  Created by Arshdeep on 2023-07-11.
//

import XCTest
@testable import EmployeeDirectory

private class MockNetworkClient: NetworkClient {}
private class MockNetworkRequest: NetworkRequest {}

final class EmployeeDirectoryTests: XCTestCase {
    private var mockNetworkClient: MockNetworkClient?
    private var mockNetworkRequest = MockNetworkRequest()

    override func setUpWithError() throws {
        mockNetworkClient = MockNetworkClient(request: mockNetworkRequest)
    }

    override func tearDownWithError() throws {
        mockNetworkClient = nil
    }

    func testEmployeeListViewModel_hasEmployees() {
        let networkClient = MockNetworkClient()
        let viewModel = EmployeeListViewModel(client: networkClient)
        XCTAssertFalse(viewModel.numberOfSections() > 0)
        viewModel.employees = [.init(uuid: "abc",
                                     fullName: "Test Test",
                                     photoUrl: nil,
                                     biography: "Test Bio",
                                     team: "Test Team",
                                     phoneNumber: "8888888888",
                                     emailAddress: "test@test.com")]
        viewModel.createEmployeesList()
        XCTAssertTrue(viewModel.numberOfSections() > 0)
    }

    func testEmployeeListViewModel_hasMalformedEmployees() {
        let networkClient = MockNetworkClient()
        let viewModel = EmployeeListViewModel(client: networkClient)
        viewModel.employees = [.init(uuid: nil,
                                     fullName: "Test Test",
                                     photoUrl: nil,
                                     biography: "Test Bio",
                                     team: "Test Team",
                                     phoneNumber: "8888888888",
                                     emailAddress: "test@test.com")]
        XCTAssertTrue(viewModel.isAnyEmployeeMalformed())
    }

    func testEmployeeListViewModel_hasNoEmployees() {
        let networkClient = MockNetworkClient()
        let viewModel = EmployeeListViewModel(client: networkClient)
        viewModel.createEmployeesList()
        XCTAssertTrue(viewModel.numberOfSections() == 0)
    }

    func testEmployeeListPerformance() throws {
        self.measure {
            let networkClient = MockNetworkClient()
            let viewModel = EmployeeListViewModel(client: networkClient)
            var employees: [Employee] = []
            for count in 1...1000 {
                let employee = Employee(uuid: "\(count)",
                                        fullName: "Test Test \(count)",
                                        photoUrl: nil,
                                        biography: "Test Bio \(count)",
                                        team: "Test Team \(count)",
                                        phoneNumber: "8888888888",
                                        emailAddress: "test@test\(count).com")
                employees.append(employee)
            }
            viewModel.createEmployeesList()
        }
    }
}
