//
//  NotificationViewModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


enum NotificationType : Int,CaseIterable {
    case notice
    case event
    case manual
    case story
}

class NotificationViewModel: UIView {



}

struct EventViewModel {
    
    let event: EventListModel
    
    var eventStatusLabel: String {
        
        if event.statusEvent == "Y" {
            return "진행중"
        }
        return "마감"
    }
    
    var eventStatusColor: UIColor {
        
        if event.statusEvent == "Y" {
            return .blue300
        }
        return .black400
    }
    
    
}
