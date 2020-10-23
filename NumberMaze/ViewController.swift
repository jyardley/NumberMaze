//
//  ViewController.swift
//  NumberMaze
//
//  Created by Yardley, Jeff [GCB-OT NE] on 11/30/18.
//  Copyright © 2018 Yardley, Jeff [GCB-OT NE]. All rights reserved.
//

//Sound effects obtained from SoundBible.com


import UIKit
import AVFoundation

/* Interface builder extensions */
//From: https://spin.atomicobject.com/2017/07/18/swift-interface-builder/
extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}





/* Color Definitions */
//From: https://stackoverflow.com/questions/37055755/computing-complementary-triadic-tetradic-and-analagous-colors
extension UIColor {
    
    var complement: UIColor {
        return self.withHueOffset(offset: 0.5)
    }
    
    var splitComplement0: UIColor {
        return self.withHueOffset(offset: 150 / 360)
    }
    
    var splitComplement1: UIColor {
        return self.withHueOffset(offset: 210 / 360)
    }
    
    var triadic0: UIColor {
        return self.withHueOffset(offset: 120 / 360)
    }
    
    var triadic1: UIColor {
        return self.withHueOffset(offset: 240 / 360)
    }
    
    var tetradic0: UIColor {
        return self.withHueOffset(offset: 0.25)
    }
    
    var tetradic1: UIColor {
        return self.complement
    }
    
    var tetradic2: UIColor {
        return self.withHueOffset(offset: 0.75)
    }
    
    var analagous0: UIColor {
        return self.withHueOffset(offset: -1 / 12)
    }
    
    var analagous1: UIColor {
        return self.withHueOffset(offset: 1 / 12)
    }
    
    func withHueOffset(offset: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: fmod(h + offset, 1), saturation: s, brightness: b, alpha: a)
    }
    
    /**
     * Returns random color
     * EXAMPLE: self.backgroundColor = UIColor.random
     */
    // From: https://stackoverflow.com/questions/29779128/how-to-make-a-random-color-with-swift
    static var random: UIColor {
        let r:CGFloat  = .random(in: 0.6 ... 1)
        let g:CGFloat  = .random(in: 0.6 ... 1)
        let b:CGFloat  = .random(in: 0.6 ... 1)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
}




func FadeInLabel(label: UILabel){
    UILabel.animate(withDuration: 1) {
        label.alpha = 1
    }
}




class ViewController: UIViewController {

    @IBOutlet weak var goalNumber: UILabel!
    @IBOutlet weak var upNumber: UILabel!
    @IBOutlet weak var rightNumber: UILabel!
    @IBOutlet weak var leftNumber: UILabel!
    @IBOutlet weak var downNumber: UILabel!
    @IBOutlet weak var centerNumber: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var upLeftNumber: UILabel!
    @IBOutlet weak var upRightNumber: UILabel!
    @IBOutlet weak var downLeftNumber: UILabel!
    @IBOutlet weak var downRightNumber: UILabel!
    
    //---- Begin Jewel Labels ----
    
    @IBOutlet weak var jewelLabel1: UILabel!
    @IBOutlet weak var jewelLabel2: UILabel!
    @IBOutlet weak var jewelLabel3: UILabel!
    @IBOutlet weak var jewelLabel4: UILabel!
    @IBOutlet weak var jewelLabel5: UILabel!
    @IBOutlet weak var jewelLabel6: UILabel!
    @IBOutlet weak var jewelLabel7: UILabel!
    @IBOutlet weak var jewelLabel8: UILabel!
    @IBOutlet weak var jewelLabel9: UILabel!
    
    
    
    //---- End Jewel Labels
    
    lazy var jewelLabelArray: [UILabel?] = [jewelLabel1, jewelLabel2, jewelLabel3, jewelLabel4, jewelLabel5, jewelLabel6, jewelLabel7, jewelLabel8, jewelLabel9]
    
    func HideJewelLabels(){
        jewelLabelArray.forEach{
            $0?.text = ""
        }
    }
    
    
    
    
    //  ------------  START  JEWEL LABEL SCORE CHECKS  ---------------------------
    //  --------------------------------------------------------------------------
    func ShowJewelLabelsWithScore(score: Int){
        //Check score for power of 2 and add jewel if needed...
        switch(score % 2 == 0, score % 4 == 0, score % 8 == 0, score % 16 == 0, score % 32 == 0, score % 64 == 0, score % 128 == 0, score % 256 == 0, score % 512 == 0){
        case(true, true, true, true, true, true, true, true, true):
            print("Score \(score) Divisible by 512")
            //Add jewel to ninth jewelLabel...
            self.jewelLabel9.backgroundColor = UIColor(patternImage: UIImage(named: "Imperial_Topaz30x30.png")!)
            //Unhide Label and play sound...
            self.jewelLabel9.isHidden = false
            PlayPowerOfTwoSound()
            
        case(true, true, true, true, true, true, true, true, false):
            print("Score Divisible by 256")
            //Add jewel to eighth jewelLabel...
            self.jewelLabel8.backgroundColor = UIColor(patternImage: UIImage(named: "Tiger_Eye_Red30x30.png")!)
            //Unhide Label...
            self.jewelLabel8.isHidden = false
            PlayPowerOfTwoSound()
            
        case(true, true, true, true, true, true, true, false, false):
            print("Score Divisible by 128")
            //Add jewel to seventh jewelLabel...
            self.jewelLabel7.backgroundColor = UIColor(patternImage: UIImage(named: "Citrine30x30.png")!)
            //Unhide Label...
            self.jewelLabel7.isHidden = false
            PlayPowerOfTwoSound()
            
        case(true, true, true, true, true, true, false, false, false):
            print("Score Divisible by 64")
            //Add jewel to sixth jewelLabel...
            self.jewelLabel6.backgroundColor = UIColor(patternImage: UIImage(named: "Tourmaline30x30.png")!)
            //Unhide Label...
            self.jewelLabel6.isHidden = false
            PlayPowerOfTwoSound()
            
        case(true, true, true, true, true, false, false, false, false):
            print("Score Divisible by 32")
            //Add jewel to fifth jewelLabel...
            self.jewelLabel5.backgroundColor = UIColor(patternImage: UIImage(named: "Orange_Diamond30x30.png")!)
            //Unhide Label...
            self.jewelLabel5.isHidden = false
            PlayPowerOfTwoSound()
            
        case(true, true, true, true, false, false, false, false, false):
            print("Score Divisible by 16")
            //Add jewel to fourth jewelLabel...
            self.jewelLabel4.backgroundColor = UIColor(patternImage: UIImage(named: "Amethyst30x30.png")!)
            //Unhide Label...
            self.jewelLabel4.isHidden = false
            PlayPowerOfTwoSound()
            
        case(true, true, true, false, false, false, false, false, false):
            print("Score Divisible by 8")
            //Add jewel to third jewelLabel...
            self.jewelLabel3.backgroundColor = UIColor(patternImage: UIImage(named: "Orange_Hassonite30x30.png")!)
            //Unhide Label...
            self.jewelLabel3.isHidden = false
            PlayPowerOfTwoSound()
            
        case(true, true, false, false, false, false, false, false, false):
            print("Score Divisible by 4")
            //Add jewel to second jewelLabel...
            self.jewelLabel2.backgroundColor = UIColor(patternImage: UIImage(named: "Ruby_Jubilee30x30.png")!)
            //Unhide Label...
            self.jewelLabel2.isHidden = false
            PlayPowerOfTwoSound()
            
        case(true, false, false, false, false, false, false, false, false):
            print("Score Divisible by 2")
            //Add jewel to first jewelLabel...
            self.jewelLabel1.backgroundColor = UIColor(patternImage: UIImage(named: "golden_topaz30x30.png")!)
            //Unhide Label...
            //self.jewelLabel1.isHidden = false
            FadeInLabel(label: self.jewelLabel1)
            PlayPowerOfTwoSound()
            
            
        default:
            print("Score is not divisible by any options(^2).")
        
        }
        
        
        
        
        //Check score for ending in 5 and add jewel if needed...
        switch(score % 2 != 0, score % 5 == 0){
         
        case(true, true):
            print("Score \(score) Divisible by 5 and not Even")
            //Add jewel to first jewelLabel...
            self.jewelLabel3.backgroundColor = UIColor(patternImage: UIImage(named: "Red_Garnet30x30.png")!)
            //Unhide Label and play sound...
            self.jewelLabel3.isHidden = false
            PlayEndWithFiveSound()
            
            
        default:
            print("Score is not divisible by any options(5).")
            
        }
        
        
        //Check score divisible by 25, 7 and between 128 and 1024 and add jewel if needed...
        switch(score % 2 != 0, score >= 128, score <= 1024, score % 25 == 0, score % 7 == 0){
            
        case(true, true, true, true, false):
            print("Score \(score) Divisible by 25 and not Even(128 < score < 1024)")
            //Add jewel to first jewelLabel...
            self.jewelLabel3.backgroundColor = UIColor(patternImage: UIImage(named: "Alexandrite30x30.png")!)
            //Unhide Label and play sound...
            self.jewelLabel3.isHidden = false
            PlaySpecialOneSound()
            
        case(true, true, true, false, true):
            print("Score \(score) Divisible by 7 and not Even(128 < score < 1024)")
            //Add jewel to first jewelLabel...
            self.jewelLabel4.backgroundColor = UIColor(patternImage: UIImage(named: "sapphire30x30.png")!)
            //Unhide Label and play sound...
            self.jewelLabel4.isHidden = false
            PlaySpecialTwoSound()
            
        default:
            print("Score is not divisible by any options(128 <= score <= 1024).")
            
        }
        
        
        
        //Check score divisible by 3, 13, 7, and between 1025 and 8192 and add jewel if needed...
        switch(score % 3 == 0, score >= 1025, score <= 8192, score % 13 == 0, score % 7 == 0){
            
        case(true, true, true, true, false):
            print("Score \(score) Divisible by 25 and not Even(128 < score < 1024)")
            //Add jewel to first jewelLabel...
            self.jewelLabel4.backgroundColor = UIColor(patternImage: UIImage(named: "opal30x30.png")!)
            //Unhide Label and play sound...
            self.jewelLabel4.isHidden = false
            PlaySpecialTwoSound()
            
        case(true, true, true, false, true):
            print("Score \(score) Divisible by 7 and not Even(128 < score < 1024)")
            //Add jewel to first jewelLabel...
            self.jewelLabel4.backgroundColor = UIColor(patternImage: UIImage(named: "Blue_Topaz30x30.png")!)
            //Unhide Label and play sound...
            self.jewelLabel4.isHidden = false
            PlaySpecialOneSound()
            
        default:
            print("Score is not divisible by any options(128 <= score <= 1024).")
            
        }
        
        
        
        
        
        
        
    
    }
    
    //  ------------  END  JEWEL LABEL SCORE CHECKS  ---------------------------
    //  --------------------------------------------------------------------------
    
    
    
    
    
    
    
    
    
    
    

    var upInt: Int = 0
    var downInt: Int = 0
    var leftInt: Int = 0
    var rightInt: Int = 0
    var upRightInt: Int = 0
    var upLeftInt: Int = 0
    var downLeftInt: Int = 0
    var downRightInt: Int = 0
    
    lazy var levelNumberInt: Int = 10
    var goalNumberInt: Int = Int(arc4random_uniform(10)) + 5
    var goalNumberArray = [Int]()
    var score: Int64 = 0

    var ding: AVAudioPlayer?
    var tink: AVAudioPlayer?
    
    
    //Get the high score...
    let highScore = UserDefaults.standard.string(forKey: "highScore") ?? "0"
    
    
    
    
    
    

    func CalculateNumbers(centerNumber: Int) {
        var centerInt = Int(self.centerNumber.text!)
        if(centerInt! > 9999){
            let centerString = String(centerInt!)
            //Turn string into an array of Ints...
            let centerIntArray = centerString.compactMap{Int(String($0))}
            //Collapse Int array into sum of all numbers in the array...
            centerInt = centerIntArray.reduce(0, +)
        }
        
        if(centerInt == goalNumberInt){
            print("~~~~GOAL ACHIEVED!!!~~~~")
            
            //Add Goal Number to goalNumberArray so that it isn't used again/no duplicates...
            goalNumberArray.append(goalNumberInt)
            
            //Play Reward Sound...
            let path = Bundle.main.path(forResource: "Ting.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            
            do{
                ding = try AVAudioPlayer(contentsOf: url)
                ding?.play()
            }catch{
                print("Could not load DING sound file!!")
            }
            
            
  
 
            
            levelNumberInt += 35
            //Increase goal number by random amount...
            self.goalNumberInt = levelNumberInt - Int(arc4random_uniform(UInt32(levelNumberInt))) + 10
            //Make sure there are no duplicate goal numbers consecutively...
            if(goalNumberArray.contains(self.goalNumberInt)){
                self.goalNumberInt = levelNumberInt - Int(arc4random_uniform(UInt32(levelNumberInt))) + 10
            }
            //Make sure Goal Number does not go over 9999...
            if(self.goalNumberInt > 9999){
                let goalString = String(goalNumberInt)
                //Turn string into an array of Ints...
                let goalIntArray = goalString.compactMap{Int(String($0))}
                //Collapse Int array into sum of all numbers in the array...
                self.goalNumberInt = goalIntArray.reduce(0, +)
            }
            
            self.goalNumber.text = String(describing: self.goalNumberInt)
            
            //Add 1 to score....
            score += 1
            //Check the score and show jewel if needed....
            ShowJewelLabelsWithScore(score: Int(score))
            //Update Score Label...
            self.scoreLabel.text = String(describing: score)
            
            
            //Check if score is higher than recorded highScore and increase if it is...
            if(score > Int(highScore) ?? 0){
                //Store new high score...
                UserDefaults.standard.set(String(describing: score), forKey: "highScore")
                //Display new high score on label...
                self.highScoreLabel.text = String(score)
            }
            
            
            //Change number label/background colors...
            let randomColor: UIColor = UIColor.random.triadic1
            view.backgroundColor = randomColor.complement
            
            self.upLeftNumber.backgroundColor = randomColor.analagous0
            self.upLeftNumber.borderColor = self.upLeftNumber.backgroundColor?.complement
            
            self.upNumber.backgroundColor = randomColor
            self.upNumber.borderColor = self.upNumber.backgroundColor?.complement
            
            self.upRightNumber.backgroundColor = randomColor.analagous1
            self.upRightNumber.borderColor = self.upRightNumber.backgroundColor?.complement
            
            self.downLeftNumber.backgroundColor = randomColor.analagous1
            self.downLeftNumber.borderColor = self.downLeftNumber.backgroundColor?.complement
            
            self.downNumber.backgroundColor = randomColor
            self.downNumber.borderColor = self.downNumber.backgroundColor?.complement
            
            self.downRightNumber.backgroundColor = randomColor.analagous0
            self.downRightNumber.borderColor = self.downRightNumber.backgroundColor?.complement
            
            self.leftNumber.backgroundColor = self.downLeftNumber.backgroundColor?.analagous1
            self.leftNumber.borderColor = self.leftNumber.backgroundColor?.complement
            
            self.rightNumber.backgroundColor = self.downRightNumber.backgroundColor?.analagous0
            self.rightNumber.borderColor = self.rightNumber.backgroundColor?.complement
            
        }
        //print(centerInt ?? 0)

        upInt = centerInt! * 2
        downInt = centerInt!/2
        leftInt = 3 * centerInt! + 1
        rightInt = ((centerInt! - 1)/3)
        
        upLeftInt = leftInt * 2
        upRightInt = rightInt * 2
        downLeftInt = leftInt/2
        downRightInt = rightInt/2

        upNumber.text = String(describing: upInt)
        downNumber.text = String(describing: downInt)
        leftNumber.text = String(describing: leftInt)
        rightNumber.text = String(describing: rightInt)
        
        upRightNumber.text = String(describing: upRightInt)
        upLeftNumber.text = String(describing: upLeftInt)
        downRightNumber.text = String(describing: downRightInt)
        downLeftNumber.text = String(describing: downLeftInt)

    }

    
    //Swipe gesture recognizer calls opposite functions to the directions used
    //as swiping right and the numbers actually going right instead of left
    //actually makes more sense...
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                //print("Swiped right")
                PlayClickSound()
                centerNumber.text = leftNumber.text
                CalculateNumbers(centerNumber: Int(centerNumber.text!)! )
                
            case UISwipeGestureRecognizerDirection.down:
                //print("Swiped down")
                PlayClickSound()
                centerNumber.text = upNumber.text
                CalculateNumbers(centerNumber: Int(centerNumber.text!)! )
                
            case UISwipeGestureRecognizerDirection.left:
                //print("Swiped left")
                PlayClickSound()
                centerNumber.text = rightNumber.text
                CalculateNumbers(centerNumber: Int(centerNumber.text!)! )
                
            case UISwipeGestureRecognizerDirection.up:
                //print("Swiped up")
                PlayClickSound()
                centerNumber.text = downNumber.text
                CalculateNumbers(centerNumber: Int(centerNumber.text!)! )
                
            default:
                break
                
            }
            
        }
        
    }
    
    
    
    //-------------  BEGIN Sound Playing Functions.. -----------------------
    
    func PlayClickSound() {
        //Play Click Sound...
        let path = Bundle.main.path(forResource: "Click-SoundBible.com-1387633738.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do{
            ding = try AVAudioPlayer(contentsOf: url)
            ding?.play()
        }catch{
            print("Could not load CLICK sound file!!")
        }
    }
    
    
    
    func PlayPowerOfTwoSound() {
        //Play Sound every time score of power of two is achieved...
        let path = Bundle.main.path(forResource: "sms-alert-1-daniel_simon.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do{
            ding = try AVAudioPlayer(contentsOf: url)
            ding?.play()
        }catch{
            print("Could not load Power 2 sound file!!")
        }
    }
    
    
    
    
    
    func PlayEndWithFiveSound() {
        //Play Sound every time score ends in Five is achieved...
        let path = Bundle.main.path(forResource: "sms-alert-2-daniel_simon.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do{
            ding = try AVAudioPlayer(contentsOf: url)
            ding?.play()
        }catch{
            print("Could not load PlayEndWithFive sound file!!")
        }
    }
    
    
    
    
    func PlaySpecialOneSound() {
        //Play Sound every time score ends in Five is achieved...
        let path = Bundle.main.path(forResource: "sms-alert-3-daniel_simon.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do{
            ding = try AVAudioPlayer(contentsOf: url)
            ding?.play()
        }catch{
            print("Could not load Special One sound file!!")
        }
    }
    
    
    func PlaySpecialTwoSound() {
        //Play Sound every time score ends in Five is achieved...
        let path = Bundle.main.path(forResource: "sms-alert-5-daniel_simon.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do{
            ding = try AVAudioPlayer(contentsOf: url)
            ding?.play()
        }catch{
            print("Could not load Special One sound file!!")
        }
    }
    
    
    //-------------  END  Sound Playing Functions.. -----------------------

    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Hide all the jewel labels...
        HideJewelLabels()
        
        //let imagesArray = ScoreCheck().ShowJewelNumber(score: Int(999999))
        //print("IMAGES ARRAY: \(imagesArray)")
        
        
        //Retrieve High Score or, if none, set to zero string...
        let highScore = UserDefaults.standard.string(forKey: "highScore") ?? "0"
        self.highScoreLabel.text = highScore
        

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
   
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        
        
        
        
        self.goalNumber.text = String(describing: goalNumberInt)
        

        centerNumber.text = "1"
        CalculateNumbers(centerNumber: Int(centerNumber.text!)! )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

