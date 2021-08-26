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

class AppleSignInUITest: XCTestCase {

    var app: XCUIApplication!
    
    // MARK: - Setup for UI Test
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testAppleSignInScreen() throws {
        app.launch()
        allowPushNotificationsIfNeeded()
        
        // Open AppleSignIn screen from menu
        let leftBar: XCUIElement = app.navigationBars.buttons.element(boundBy: 0)
        if leftBar.waitForExistence(timeout: 20) {
            XCTAssert(leftBar.exists)
            leftBar.tap()
            app.tables.staticTexts["Sign in with Apple"].tap()
        } else {
            XCTFail("Menu button not exit.")
        }
        
        let btnLinkWithApple = app.buttons["btnLinkWithApple"]
        XCTAssert(btnLinkWithApple.exists)
        
        let btnUnLinkWithApple = app.buttons["btnUnLinkWithApple"]
        XCTAssert(btnUnLinkWithApple.exists)
    }
}
