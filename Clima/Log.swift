//
//  Log.swift
//  Clima
//
//  Created by Robert DeLaurentis on 11/1/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import os.log

struct Log {

    // create a log for this app.
    static var general = OSLog(
        subsystem: "com.bobdel.Clima-iOS13",
        category: "general")

}

