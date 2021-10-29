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

class LoginUITest: XCTestCase {

    var app: XCUIApplication!
    let msgValidate = "未入力の項目があります"
    
    // MARK: - Setup for UI Test
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        Common.shared.setUp()
    }
    
    func testLoginScreen() throws {
        app.launch()
        allowPushNotificationsIfNeeded()
        
        // Open User screen from menu
        let leftBar: XCUIElement = app.navigationBars.buttons.element(boundBy: 0)
        if leftBar.waitForExistence(timeout: 20) {
            XCTAssert(leftBar.exists)
            leftBar.tap()
            app.tables.staticTexts["User Management"].tap()
        } else {
            XCTFail("Menu button not exit.")
        }
        
        // Move to login screen
        let btnLoginSigup = app.buttons["btnLoginSigup"]
        XCTAssert(btnLoginSigup.exists)
        btnLoginSigup.tap()
        XCTAssert(app.staticTexts["Login"].exists)
        
        // Test empty username
        let tfUsername = app.textFields["tfUsername"]
        XCTAssert(tfUsername.exists)
        tfUsername.tap()
        tfUsername.typeText("")
        let tfPassword = app.secureTextFields["tfPassword"]
        XCTAssert(tfPassword.exists)
        tfPassword.tap()
        tfPassword.typeText(PASSWORD_KEY)
        let btnLogin = app.buttons["btnLogin"]
        XCTAssert(btnLogin.exists)
        btnLogin.tap()
        XCTAssert(app.staticTexts[msgValidate].exists)

        // Test empty password
        tfUsername.tap()
        tfUsername.typeText(USERNAME_KEY)
        tfPassword.tap()
        tfPassword.typeText("")
        btnLogin.tap()
        XCTAssert(app.staticTexts[msgValidate].exists)

        // Test login fail
        tfUsername.tap()
        tfUsername.typeText("test_user_not_exist")
        tfPassword.tap()
        tfPassword.typeText(PASSWORD_KEY)
        btnLogin.tap()
        let failPredicate = NSPredicate(format: "label BEGINSWITH 'ログインに失敗しました:'")
        let lblError = app.staticTexts.element(matching: failPredicate)
        if lblError.waitForExistence(timeout: 20) {
            XCTAssert(lblError.exists)
        } else {
            XCTFail("Does not match message.")
        }
        
        // Test login successful
        Common.shared.createUserIfNotExist(userName: USERNAME_KEY, password: PASSWORD_KEY)
        tfUsername.tap()
        tfUsername.typeText(USERNAME_KEY)
        tfPassword.tap()
        tfPassword.typeText(PASSWORD_KEY)
        btnLogin.tap()
        self.chekMsgExist(msg: "ログイン中のユーザー: \(USERNAME_KEY)")
        let btnLogout = app.buttons["btnLogout"]
        if btnLogout.waitForExistence(timeout: 20) {
            XCTAssert(btnLogout.exists)
            btnLogout.tap()
        } else {
            XCTFail("Logout fail.")
        }
    }
}
