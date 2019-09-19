//
//  CalendarController.swift
//  MEDITASKiOS
//
//  Created by cs4743 on 7/26/19.
//  Copyright © 2019 MohammedRaheem. All rights reserved.
//

import UIKit

class CalendarController: UIViewController {

    @IBOutlet weak var day1: UIButton!
    @IBOutlet weak var day2: UIButton!
    @IBOutlet weak var day3: UIButton!
    @IBOutlet weak var day4: UIButton!
    @IBOutlet weak var day5: UIButton!
    @IBOutlet weak var day6: UIButton!
    @IBOutlet weak var day7: UIButton!
    @IBOutlet weak var monthText: UIButton!
    
    let monthFormat = DateFormatter()
    let dayFormat = DateFormatter()
    let formatter = DateFormatter()
    
    var buttonDatesDict: [Int?:Date] = [:]
    let cal = Calendar.current
    var startdate = Date()
    var enddate = Date()
    var selecteddate = Date()
    
    var days = [Int]()
    var dates = [Date]()
    var buttons: [UIButton] = [UIButton]()
    
    @IBAction func day1Click(_ sender: UIButton) {
        let buttonInt = Int(sender.title(for: .normal)!)
        selecteddate = buttonDatesDict[buttonInt]!
        updateCalendarGUI()

    }
    
    @IBAction func day2Click(_ sender: UIButton) {
        let buttonInt = Int(sender.title(for: .normal)!)
        selecteddate = buttonDatesDict[buttonInt]!
         updateCalendarGUI()
    
    }
    
    @IBAction func day3Click(_ sender: UIButton) {
        let buttonInt = Int(sender.title(for: .normal)!)
        selecteddate = buttonDatesDict[buttonInt]!
        updateCalendarGUI()

    }
    
    @IBAction func day4Click(_ sender: UIButton) {
        let buttonInt = Int(sender.title(for: .normal)!)
        selecteddate = buttonDatesDict[buttonInt]!
        updateCalendarGUI()

    }
    
    @IBAction func day5Click(_ sender: UIButton) {
        let buttonInt = Int(sender.title(for: .normal)!)
        selecteddate = buttonDatesDict[buttonInt]!
        updateCalendarGUI()

        
    }
    
    @IBAction func day6Click(_ sender: UIButton) {
        let buttonInt = Int(sender.title(for: .normal)!)
        selecteddate = buttonDatesDict[buttonInt]!
        updateCalendarGUI()

    }
    @IBAction func day7Click(_ sender: UIButton) {
        let buttonInt = Int(sender.title(for: .normal)!)
        selecteddate = buttonDatesDict[buttonInt]!
        updateCalendarGUI()

    }
    
    func initalizeValues(){
        buttons = [day1,day2,day3,day4,day5,day6,day7]
        monthFormat.dateFormat = "LLLL"
        formatter.dateFormat = "dd/MM/yyyy"
        dayFormat.dateFormat = "d"
        


    }
    
    func updateDict(){
        
    }
    
    func updateCalendarGUI(){
        for b in buttons{
        
            if buttonDatesDict[Int(b.currentTitle!)] == selecteddate{
                b.isSelected = true
                let buttonInt = Int(b.title(for: .normal)!)
                selecteddate = buttonDatesDict[buttonInt]!
                
            } else{
                b.isSelected = false
            }
        }
    }
    
    @IBAction func tappedPrev(_ sender: Any) {
        startdate = Calendar.current.date(byAdding: .day, value: -14, to: enddate)!
        dates.removeAll()
        days.removeAll()
        var date = startdate
     
        for i in 0 ... 6 {
            let day = cal.component(.day, from: date)
            days.append(day)
            dates.append(Calendar.current.date(byAdding: .day, value: +i, to: startdate)!)
            date = cal.date(byAdding: .day, value: +1, to: date)!
            
        }
        for i in 0..<days.count {
            if i < dates.count {
                
                let key = days[i]
                let value = dates[i]
                
                buttonDatesDict[key] = value
            }
        }
        enddate = date
        day1.setTitle("\(cal.component(.day, from: dates[0]))", for: .normal)
        day2.setTitle("\(cal.component(.day, from: dates[1]))", for: .normal)
        day3.setTitle("\(cal.component(.day, from: dates[2]))", for: .normal)
        day4.setTitle("\(cal.component(.day, from: dates[3]))", for: .normal)
        day5.setTitle("\(cal.component(.day, from: dates[4]))", for: .normal)
        day6.setTitle("\(cal.component(.day, from: dates[5]))", for: .normal)
        day7.setTitle("\(cal.component(.day, from: dates[6]))", for: .normal)
        monthText.setTitle("\(monthFormat.string(from:dates[0]))".uppercased(), for: .normal)
        updateCalendarGUI()
    }
    
    @IBAction func tappedNext(_ sender: Any) {
        startdate = enddate
        dates.removeAll()
        days.removeAll()
        var date = startdate
        
        for i in 0 ... 6 {
            let day = cal.component(.day, from: date)
            days.append(day)
            dates.append(Calendar.current.date(byAdding: .day, value: +i, to: startdate)!)
            date = cal.date(byAdding: .day, value: +1, to: date)!
            
        }
        for i in 0..<days.count {
            if i < dates.count {
                
                let key = days[i]
                let value = dates[i]
                
                buttonDatesDict[key] = value
            }
        }
       enddate = date
        day1.setTitle("\(cal.component(.day, from: dates[0]))", for: .normal)
        day2.setTitle("\(cal.component(.day, from: dates[1]))", for: .normal)
        day3.setTitle("\(cal.component(.day, from: dates[2]))", for: .normal)
        day4.setTitle("\(cal.component(.day, from: dates[3]))", for: .normal)
        day5.setTitle("\(cal.component(.day, from: dates[4]))", for: .normal)
        day6.setTitle("\(cal.component(.day, from: dates[5]))", for: .normal)
        day7.setTitle("\(cal.component(.day, from: dates[6]))", for: .normal)
        monthText.setTitle("\(monthFormat.string(from:dates[0]))".uppercased(), for: .normal)
        updateCalendarGUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeValues()
        startdate = enddate
        dates.removeAll()
        days.removeAll()
        var date = startdate
        
        for i in 0 ... 6 {
            let day = cal.component(.day, from: date)
            days.append(day)
            dates.append(Calendar.current.date(byAdding: .day, value: +i, to: startdate)!)
            date = cal.date(byAdding: .day, value: +1, to: date)!
        }
        
        for i in 0..<days.count {
            if i < dates.count {
                
                let key = days[i]
                let value = dates[i]
                
                buttonDatesDict[key] = value
            }
        }
        
        
        enddate = date
        //day1.isSelected = true        //UPDATE BUTTONS
        monthText.setTitle("\(monthFormat.string(from:dates[0]))".uppercased(), for: .normal)
        day1.setTitle("\(cal.component(.day, from: dates[0]))", for: .normal)
        day2.setTitle("\(cal.component(.day, from: dates[1]))", for: .normal)
        day3.setTitle("\(cal.component(.day, from: dates[2]))", for: .normal)
        day4.setTitle("\(cal.component(.day, from: dates[3]))", for: .normal)
        day5.setTitle("\(cal.component(.day, from: dates[4]))", for: .normal)
        day6.setTitle("\(cal.component(.day, from: dates[5]))", for: .normal)
        day7.setTitle("\(cal.component(.day, from: dates[6]))", for: .normal)
        
        updateCalendarGUI()

    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {
    func makeCorner(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.isOpaque = false
    }
}
