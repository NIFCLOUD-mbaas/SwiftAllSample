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

class SignUpUITest: XCTestCase {

    var app: XCUIApplication!
    let msgValidate = "未入力の項目があります"
    let msgValiConfirm = "Passwordが一致しません"
    
    // MARK: - Setup for UI Test
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        Common.shared.setUp()
    }
    
    func testSignUpScreen() throws {
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
        
        // Move to Sigup screen
        let btnMoveToSignUp = app.buttons["btnMoveToSignUp"]
        XCTAssert(btnMoveToSignUp.exists)
        btnMoveToSignUp.tap()
        XCTAssert(app.staticTexts["Sign Up"].exists)
        
        // Test empty username
        let tfUsername = app.textFields["tfUsername"]
        XCTAssert(tfUsername.exists)
        tfUsername.tap()
        tfUsername.typeText("")
        let tfPassword = app.secureTextFields["tfPassword"]
        XCTAssert(tfPassword.exists)
        tfPassword.tap()
        tfPassword.typeText(PASSWORD_KEY)
        let tfConfirm = app.secureTextFields["tfConfirm"]
        XCTAssert(tfConfirm.exists)
        tfConfirm.tap()
        tfConfirm.typeText(PASSWORD_KEY)
        let btnSignUp = app.buttons["btnSignUp"]
        XCTAssert(btnSignUp.exists)
        btnSignUp.tap()
        XCTAssert(app.staticTexts[msgValidate].exists)
        
        // Test empty password
        tfUsername.tap()
        tfUsername.typeText(USERNAME_KEY)
        tfPassword.tap()
        tfPassword.typeText("")
        tfConfirm.tap()
        tfConfirm.typeText(PASSWORD_KEY)
        btnSignUp.tap()
        XCTAssert(app.staticTexts[msgValidate].exists)
        
        // Test empty confirm password
        tfUsername.tap()
        tfUsername.typeText(USERNAME_KEY)
        tfPassword.tap()
        tfPassword.typeText(PASSWORD_KEY)
        tfConfirm.tap()
        tfConfirm.typeText("")
        btnSignUp.tap()
        XCTAssert(app.staticTexts[msgValidate].exists)
        
        // Test password and confirm password do not match
        tfUsername.tap()
        tfUsername.typeText(USERNAME_KEY)
        tfPassword.tap()
        tfPassword.typeText(PASSWORD_KEY)
        tfConfirm.tap()
        tfConfirm.typeText("456789")
        btnSignUp.tap()
        XCTAssert(app.staticTexts[msgValiConfirm].exists)
        
        // Test sign-up successful
        Common.shared.deleteUserIfExist(userName: USERNAME_KEY, password: PASSWORD_KEY)
        tfUsername.tap()
        tfUsername.typeText(USERNAME_KEY)
        tfPassword.tap()
        tfPassword.typeText(PASSWORD_KEY)
        tfConfirm.tap()
        tfConfirm.typeText(PASSWORD_KEY)
        btnSignUp.tap()
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
