//
//  UsersListViewModelTests.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//

import XCTest
@testable import RandomUsers

final class UsersListViewModelTests: XCTestCase {
    func testInitialLoadSuccess() {
        let repo = MockUsersRepository()
        let vm = UsersListViewModel(repo: repo)

        let exp = expectation(description: "didUpdate called")
        vm.didUpdate = { update in
            if case .initial = update { exp.fulfill() }
        }

        vm.loadInitial()
        waitForExpectations(timeout: 1)
        XCTAssertEqual(vm.users.count, 1)
    }

    func testFailurePath() {
        let repo = MockUsersRepository(); repo.shouldFail = true
        let vm = UsersListViewModel(repo: repo)

        let exp = expectation(description: "didFail")
        vm.didFail = { _ in exp.fulfill() }

        vm.loadInitial()
        waitForExpectations(timeout: 1)
    }

    func testPaginationAppends() {
        let repo = MockUsersRepository()
        repo.sampleUsers = User.mockList
        let vm = UsersListViewModel(repo: repo)

        let expInitial = expectation(description: "initial")
        let expAppend  = expectation(description: "append")

        var appendRange: Range<Int>?

        vm.didUpdate = { update in
            switch update {
            case .initial:
                expInitial.fulfill()
                vm.loadNext()
            case let .appended(range):
                appendRange = range
                expAppend.fulfill()
            default: break
            }
        }

        vm.loadInitial()
        wait(for: [expInitial, expAppend], timeout: 1)

        XCTAssertEqual(vm.users.count, 4)
        XCTAssertEqual(appendRange, 2..<4)
    }
}
