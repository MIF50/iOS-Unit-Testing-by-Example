//
//  ViewControllerSnapshot.swift
//  SnapshotTests
//
//  Created by Mohamed Ibrahim on 03/03/2023.
//

import XCTest
@testable import Snapshot

final class ViewControllerSnapshotTests: XCTestCase {

    func test_viewController_snapshotWithLightAndDark() {
        let sut = makeSUT()
        
        let snapshot_light = sut.snapshot(for: .iPhone13(style: .light))
        let snapshot_dark = sut.snapshot(for: .iPhone13(style: .dark))
        
        assert(snapshot: snapshot_light, named: "ViewController_light")
        assert(snapshot: snapshot_dark, named: "ViewController_dark")
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> ViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = sb.instantiateViewController(identifier: String(describing: ViewController.self))
        
        return sut
    }

}

