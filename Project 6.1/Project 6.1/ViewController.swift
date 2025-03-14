import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
    }
    func askQuestion(action: UIAlertAction!){
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            button1.setImage(UIImage(named: countries[0]), for: .normal)
            button2.setImage(UIImage(named: countries[1]), for: .normal)
            button3.setImage(UIImage(named: countries[2]), for: .normal)

            title = countries[correctAnswer].uppercased()
    }
    
    var iteration = 0
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if iteration < 10 {
            var title: String
            if correctAnswer == sender.tag{
                title = "Correct"
                score += 1
            } else{
                title = "Wrong, this flag \(countries[sender.tag])"
                score -= 1
            }
            let ac = UIAlertController(title: title, message: "Your score is: \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            iteration += 1
        } else {
            let ac = UIAlertController(title: title, message: "Your finaly score is: \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Complete", style: .default))
            present(ac, animated: true)
        }
    }
}
