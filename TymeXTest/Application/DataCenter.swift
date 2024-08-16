//
//  DataCenter.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import UIKit

class DataCenter {
    static var shared = DataCenter()
    
    // Check app status is opened or launching
    var hasLoadedApp: Bool = false
    // Equal true when app has requested push noti authorization
    var hasRequestedNotiPermission: Bool = false
    // Save data of push noti when app open after quit
    var userDataNoti: [AnyHashable : Any]?
    // Save the last error code when show pop up (top alert view of pop up)
    var lastErrorCodePopup: Int = -1
}
