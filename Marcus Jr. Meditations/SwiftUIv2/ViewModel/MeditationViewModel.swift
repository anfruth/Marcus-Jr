//
//  MeditationViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/1/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SwiftUI

final class MeditationViewModel: EmotionRouter, ObservableObject {
    
    struct AlertInfo {
        let title: String
        let message: String
        let acceptActionOption: String
        let declineActionOption: String?
        ///  Bool is true if  settings url should be opened.
        let acceptAction: (() -> Bool)?
        let declineAction: (() -> Void)?
    }
    
    @Published var dateSettingAllowed: Bool = false
    @Published var showAlert: Bool = false
    
    private(set) var alertInfo: AlertInfo?
    
    private let meditation: Meditation
    let emotionDescription: EmotionDescription
    
    private let notDeterminedTitle = "Not_determined_title"
    private let notDeterminedTitleComment = "not determined alert title"
    private let notDeterminedMessage = "Not_determined_message"
    private let notDeterminedMessageComment = "not determined alert message"
    private let notDeterminedOptionTitle = "Not_determined_option_title"
    private let notDeterminedOptionTitleComment = "title of option for not determined alert"
    
    private let deniedTitleComment = "denied alert title"
    private let deniedMessage = "Denied_message"
    private let deniedMessageComment = "Denied alert messsage"
    private let deniedOptionTitleComment = "title of option for denied alert"
    
    private let systemPlaceholder = "System_placeholder"
    private let systemPlaceholderComment = "system placeholder for hidden previews"
    
    private let permanentTitle = "Permanent_title"
    private let permanentTitleComment = "permanent alert title"
    private let permanentMessage = "Permanent_message"
    private let permanentMessageComment = "permanent alert message"
    
    private let skipTitle = "Skip"
    private let settingsTitle = "Settings"
    
    init(meditation: Meditation, emotionDescription: EmotionDescription) {
        self.meditation = meditation
        self.emotionDescription = emotionDescription
        
        super.init(emotion: emotionDescription.emotion ?? "")
    }
    
    var commentaryAvailable: Bool {
        return commentary != (meditation.localizedId ?? "") + "_commentary"
    }
    
    var actionAvailable: Bool {
        action != (meditation.localizedId ?? "") + "_action"
    }
    
    var enchiridionChapter: String {
        return NSLocalizedString((meditation.localizedId ?? "") + "_title", comment: "Enchiridion Chapter")
    }
    
    var quotation: String {
        return "\"" + NSLocalizedString((meditation.localizedId ?? "") + "_quotation", comment: "Enchiridion Quotation") + "\""
    }
    
    var commentary: String {
        return NSLocalizedString((meditation.localizedId ?? "") + "_commentary", comment: "Meditation Commentary")
    }
    
    var action: String {
        return NSLocalizedString((meditation.localizedId ?? "") + "_action", comment: "Meditation Action")
    }
    
    
    func getNotificationPermissionIfNeeded() async {
        let userNotificationSettings = await UNUserNotificationCenter.current().notificationSettings()
        await MainActor.run {
            dateSettingAllowed = userNotificationSettings.authorizationStatus == .authorized
            if !dateSettingAllowed {
                presentCorrectAlert(authorizationStatus: userNotificationSettings.authorizationStatus)
            }
        }
    }
    
    func meditationDatesView(isShowingMeditationList: Binding<Bool>) -> MeditationDatesView {
        let vm = MeditationDatesViewModel(dates: [], meditation: meditation, selectedDate: .now,
                                          notificationManager: LocalNotificationManager(), emotionDescription: emotionDescription)
        return MeditationDatesView(viewModel: vm, isShowingMeditationList: isShowingMeditationList)
    }
    
    func isRoutedToMeditation(from meditationId: String) -> Bool {
        return meditation.localizedId == meditationId
    }
    
    private func presentCorrectAlert(authorizationStatus: UNAuthorizationStatus) {
        
        if authorizationStatus == .notDetermined {
            alertInfo = AlertInfo(title: NSLocalizedString(notDeterminedTitle, comment: notDeterminedTitleComment),
                                  message: NSLocalizedString(notDeterminedMessage, comment: notDeterminedMessageComment),
                                  acceptActionOption: NSLocalizedString(notDeterminedOptionTitle, comment: notDeterminedOptionTitleComment),
                                  declineActionOption: skipTitle,
                                  acceptAction:
                                    {
                                        NotificationsSetup.sharedInstance.giveSystemPromptForNotifications { [weak self] granted in
                                            guard let self else { return }
                                            if granted {
                                                self.alertInfo = self.permanentNotificationAlertInfo()
                                            }
                                            
                                            self.showAlert = true
                                        }
                
                                        return false
                                    },
                                  declineAction: nil
            )
            
        } else if authorizationStatus == .denied {
            alertInfo = AlertInfo(title: NSLocalizedString(notDeterminedTitle, comment: deniedTitleComment),
                                  message: NSLocalizedString(deniedMessage, comment: deniedMessageComment),
                                  acceptActionOption: NSLocalizedString(notDeterminedOptionTitle, comment: deniedOptionTitleComment),
                                  declineActionOption: skipTitle,
                                  acceptAction:
                                    {
                                        return true
                                    },
                                  declineAction: nil
            )
        }
        
        showAlert = true
    }
    
    private func permanentNotificationAlertInfo() -> AlertInfo {
        return AlertInfo(title: NSLocalizedString(permanentTitle, comment: permanentTitleComment),
                          message: NSLocalizedString(permanentMessage, comment: permanentMessageComment),
                          acceptActionOption: settingsTitle,
                          declineActionOption: skipTitle,
                          acceptAction:
                            {
                                self.dateSettingAllowed = true
                                return true
                            },
                          declineAction: { self.dateSettingAllowed = true }
                    )
    }
    
    
    
}
