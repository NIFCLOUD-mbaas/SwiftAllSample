/*
 Copyright 2017-2018 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import XCTest

class PushUITest: XCTestCase {

    var app: XCUIApplication!
    
    // MARK: - Setup for UI Test
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testSendPush() throws {
        app.launch()
        allowPushNotificationsIfNeeded()
        
        // Open Push screen from menu
        let leftBar: XCUIElement = app.navigationBars.buttons.element(boundBy: 0)
        if leftBar.waitForExistence(timeout: 20) {
            XCTAssert(leftBar.exists)
            leftBar.tap()
            app.tables.staticTexts["Push Notification"].tap()
        } else {
            XCTFail("Menu button not exit.")
        }
        
        let btnSendPush = app.buttons["btnSendPush"]
        XCTAssert(btnSendPush.exists)
        btnSendPush.tap()
        self.chekMsgExist(msg: "登録に成功しました。プッシュID:")
        
        
        // TODO: 2021-10-22 Comment out code test receive push
        /*let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.activate()
        let notification = springboard.otherElements["Notification"].descendants(matching: .any)["NotificationShortLookView"]
        XCTAssertEqual(waiterResultWithExpectation(notification), XCTWaiter.Result.completed)
        notification.tap()*/
    }
    
    func testSendRichPush() throws {
        app.launch()
        allowPushNotificationsIfNeeded()
        
        // Open Push screen from menu
        let leftBar: XCUIElement = app.navigationBars.buttons.element(boundBy: 0)
        if leftBar.waitForExistence(timeout: 20) {
            XCTAssert(leftBar.exists)
            leftBar.tap()
            app.tables.staticTexts["Push Notification"].tap()
        } else {
            XCTFail("Menu button not exit.")
        }
        
        let btnRichPush = app.buttons["btnRichPush"]
        XCTAssert(btnRichPush.exists)
        btnRichPush.tap()
        self.chekMsgExist(msg: "登録に成功しました。プッシュID:")
        
        // TODO: 2021-10-22 Comment out code test receive push
        /*let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.activate()
        let notification = springboard.otherElements["Notification"].descendants(matching: .any)["NotificationShortLookView"]
        XCTAssertEqual(waiterResultWithExpectation(notification), XCTWaiter.Result.completed)
        notification.tap()*/
    }
}
