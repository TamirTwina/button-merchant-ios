/**

 ButtonMerchantTests.swift

 Copyright © 2018 Button, Inc. All rights reserved. (https://usebutton.com)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

*/

import XCTest
@testable import ButtonMerchant

class MerchantTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        ButtonMerchant._core = nil
    }
    
    func testVersion() {
        XCTAssertEqual(ButtonMerchantVersionNumber, 0.1)
    }
    
    func testConfigureApplicationId() {
        // Arrange
        let applicationId = "derp"
        let testCore = TestCore(buttonDefaults: TestButtonDefaults(userDefaults: TestUserDefaults()),
                                client: TestClient(session: TestURLSession()),
                                system: TestSystem(),
                                notificationCenter: TestNotificationCenter())

        // Act
        ButtonMerchant._core = testCore
        ButtonMerchant.configure(applicationId: applicationId)
        
        // Assert
        XCTAssertEqual(applicationId, testCore.applicationId)
    }
    
    func testCreateCoreCreatesCoreWhenCoreSetToNil() {
        ButtonMerchant._core = nil
        
        ButtonMerchant.configure(applicationId: "derp")
        
        XCTAssertTrue(ButtonMerchant._core is Core)
    }
    
    func testTrackIncomingURLInvokesCore() {
        // Arrange
        let testCore = TestCore(buttonDefaults: TestButtonDefaults(userDefaults: TestUserDefaults()),
                                client: TestClient(session: TestURLSession()),
                                system: TestSystem(),
                                notificationCenter: TestNotificationCenter())
        let expectedUrl = URL(string: "usebutton.com")!
        
        // Act
        ButtonMerchant._core = testCore
        ButtonMerchant.trackIncomingURL(expectedUrl)
        let actualUrl = testCore.testUrl
        
        // Assert
        XCTAssertEqual(expectedUrl, actualUrl)
    }
    
    func testAccessingAttributionToken() {
        // Arrange
        let testCore = TestCore(buttonDefaults: TestButtonDefaults(userDefaults: TestUserDefaults()),
                                client: TestClient(session: TestURLSession()),
                                system: TestSystem(),
                                notificationCenter: TestNotificationCenter())
        testCore.testToken = "srctok-123"
        let expectedToken = testCore.testToken
        
        // Act
        ButtonMerchant._core = testCore
        
        // Assert
        XCTAssertNotNil(ButtonMerchant.attributionToken)
        XCTAssertEqual(ButtonMerchant.attributionToken, expectedToken)
    }
    
    func testClearAllDataInvokesCore() {
        // Arrange
        let testCore = TestCore(buttonDefaults: TestButtonDefaults(userDefaults: TestUserDefaults()),
                                client: TestClient(session: TestURLSession()),
                                system: TestSystem(),
                                notificationCenter: TestNotificationCenter())

        // Act
        ButtonMerchant._core = testCore
        ButtonMerchant.clearAllData()
        
        // Assert
        XCTAssertTrue(testCore.didCallClearAllData)
    }
    
    func testHandlePostInstallURLInvokesCore() {
        // Arrange
        let testCore = TestCore(buttonDefaults: TestButtonDefaults(userDefaults: TestUserDefaults()),
                                client: TestClient(session: TestURLSession()),
                                system: TestSystem(),
                                notificationCenter: TestNotificationCenter())

        // Act
        ButtonMerchant._core = testCore
        ButtonMerchant.handlePostInstallURL { _, _  in }
        
        XCTAssertTrue(testCore.didCallFetchPostInstallURL)
    }
}