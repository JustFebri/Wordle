//
//  ViewController.swift
//  Wordle
//
//  Created by Febri on 01/04/22.
//

import UIKit

extension UIView {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class ViewController: UIViewController {
    
    var timer = Timer()
    var bankSoal = ["MAGIC", "PIANO", "EARTH", "FLOOR", "FRUIT", "MODEL", "PHONE", "PRICE", "RADIO", "RIVER", "PLANE", "MOUSE", "COACH", "BROKE", "BRICK", "PIZZA", "BREAK", "APPLE", "MANGO", "NATAL", "PIECE", "PRIZE", "GRAND", "FLUTE", "FLUID", "CRANE", "DRONE", "KNIFE", "CHAIR", "RANGE", "QUEUE", "BLESS", "GLASS", "GAMES", "PLANT", "MONTH", "MOUTH", "MOUNT", "SLEEP", "COUGH", "TWIST", "BLACK", "GREEN", "WHITE", "BROOM", "LIGHT", "BINGO", "SNAKE", "BEACH", "FLOUR", "TRAIN"]
    var KeyStatus = Array(repeating: "", count: 28)
    var soal = ""
    @IBOutlet weak var LbTimer: UILabel!
    @IBOutlet var allLabel: [UILabel]!
    @IBOutlet var Keyboard: [UIButton]!
    var indexbaris = 0;
    var indextotal = 0;
    var count = 0
    var answer = ""
    
    @IBAction func btnreset(_ sender: Any) {
        for item in 0...allLabel.count-1{
            allLabel[item].borderWidth = 1
            allLabel[item].textColor = UIColor.black
            allLabel[item].text = ""
            allLabel[item].backgroundColor = UIColor.white
        }
        for item in 0...Keyboard.count-1{
            Keyboard[item].backgroundColor = UIColor.systemGray4
            Keyboard[item].isUserInteractionEnabled = true
        }
        for item in 0...KeyStatus.count-1{
            KeyStatus[item] = ""
        }
        indexbaris = 0
        indextotal = 0
        answer = ""
        rand()
        count = 0
        timer.invalidate()
        LbTimer.text = "00:00:00"
        timerStart()
    }
    
    func rand(){
        let idxrand = Int.random(in: 1...bankSoal.count)
        soal = bankSoal[idxrand-1]
        print(idxrand ," ", soal)
    }
    @IBAction func btnReset(_ sender: UIButton) {
        timerStop()
        count = 0
        timerStart()
    }
    
    @IBAction func KeyboardClick(_ sender: UIButton) {
        print("Key: " + sender.titleLabel!.text!)
        
        if(sender.titleLabel!.text! == "⏎"){
            print("Question :  " + soal)
            if(indexbaris == 5){
                print("Answer: " + answer)
                if(answer == soal){
                    //state win
                    winloseState()
                    for item in indextotal-indexbaris...indextotal-1{
                        allLabel[item].borderWidth = 0
                        allLabel[item].backgroundColor = UIColor(red: 107, green: 169, blue: 100)
                        allLabel[item].textColor = UIColor.white
                        changeKeyboardColor(huruf: allLabel[item].text!, status: "satu")
                    }
                    print("Win")
                    showToastWin(message: "You Win !!!")
                }
                else{
                    var temp = 0;
                    for index in answer.indices{
                        if(soal[index] == answer[index]){
                            allLabel[indextotal - indexbaris + temp].backgroundColor = UIColor(red: 107, green: 169, blue: 100)
                            allLabel[indextotal - indexbaris + temp].textColor = UIColor.white
                            changeKeyboardColor(huruf: allLabel[indextotal - indexbaris + temp].text!, status: "satu")
                        }
                        else if(soal.contains(answer[index])){
                            allLabel[indextotal - indexbaris + temp].backgroundColor = UIColor(red: 199, green: 180, blue: 87)
                            allLabel[indextotal - indexbaris + temp].textColor = UIColor.white
                            changeKeyboardColor(huruf: allLabel[indextotal - indexbaris + temp].text!, status: "dua")
                        }
                        else{
                            allLabel[indextotal - indexbaris + temp].backgroundColor = UIColor(red: 120, green: 125, blue: 126)
                            allLabel[indextotal - indexbaris + temp].textColor = UIColor.white
                            changeKeyboardColor(huruf: allLabel[indextotal - indexbaris + temp].text!, status: "tiga")
                        }
                        temp += 1
                    }
                    if(indextotal == 25){
                        //state lose
                        print("Lose")
                        winloseState()
                        showToastLose(message: "You Lose !!!")
                    }
                }
                answer.removeAll()
                indexbaris = 0
            }
            else{
                showToast(message: "Not Enough Letter !!!")
            }
        }
        else if(sender.titleLabel!.text! == "⌫"){
            print("Press Delete")
            if(indexbaris != 0 ){
                indexbaris -= 1
                indextotal -= 1
                allLabel[indextotal].text = ""
                answer.removeLast()
            }
            else{
                showToast(message: "Letter is Empty !!!")
            }
        }
        else{
            print("Press AnythingElse")
            if(indexbaris != 5){
                allLabel[indextotal].text = sender.titleLabel!.text!
                answer.append(contentsOf: sender.titleLabel!.text!)
                indexbaris += 1
                indextotal += 1
            }
            else{
                showToast(message: "Letter is Full !!!")
            }
        }
    }
    
    func changeKeyboardColor(huruf: String, status: String){
        for item in 0...Keyboard.count-1{
            if(Keyboard[item].titleLabel!.text! == huruf){
                if(status == "satu"){
                    Keyboard[item].backgroundColor = UIColor(red: 107, green: 169, blue: 100)
                    KeyStatus[item] = "satu"
                }
                else if(status == "dua"){
                    if(KeyStatus[item] != "satu"){
                        Keyboard[item].backgroundColor = UIColor(red: 199, green: 180, blue: 87)
                        KeyStatus[item] = "dua"
                    }
                }
                else if(status == "tiga"){
                    if(KeyStatus[item] != "satu" && KeyStatus[item] != "dua"){
                        Keyboard[item].backgroundColor = UIColor(red: 120, green: 125, blue: 126)
                    }
                }
            }
            
        }
    }
    
    func winloseState(){
        for item in 0...Keyboard.count-1{
            Keyboard[item].isUserInteractionEnabled = false
        }
        timer.invalidate()
    }
    
    
    func timerStart(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timercounter), userInfo: nil, repeats: true)
    }
    
    func timerStop(){
        timer.invalidate()
    }
    
    @objc func timercounter() -> Void {
        count += 1
        let time = secondsToHourMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        LbTimer.text = timeString
    }
    
    func secondsToHourMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(bankSoal.count)
        rand()
        timerStart()
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    
    }
}

extension UIViewController {
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-220, width: 180, height: 35))
        toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastLose(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-220, width: 180, height: 35))
        toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.6, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastWin(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-220, width: 180, height: 35))
        toastLabel.backgroundColor = UIColor(red: 107, green: 169, blue: 100)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.6, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
