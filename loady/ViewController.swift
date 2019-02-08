//
//  ViewController.swift
//  loady
//
//  Created by farshad jahanmanesh on 2/2/19.
//  Copyright © 2019 farshadJahanmanesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tempTimer1 : Timer?
    var tempTimer2 : Timer?
    var tempTimer3 : Timer?
    var tempTimer : Timer?
    var fourPhaseTempTimer : Timer?
    @IBOutlet weak var circleView : Loady?
    @IBOutlet weak var allInOneview : Loady?
    @IBOutlet weak var uberLikeView : Loady?
    @IBOutlet weak var fillingView : Loady?
    @IBOutlet weak var indicatorViewLike : Loady?
    @IBOutlet weak var appstore : Loady?
    @IBOutlet weak var fourPhases : Loady?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start and stop animating on user touch
        self.circleView?.addTarget(self, action: #selector(animateView(_:)), for: .touchUpInside)
        self.allInOneview?.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.uberLikeView?.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.fillingView?.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.indicatorViewLike?.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.appstore?.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        self.fourPhases?.addTarget(self, action:#selector(animateView(_:)), for:.touchUpInside)
        
        self.appstore?.pauseImage =  UIImage(named: "pause")
        
        // sets animation type
        self.allInOneview?.animationType = LoadingType.all.rawValue
        
        // sets the color that fills the button after percent value changed
        self.allInOneview?.backgroundFillColor = .purple
        
        // sets the indicator color above the button
        self.allInOneview?.loadingColor = .yellow
        
        // sets the indictore view color (dark or light) inside the button
        self.allInOneview?.indicatorViewStyle = .light
        
        // some animations have image inside (e.g appstore pause image), this line sets that image
        self.allInOneview?.pauseImage = UIImage(named: "pause")
        
        // starts loading animation
        self.allInOneview?.startLoading()
        
        // some animations have filling background, this sets the filling percent, number is something between 0 to 100
        self.allInOneview?.fillTheButton(with: 10)
        
        // some animations have circular loading , this sets the percents of circle that are completed, number is something between 0 to 100
        self.allInOneview?.fillTheCircleStrokeLoadingWith(percent: 25)
        self.fourPhases?.loadingColor = UIColor(red:0.38, green:0.66, blue:0.09, alpha:1.0)
        self.fourPhases?.fourPhases = (
            // normal phase
            LoadyAnimationOptions.FourPhase.Phases.normal(title: "Lock", image: UIImage(named: "unlocked"), background: UIColor(red:0.00, green:0.49, blue:0.90, alpha:1.0)),
            
            // loading phase
            LoadyAnimationOptions.FourPhase.Phases.loading(title: "Waiting...", image: UIImage(named: ""), background: UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)),
            
            // success phase
            LoadyAnimationOptions.FourPhase.Phases.success(title: "Activated", image: UIImage(named: "locked"), background: UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)),
            
            // error phase
            LoadyAnimationOptions.FourPhase.Phases.error(title: "Error", image: UIImage(named: "unlocked"), background: UIColor(red:0.64, green:0.00, blue:0.15, alpha:1.0))
        )
    }
    
    @IBAction func animateView(_ sender : UIButton){
        // check for nil
        guard let button = sender as? Loady else {
            return
        }
        
        // start animating based on button animation style type
        button.startLoading(loadingType: LoadingType(rawValue: button.animationType) ?? .none)
        var percent : CGFloat = 0
        switch button._animationType {
        case .backgroundHighlighter:
            self.tempTimer1?.invalidate()
            self.tempTimer1 = nil
            self.tempTimer1 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                percent += 10;
                button.fillTheButton(with: percent)
                button.fillTheCircleStrokeLoadingWith(percent: percent)
            }
            self.tempTimer1?.fire()
        case .circleAndTick:
            self.tempTimer2?.invalidate()
            self.tempTimer2 = nil
            self.tempTimer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                percent += 10;
                button.fillTheCircleStrokeLoadingWith(percent: percent)
            }
            self.tempTimer2?.fire()
        case .appstore:
            self.tempTimer3?.invalidate()
            self.tempTimer3 = nil
            self.tempTimer3 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                percent += 10;
                button.fillTheCircleStrokeLoadingWith(percent: percent)
            }
            self.tempTimer3?.fire()
        case .all:
            self.tempTimer?.invalidate()
            self.tempTimer = nil
            self.tempTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){(t) in
                percent += 10;
                button.fillTheButton(with: percent)
                button.fillTheCircleStrokeLoadingWith(percent: percent)
            }
            self.tempTimer?.fire()
        case .fourPhases:
            self.fourPhaseTempTimer?.invalidate()
            self.fourPhaseTempTimer = nil
            self.fourPhaseTempTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true){(t) in
                guard let nextPhase = self.fourPhases?._fourPhasesNextPhase else {
                    if Int.random(in: Range.init(0...1)) == 0 {
                        self.fourPhases?.errorPhase()
                    }else{
                        self.fourPhases?.successPhase()
                    }
                    return
                }
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                self.fourPhaseTempTimer?.fire()
            }
        default:
            break;
        }
    }
    
    
}

