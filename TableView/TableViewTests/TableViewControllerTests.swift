//
//  TableViewControllerTests.swift
//  TableViewTests
//
//  Created by Mohamed Ibrahim on 02/03/2023.
//

import XCTest
@testable import TableView

final class TableViewControllerTests: XCTestCase {

    func test_tableViewDelegates_shouldBeConnected() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.tableView.dataSource,"dataSource")
        XCTAssertNotNil(sut.tableView.delegate,"delegate")
    }
    
    func test_numberOfRows_shouldBe3() {
        let sut = makeSUT()
                
        XCTAssertEqual(numberOfRows(in: sut.tableView), 3)
    }
    
    func test_cellForRowAt_withRow0_shouldSetLabelToOne() {
        let sut = makeSUT()
        
        let cell = cellForRow(in: sut.tableView, row: 0)
        
        XCTAssertEqual(cell?.textLabel?.text, "One")
    }
    
    func test_cellForRowAt_withRow1_shouldSetLabelToTwo() {
        let sut = makeSUT()
        
        let cell = cellForRow(in: sut.tableView, row: 1)
        
        XCTAssertEqual(cell?.textLabel?.text, "Two")
    }
    
    func test_cellForRowAt_withRow2_shouldSetLabelToThree() {
        let sut = makeSUT()
        
        let cell = cellForRow(in: sut.tableView, row: 2)
        
        XCTAssertEqual(cell?.textLabel?.text, "Three")
    }
    
    func test_didSelectRow_withRow1() {
        let sut = makeSUT()
        
        didSelectRow(in: sut.tableView, row: 1)
        
        // Normally, assert something
    }
    
    //MARK: - Helper
    
    private func makeSUT() -> TableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: TableViewController = storyboard.instantiateViewController(identifier: String(describing: TableViewController.self))
        sut.loadViewIfNeeded()
        
        return sut
    }

}

