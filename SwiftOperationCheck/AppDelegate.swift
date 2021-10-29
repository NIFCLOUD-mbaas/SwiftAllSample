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

import UIKit
import NCMB
import IQKeyboardManagerSwift
import UserNotifications
import AuthenticationServices

// Login with email
public let EMAIL_KEY                       = "test@gmail.com"
public let PASSWORD_KEY                    = "123456"

// Request authentication email
public let REQUEST_AUTHENTICATION_MAIL_KEY = "request.authentication.mail@gmail.com"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //********** APIキーの設定 **********
    let applicationkey = "YOUR_NCMB_APPLICATION_KEY"
    let clientkey      = "YOUR_NCMB_CLIENT_KEY"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // SDKの初期化
        NCMB.initialize(applicationKey: applicationkey, clientKey: clientkey)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                break // The Apple ID credential is valid.
            case .revoked, .notFound: break
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                DispatchQueue.main.async {
//                    self.window?.rootViewController?.showLoginViewController()
//                }
            default:
                break
            }
        }


        // keyboard support
        IQKeyboardManager.shared.enable = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if((error) != nil) {
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        // リッチプッシュ通知を表示させる
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
                NCMBPush.handleRichPush(userInfo: notification)
        }
        NCMBAnalytics.trackAppOpenedWithLaunchOptions(launchOptions: launchOptions)
        
        return true
    }
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        let installation : NCMBInstallation = NCMBInstallation.currentInstallation

        //Device Tokenを設定
        installation.setDeviceTokenFromData(data: deviceToken)
        installation["region"] = "Asia"
        //端末情報をデータストアに登録
        installation.saveInBackground(callback: { result in
            switch result {
            case .success:
                //端末情報の登録が成功した場合の処理
                print("保存に成功しました")
            case let .failure(error):
                //端末情報の登録が失敗した場合の処理
                let errorCode = (error as NSError).code
                if (errorCode == 409001) {
                    //失敗した原因がdeviceTokenの重複だった場合
                    self.updateExistInstallation(installation: installation)
                } else {
                    //deviceTokenの重複以外のエラーが返ってきた場合
                }
                return
            }
        })
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let data = userInfo["name"] as? NSDictionary {
            print("Data: \(data)")
        }
        
        if let notiData = userInfo as? [String : AnyObject] {
            // リッチプッシュ通知を表示させる
            NCMBPush.handleRichPush(userInfo: notiData)
        }
        if (application.applicationState != UIApplication.State.active) {
            // アプリがすでに起動していた場合
            NCMBAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo: userInfo as! [String : AnyObject])
        }
    }
    
    func updateExistInstallation(installation: NCMBInstallation) -> Void {
        var installationQuery : NCMBQuery<NCMBInstallation> = NCMBInstallation.query
        installationQuery.where(field: "deviceToken", equalTo: installation.deviceToken!)
        installationQuery.findInBackground(callback: {results in
            switch results {
            case let .success(data):
                //上書き保存する
                let searchDevice:NCMBInstallation = data.first!
                installation.objectId = searchDevice.objectId
                installation.saveInBackground(callback: { result in
                    switch result {
                    case .success:
                        //端末情報更新に成功したときの処理
                        break
                    case .failure:
                        //端末情報更新に失敗したときの処理
                        break
                    }
                })
            case .failure:
                //端末情報検索に失敗した場合の処理
                break
            }
        })
    }
    
    
}

