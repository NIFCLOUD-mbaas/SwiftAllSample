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

class UserUITest: XCTestCase {

    var app: XCUIApplication!
    
    // MARK: - Setup for UI Test
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testUserScreen() throws {
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
        
        let btnLoginEmail = app.buttons["btnLoginEmail"]
        XCTAssert(btnLoginEmail.exists)
        btnLoginEmail.tap()
        self.chekMsgExist(msg: "ログイン中のユーザー:")
        
        let btnAnonymousAuth = app.buttons["btnAnonymousAuth"]
        XCTAssert(btnAnonymousAuth.exists)
        btnAnonymousAuth.tap()
        self.chekMsgExist(msg: "匿名ユーザーでのログインに成功しました")
        
        let btnRequestAuthMail = app.buttons["btnRequestAuthMail"]
        XCTAssert(btnRequestAuthMail.exists)
        btnRequestAuthMail.tap()
        self.chekMsgExist(msg: "会員登録用メールの要求に成功しました")
        
        let btnAddMemberToRole = app.buttons["btnAddMemberToRole"]
        XCTAssert(btnAddMemberToRole.exists)
        btnAddMemberToRole.tap()
        self.chekMsgExist(msg: "保存に成功しました")
        
        let btnRemoveMemberFromRole = app.buttons["btnRemoveMemberFromRole"]
        XCTAssert(btnRemoveMemberFromRole.exists)
        btnRemoveMemberFromRole.tap()
        self.chekMsgExist(msg: "実行成功時の処理")

        let btnAddChildRole = app.buttons["btnAddChildRole"]
        XCTAssert(btnAddChildRole.exists)
        btnAddChildRole.tap()
        self.chekMsgExist(msg: "保存に成功しました")
    }
}
