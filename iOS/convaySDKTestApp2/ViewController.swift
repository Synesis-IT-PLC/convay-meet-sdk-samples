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
        convayMeetView = ConvayMeetView()
        convayMeetView?.delegate = self
        
        
//        let endCallButton = UIButton(type: .system)
//        endCallButton.setTitle("End Call", for: .normal)
//        endCallButton.backgroundColor = .red
//        endCallButton.setTitleColor(.white, for: .normal)
//        endCallButton.layer.cornerRadius = 8
//        endCallButton.addTarget(self, action: #selector(endCallTapped), for: .touchUpInside)
//        endCallButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(endCallButton)
//        NSLayoutConstraint.activate([
//            endCallButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            endCallButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            endCallButton.widthAnchor.constraint(equalToConstant: 200),
//            endCallButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//        

//        let options = ConvayMeetConferenceOptions.fromBuilder { builder in
//            builder.setFeatureFlag("", withValue: <#T##Any#>)
//            builder.serverURL = URL(string: "https://synesis.convay.com")
//            builder.room = "0000019b-b157-9baf-0000-0000000babf7"
//
//            builder.token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzeW5lc2lzLmNvbnZheS5jb20iLCJpYXQiOjE3NjgyMDY4NjcsImV4cCI6MTc2ODI1MDA2NywiaXNzIjoiQTgxRkYiLCJuYmYiOjE3NjgyMDY4NjcsInJvb20iOiIwMDAwMDE5Yi1iMTU3LTliYWYtMDAwMC0wMDAwMDAwYmFiZjciLCJjb250ZXh0Ijp7ImZlYXR1cmVzIjp7ImRlc2t0b3BhcHAiOiJ0cnVlIiwibGl2ZXN0cmVhbWluZyI6InRydWUiLCJ0cmFuc2NyaXB0aW9uIjoidHJ1ZSIsImNoYXQiOiJ0cnVlIiwicmVjb3JkaW5nIjoidHJ1ZSJ9LCJjb25maWciOnsiTUlDX09GRiI6dHJ1ZSwiQ0FNRVJBX09GRiI6dHJ1ZSwiSVNfSE9TVCI6dHJ1ZSwiTUFYX1BBUlRJQ0lQQU5UIjoxMjAwLCJNRUVUSU5HX0RVUkFUSU9OIjo4MCwiV0FJVElOR19ST09NIjpmYWxzZSwiQUxMX1BDUl9KT0lOIjpmYWxzZSwiSE9TVF9SRUNPUkRfU1RBUlRVUCI6ZmFsc2UsIkRJU19DSEFUIjpmYWxzZSwiTE9DS19NSU4iOnsic2xlY3RlZCI6ZmFsc2V9LCJBTExfUENSX1VOTVVURSI6dHJ1ZSwiSE9TVF9TQ1JfU0hSIjpmYWxzZSwiQUxMT1dfUkVOQU1FIjp0cnVlLCJFTlRSWV9MRUFWRV9TT1VORCI6dHJ1ZSwiUEFSVElDSVBBTlRfTE9HIjp0cnVlLCJESVNfUkNUTl9XQk5SIjp0cnVlLCJESVNfQ0hBVF9XQk5SIjp0cnVlLCJQTUkiOnRydWUsIkFVVE9fR0VOX0lEIjpmYWxzZSwiUEFTU1dPUkQiOnRydWUsIkFVVEhfVVNFUiI6ZmFsc2UsIkRPTUFJTl9BTExPVyI6ZmFsc2UsIkFMTE9XX0NPVU5UUlkiOmZhbHNlLCJJTlZJVEVfVVJMIjoiaHR0cHM6Ly9jb252YXkuY29tL20vai85MTIzOTk0NTQwMzgvcmFpeWFuP3B3ZD05MWQ0Mjc5YWM1M2RkZmQ5YjdlNjJiNzQ0MjQ3ZTBhZCIsIk1FRVRJTkdfUk9MRSI6Imhvc3QiLCJTRUNSRVQiOiI2MzQ5NTkiLCJBVVRPX0NMT1NFIjpmYWxzZSwiTUVFVElOR19JRCI6IjkxMjM5OTQ1NDAzOCIsIlVOSVFVRV9UUkFDS0lOR19JRCI6IjgyNDAzODQ2NDk2NiIsIlBNSV9OTyI6IjkxMjM5OTQ1NDAzOCIsIk1FRVRJTkdfU1RBUlQiOjE3NjgyMDY4NjU3MTN9LCJ1c2VyIjp7ImJhY2tncm91bmRVcmwiOiIiLCJwYXJ0aWNpcGFudExvZ0lkIjoiNDZkOGY0ZWUtYzI1ZS00MTFhLTg3MDItOWZjZDk1YjIyNjljIiwiYXZhdGFyIjoiaHR0cHM6Ly9jb252YXkuY29tL3NlcnZpY2VzL2ZpbGUtc2VydmljZS9maWxlLyIsInZpZGVvRGV2aWNlIjoiIiwicm9vbU5hbWUiOiIwMDAwMDE5Yi1iMTU3LTliYWYtMDAwMC0wMDAwMDAwYmFiZjciLCJtaWNyb3Bob25lRGV2aWNlIjoiIiwibmFtZSI6IlJhaXlhbiBTaGFyaWYiLCJpZCI6IjdjMGU1NWE5LWM0ZTYtNDk2Yi1hNWJhLTIzYjlmNjgxYjZiMSIsImNhdGVnb3J5IjoiaG9zdCIsImxhbmciOiJlbmdsaXNoIiwiZW1haWwiOiJyYWl5YW4uc2hhcmlmQHN5bmVzaXNpdC5pbmZvIiwiYmFja2dyb3VuZElkIjoiIiwic3BlYWtlckRldmljZSI6IiJ9fSwiYXVkIjoiaml0c2kifQ.3rYwCeknJclLiwuXXYMAYIjG059xkIrTbm-gFNPLUBI"
//            
//            builder.setFeatureFlag("welcomepage.enabled", withBoolean: false)
//            builder.setFeatureFlag("sounds.enabled", withBoolean: false)
//        }
        
        // Join the conference
//        conferenceView.join(options)
        
        // Do any additional setup after loading the view.
    }
    
    
//
//    @objc func endCallTapped() {
//        // End the call
//        conferenceView.hangUp()
//        print("End Tapped from convayMeeet")
//        // The delegate method conferenceTerminated will be called
//    }
    
//    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
//        view = UIView()
//        conferenceView.delegate = nil
//        print("Conference terminated: \(String(describing: data))")
//    }
    
    
    /*
     https://synesis.convay.com/0000019b-d0fb-b3cd-0000-000000068c9c?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzeW5lc2lzLmNvbnZheS5jb20iLCJpYXQiOjE3Njg3Mzc3MTUsImV4cCI6MTc2ODc4MDkxNSwiaXNzIjoiQTgxRkYiLCJuYmYiOjE3Njg3Mzc3MTUsInJvb20iOiIwMDAwMDE5Yi1kMGZiLWIzY2QtMDAwMC0wMDAwMDAwNjhjOWMiLCJjb250ZXh0Ijp7ImZlYXR1cmVzIjp7ImRlc2t0b3BhcHAiOiJ0cnVlIiwibGl2ZXN0cmVhbWluZyI6InRydWUiLCJ0cmFuc2NyaXB0aW9uIjoidHJ1ZSIsImNoYXQiOiJ0cnVlIiwicmVjb3JkaW5nIjoidHJ1ZSJ9LCJjb25maWciOnsiTUlDX09GRiI6dHJ1ZSwiQ0FNRVJBX09GRiI6dHJ1ZSwiSVNfSE9TVCI6dHJ1ZSwiTUFYX1BBUlRJQ0lQQU5UIjoxMjAwLCJNRUVUSU5HX0RVUkFUSU9OIjo4MCwiV0FJVElOR19ST09NIjpmYWxzZSwiQUxMX1BDUl9KT0lOIjpmYWxzZSwiSE9TVF9SRUNPUkRfU1RBUlRVUCI6ZmFsc2UsIkRJU19DSEFUIjpmYWxzZSwiTE9DS19NSU4iOnsic2xlY3RlZCI6ZmFsc2V9LCJBTExfUENSX1VOTVVURSI6dHJ1ZSwiSE9TVF9TQ1JfU0hSIjpmYWxzZSwiQUxMT1dfUkVOQU1FIjp0cnVlLCJFTlRSWV9MRUFWRV9TT1VORCI6dHJ1ZSwiUEFSVElDSVBBTlRfTE9HIjp0cnVlLCJESVNfUkNUTl9XQk5SIjp0cnVlLCJESVNfQ0hBVF9XQk5SIjp0cnVlLCJQTUkiOnRydWUsIkFVVE9fR0VOX0lEIjpmYWxzZSwiUEFTU1dPUkQiOnRydWUsIkFVVEhfVVNFUiI6ZmFsc2UsIkRPTUFJTl9BTExPVyI6ZmFsc2UsIkFMTE9XX0NPVU5UUlkiOmZhbHNlLCJJTlZJVEVfVVJMIjoiaHR0cHM6Ly9jb252YXkuY29tL20vai85MTIzOTk0NTQwMzgvcmFpeWFuP3B3ZD05MWQ0Mjc5YWM1M2RkZmQ5YjdlNjJiNzQ0MjQ3ZTBhZCIsIk1FRVRJTkdfUk9MRSI6Imhvc3QiLCJTRUNSRVQiOiI2MzQ5NTkiLCJBVVRPX0NMT1NFIjpmYWxzZSwiTUVFVElOR19JRCI6IjkxMjM5OTQ1NDAzOCIsIlVOSVFVRV9UUkFDS0lOR19JRCI6IjU0MTY2Mjk1Njk3NiIsIlBNSV9OTyI6IjkxMjM5OTQ1NDAzOCIsIk1FRVRJTkdfU1RBUlQiOjE3Njg3Mzc3MTM2MDB9LCJ1c2VyIjp7ImJhY2tncm91bmRVcmwiOiIiLCJwYXJ0aWNpcGFudExvZ0lkIjoiZjZkY2QwNTAtOGU2OC00OTkyLTlkMmEtODIyMTk3MDRiNzNkIiwiYXZhdGFyIjoiaHR0cHM6Ly9jb252YXkuY29tL3NlcnZpY2VzL2ZpbGUtc2VydmljZS9maWxlLyIsInZpZGVvRGV2aWNlIjoiIiwicm9vbU5hbWUiOiIwMDAwMDE5Yi1kMGZiLWIzY2QtMDAwMC0wMDAwMDAwNjhjOWMiLCJtaWNyb3Bob25lRGV2aWNlIjoiIiwibmFtZSI6IlJhaXlhbiBTaGFyaWYiLCJpZCI6IjdjMGU1NWE5LWM0ZTYtNDk2Yi1hNWJhLTIzYjlmNjgxYjZiMSIsImNhdGVnb3J5IjoiaG9zdCIsImxhbmciOiJlbmdsaXNoIiwiZW1haWwiOiJyYWl5YW4uc2hhcmlmQHN5bmVzaXNpdC5pbmZvIiwiYmFja2dyb3VuZElkIjoiIiwic3BlYWtlckRldmljZSI6IiJ9fSwiYXVkIjoiaml0c2kifQ.l6OX9ZCoR0zS0uUqecjOpzlmM7ywlPrtAaTVTdK8vNo
     */
//
    @IBAction func startButtonTapped(_ sender: Any) {
        
        let convayMeetView = ConvayMeetView()
        convayMeetView.delegate = self
        self.convayMeetView = convayMeetView
        
        let options = ConvayMeetConferenceOptions.fromBuilder { builder in
            builder.setFeatureFlag("startpage.enabled", withValue: true)
            
            builder.token = "eyJhbGciOiJIUzUxMiJ9.eyJhY2Nlc3NfdG9rZW4iOiJzeXRfY21GcGVXRnVMbk5vWVhKcFptRjBjM2x1WlhOcGMybDBMbWx1Wm04X3hLbW1hUVRZallPYnBGakJ3SUFNXzBQNlB3SCIsImlzX29ubHlfc3NvIjpmYWxzZSwic3ViIjoiN2MwZTU1YTktYzRlNi00OTZiLWE1YmEtMjNiOWY2ODFiNmIxIiwiZGF0YSI6eyJmZWF0dXJlcyI6WyJSZWNvcmRpbmciLCJEZXNrdG9wQXBwIiwiVHJhbnNjcmlwdGlvbiIsIkNoYXQiLCJMaXZlc3RyZWFtaW5nIl0sInVzZXJfZW1haWwiOiJyYWl5YW4uc2hhcmlmQHN5bmVzaXNpdC5pbmZvIiwibGljZW5zZV9uYW1lIjoiSG9zdCIsInJvbGUiOiJPd25lciIsIm9yZ2FuaXphdGlvbl9pZCI6ImMyZGQ5OTE2LWNlNjgtMTFlZC05YTRjLTAyNDJhYzEzMDAwOCIsIm9yZ2FuaXphdGlvbl9uYW1lIjoiU3luZXNpcyBJVCBQTEMiLCJJRCI6IjdjMGU1NWE5LWM0ZTYtNDk2Yi1hNWJhLTIzYjlmNjgxYjZiMSIsInZhbml0eV91cmwiOm51bGwsImRpc3BsYXlfbmFtZSI6IlJhaXlhbiBTaGFyaWYiLCJvcmdhbml6YXRpb25fbG9nbyI6bnVsbCwiaXNfY21fdXNlciI6dHJ1ZX0sImRldmljZV9pZCI6IlNCRkNMQlJVUlEiLCJ1c2VyX2lkIjoiQHJhaXlhbi5zaGFyaWZhdHN5bmVzaXNpdC5pbmZvOm1hdHJpeC5jb252YXkuY29tIiwid2VsbF9rbm93biI6bnVsbCwicGVybWlzc2lvbiI6eyJ2aWV3X2dyb3VwIjp0cnVlLCJhZGRfcm9sZSI6dHJ1ZSwidmlld19vcmdhbml6YXRpb24iOnRydWUsImVkaXRfdXNlciI6dHJ1ZSwiZWRpdF9vcmdhbml6YXRpb24iOnRydWUsImVkaXRfZ3JvdXAiOnRydWUsImRlbGV0ZV9yb2xlIjp0cnVlLCJ2aWV3X3JvbGUiOnRydWUsImVkaXRfcm9sZSI6dHJ1ZSwidmlld19tZWV0aW5nIjp0cnVlLCJhZGRfZ3JvdXAiOnRydWUsInZpZXdfZGFzaGJvYXJkIjp0cnVlLCJ2aWV3X3VzZXIiOnRydWUsImRlbGV0ZV91c2VyIjp0cnVlLCJhZGRfdXNlciI6dHJ1ZSwiZGVsZXRlX2dyb3VwIjp0cnVlfSwiZXhwIjoxNzY4NzM5MDA1LCJpYXQiOjE3Njg3MzgxMDUsImhvbWVfc2VydmVyIjoibWF0cml4LmNvbnZheS5jb20ifQ.p3w7lI2sPXiWeQsn4koLASxbwXA4BQKscQccgty9wgm-EMlvtmnxKrA8BIP1lC0QW4hUpATJQ0zWZVU13jW3LA"
        }
        
        convayMeetView.join(options)
        pipViewCoordinator = PiPViewCoordinator(withView: convayMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: view)

                // animate in
        convayMeetView.alpha = 0
        pipViewCoordinator?.show()
    }
    
    @IBAction func joinCallButtonTapped(_ sender: Any) {
        let convayMeetView = ConvayMeetView()
        convayMeetView.delegate = self
        self.convayMeetView = convayMeetView
        let options = ConvayMeetConferenceOptions.fromBuilder { builder in
            
            builder.setFeatureFlag("joinpage.enabled", withValue: true)
            builder.meetingLink = "https://convay.com/m/j/912399454038/raiyan?pwd=91d4279ac53ddfd9b7e62b744247e0ad"
            
            
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
//    func conferenceJoined(_ data: [AnyHashable : Any]!) {
//        print("Conference joined")
//    }
//    
//    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
//        print("Conference ended")
//        // Dismiss the view controller when call ends
//        conferenceView.leave()
////        view = UIView()
//        dismiss(animated: true)
//    }
//    
//    func readyToClose() {
//        print("SDK ready to close")
//        dismiss(animated: true)
//    }
}

