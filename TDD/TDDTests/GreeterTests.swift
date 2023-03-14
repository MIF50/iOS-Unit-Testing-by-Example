//
//  GreeterTests.swift
//  TDDTests
//
//  Created by Mohamed Ibrahim on 13/03/2023.
//

import XCTest

struct Greeter {
    
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func greet(time: Date) -> String {
        let hello = greet(for: time)
        if name.isEmpty {
            return "\(hello)."
        } else {
            return "\(hello), \(name)."
        }
    }
    
    private func greet(for time: Date) -> String {
        let theHour = hour(for: time)
        for (index,greetingTime) in greetingTimes.enumerated() {
            if greetingTime.from <= theHour && theHour < greetingTimes[index + 1].from {
                return greetingTime.greeting
            }
        }
        return ""
    }
    
    private let greetingTimes: [(from: Int,greeting: String)]  = [
        (0,"Good evening"),
        (5,"Good morning"),
        (12,"Good afternoon"),
        (17,"Good evening"),
        (24,"SENTINEL")
    ]
    
    private func hour(for time: Date) -> Int {
        let component = Calendar.current.dateComponents([.hour], from: time)
        return component.hour ?? 0
    }
}

final class GreeterWithoutNameTests: XCTestCase {
    
    func test_greet_with500Am_shouldSayGoodMorning() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 11, minute: 59))
        
        XCTAssertEqual(result, "Good morning.")
    }

    func test_greet_with1159Am_shouldSayGoodMorning() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 11, minute: 59))
        
        XCTAssertEqual(result, "Good morning.")
    }
    
    func test_greet_with800Am_shouldSayGoodMorning() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 8, minute: 00))
        
        XCTAssertEqual(result, "Good morning.")
    }
    
    func test_greet_with1200Pm_shouldSayGoodAfternoon() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 12, minute: 00))
        
        XCTAssertEqual(result, "Good afternoon.")
    }
    
    func test_greet_with459Pm_shouldSayGoodAfternoon() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 16, minute: 59))
        
        XCTAssertEqual(result, "Good afternoon.")
    }
    
    func test_greet_with200Pm_shouldSayGoodAfternoon() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 14, minute: 00))
        
        XCTAssertEqual(result, "Good afternoon.")
    }
    
    func test_greet_with500Pm_shouldSayGoodEvening() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 17, minute: 00))
        
        XCTAssertEqual(result, "Good evening.")
    }
    
    func test_greet_with1159Pm_shouldSayGoodEvening() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 23, minute: 59))
        
        XCTAssertEqual(result, "Good evening.")
    }
    
    func test_greet_with800Pm_shouldSayGoodEvening() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 20, minute: 00))
        
        XCTAssertEqual(result, "Good evening.")
    }
    
    func test_greet_with2400Pm_shouldSayGoodEvening() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 24, minute: 00))
        
        XCTAssertEqual(result, "Good evening.")
    }
    
    func test_greet_with459Am_shouldSayGoodEvening() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 4, minute: 59))
        
        XCTAssertEqual(result, "Good evening.")
    }
    
    func test_greet_with200Am_shouldSayGoodEvening() {
        let sut = makeSUT()
        
        let result = sut.greet(time: date(hour: 2, minute: 00))
        
        XCTAssertEqual(result, "Good evening.")
    }
    
    //MARK: - Helper
    
    private func makeSUT() -> Greeter {
        let sut = Greeter(name: "")
        return sut
    }

    
    private func date(hour: Int,minute: Int) -> Date {
        let component = DateComponents.init(calendar: Calendar.current,hour: hour,minute: minute)
        return component.date!
    }
}

final class GreeterWithNameTests: XCTestCase {
    
    func test_greetMorning_withMohamed_shouldSayGoodmorningMohamed() {
        let sut = makeSUT(name: "Mohamed")
        
        let result = sut.greet(time: date(hour: 8, minute: 00))
        
        XCTAssertEqual(result, "Good morning, Mohamed.")
    }
    
    func test_greetAfternoon_withAhmed_shouldSayGoodafternoonAhmed() {
        let sut = makeSUT(name: "Ahmed")
        
        let result = sut.greet(time: date(hour: 15, minute: 00))
        
        XCTAssertEqual(result, "Good afternoon, Ahmed.")
    }
    
    //MARK: - Helper
    
    private func makeSUT(name: String = "") -> Greeter {
        let sut = Greeter(name: name)
        return sut
    }

    
    private func date(hour: Int,minute: Int) -> Date {
        let component = DateComponents.init(calendar: Calendar.current,hour: hour,minute: minute)
        return component.date!
    }
}

