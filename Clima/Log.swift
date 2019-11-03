//
//  Log.swift
//  Clima
//
//  Created by Robert DeLaurentis on 11/1/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
import os.log

// target as subsystem (helps filter out System messages in console)
private let subsystem = "com.bobdel.Clima-iOS13"

struct Log {
    
    // create a logs for this app.
    static let general = OSLog(subsystem: subsystem, category: "general")
    static let networking = OSLog(subsystem: subsystem, category: "networking")

}

