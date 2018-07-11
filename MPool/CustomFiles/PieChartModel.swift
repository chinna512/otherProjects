//
//  PieChartModel.swift
//  EXampleChart
//
//  Created by Chinnababu on 6/15/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class PieChartModel: NSObject {
    var title : String = ""
    var keysArray:NSMutableArray =  []
    var valuesArray:NSMutableArray =  []
    var lastSelectedSlice:Int?
    var colorsArray:NSMutableArray = []
    var searchResultsString:String = ""
    var displaySearchBar:Bool = false
}
