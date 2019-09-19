import UIKit
import DLRadioButton

class RadioButton: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func radioMale(sender: AnyObject) {
        label.text = "Gender is Male"
    }
    
    
    @IBAction func radioFemale(sender: AnyObject) {
        label.text = "Gender is Female"
    }
    
}
