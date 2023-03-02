//
//  UITableView+XCTestCaseHelper.swift
//  TableViewTests
//
//  Created by Mohamed Ibrahim on 02/03/2023.
//

import UIKit

func numberOfRows(in tableView: UITableView,section: Int = 0) -> Int? {
    tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section)
}

func cellForRow(in tableView: UITableView,row: Int,section: Int = 0) -> UITableViewCell? {
    let indexPath = IndexPath(row: row, section: section)
    return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
}

func didSelectRow(in tableView: UITableView,row: Int, section: Int = 0) {
    let indexPath = IndexPath(row: row, section: section)
    tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
}
