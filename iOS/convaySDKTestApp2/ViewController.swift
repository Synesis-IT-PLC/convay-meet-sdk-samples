//
//  ViewController.swift
//  convaySDKTestApp2
//
//  Created by Raiyan Sharif on 12/1/26.
//

import UIKit
import ConvayMeetSDK

class ViewController: UIViewController {
    @IBOutlet weak var tokenTextViewArea: UITextView!
    
//    var conferenceView: ConvayMeetView!
    
    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    fileprivate var convayMeetView: ConvayMeetView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        // Clean up any existing view first
        cleanUp()
        
        let convayMeetView = ConvayMeetView()
        convayMeetView.delegate = self
        self.convayMeetView = convayMeetView
        let authToken = "Auth_Token"
        let trimmedToken = authToken.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedToken.isEmpty {
            print("ConvaySDK: Start Meeting - Token is empty, cannot launch")
            return
        }
        let userInfo = ConvayMeetUserInfo()
        userInfo.displayName = "Mr Mac"
        
        let options = ConvayMeetConferenceOptions.fromBuilder { builder in
            // Required
            builder.token = trimmedToken
            builder.setFeatureFlag("startpage.enabled", withBoolean: true)
            builder.setFeatureFlag("startpage.enabled", withBoolean: true)

                // Optional
                builder.userInfo = userInfo
                builder.setAudioMuted(false)
                builder.setVideoMuted( false)
            builder.setFeatureFlag("chat.enabled",  withBoolean: true)
            builder.setFeatureFlag("invite.enabled", withBoolean: true)
            builder.setFeatureFlag("recording.enabled",  withBoolean: false)
            builder.setFeatureFlag("pip.enabled", withBoolean: true)

            // Hide self-view by default
            // builder.setConfigOverride("disableSelfView", withValue: true)
        }
        
        
        convayMeetView.join(options)
        pipViewCoordinator = PiPViewCoordinator(withView: convayMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: view)

                // animate in
        convayMeetView.alpha = 0
        pipViewCoordinator?.show()
        
        // Ensure video is enabled after a short delay to allow SDK to initialize
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Video should already be enabled via options, but this ensures it stays enabled
        }
    }
    
    @IBAction func joinCallButtonTapped(_ sender: Any) {
        // Clean up any existing view first
        cleanUp()
        
        let convayMeetView = ConvayMeetView()
        convayMeetView.delegate = self
        self.convayMeetView = convayMeetView
        let meetingLink = "Meeting_Link"
        let trimmedLink = meetingLink.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedLink.isEmpty {
            print("ConvaySDK: Join Meeting - Meeting link is empty, cannot launch")
            // Or using os_log / Logger if your project uses that instead:
            // os_log("Join Meeting - Meeting link is empty, cannot launch", log: OSLog(subsystem: "ConvaySDK", category: "default"), type: .error)
            return
        }

        print("ConvaySDK: Join Meeting - Setting meeting link: \(trimmedLink)")

        // Create user info with display name
        let userInfo = ConvayMeetUserInfo()
        userInfo.displayName = "Mr Mac"
        
        let options = ConvayMeetConferenceOptions.fromBuilder { builder in
                builder.meetingLink = trimmedLink
                builder.setFeatureFlag("joinpage.enabled", withBoolean: true)

                // User info (optional)
//                builder.userInfo = userInfo

                // Feature flags
                builder.setFeatureFlag("prejoinpage.enabled", withBoolean: false)
                builder.setFeatureFlag("unique-participant-join.enabled", withBoolean: true)
                builder.setFeatureFlag("chat.enabled", withBoolean: true)
                // builder.setFeatureFlag("title-bar.enabled", withBoolean: false)
                builder.setFeatureFlag("participants.enabled", withBoolean: false)
                builder.setFeatureFlag("active-speaker-name.enabled", withBoolean: false)
                builder.setFeatureFlag("tile-view.enabled", withBoolean: false)
                builder.setFeatureFlag("notifications.enabled", withBoolean: false) // optional
                builder.setFeatureFlag("filmstrip.enabled", withBoolean: false) // optional
                builder.setFeatureFlag("overflow-menu.enabled", withBoolean: false) // optional
                builder.setFeatureFlag("audio-mute.enabled", withBoolean: false) // optional
                builder.setFeatureFlag("video-mute.enabled", withBoolean: false) // optional
                builder.setFeatureFlag("ios.screensharing.enabled", withBoolean: false) // optional (iOS equivalent of android.screensharing.enabled)
                // builder.setFeatureFlag("screenshare.landscape.enabled", withBoolean: true) // optional

                // Hide self-view by default
                builder.setConfigOverride("disableSelfView", withValue: true)
        }
        convayMeetView.join(options)
        pipViewCoordinator = PiPViewCoordinator(withView: convayMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: view)

                // animate in
        convayMeetView.alpha = 0
        pipViewCoordinator?.show()
        
    }
    fileprivate func cleanUp() {
        convayMeetView?.removeFromSuperview()
        convayMeetView = nil
            pipViewCoordinator = nil
        }
    
    

}

extension ViewController: ConvayMeetViewDelegate {
    func ready(toClose data: [AnyHashable : Any]!) {
            self.pipViewCoordinator?.hide() { _ in
                self.cleanUp()
            }
        }
        
        func enterPicture(inPicture data: [AnyHashable : Any]!) {
            self.pipViewCoordinator?.enterPictureInPicture()
        }
    
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        print("✅ Conference joined - Data: \(String(describing: data))")
        
        // Log all available data to understand track state
        if let dataDict = data {
            for (key, value) in dataDict {
                print("📊 Conference data - Key: \(key), Value: \(value)")
            }
        }
        
        // Check video track state after joining
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("🔍 Checking video track state after conference join...")
        }
    }

}

