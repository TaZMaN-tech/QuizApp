//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Тадевос Курдоглян on 10.11.2022.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launch()

        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()

        app.terminate()
        app = nil
    }

    func testYesButton() {
        let firstPoster = app.images["Poster"]

        app.buttons["Yes"].tap()

        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]

        sleep(3)

        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testNoButton() {
        let firstPoster = app.images["Poster"]

        app.buttons["No"].tap()

        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]

        sleep(3)

        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testGameFinish() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }

        let alert = app.alerts["Game results"]

        XCTAssertTrue(app.alerts["Game results"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }

    func testAlertDismiss() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }

        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()

        sleep(3)

        let indexLabel = app.staticTexts["Index"]

        XCTAssertFalse(app.alerts["Game results"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}