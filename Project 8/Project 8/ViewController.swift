import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var defaultScore = 0
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.layer.borderColor = UIColor.red.cgColor
        scoreLabel.layer.borderWidth = 1
        view.addSubview(scoreLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.text = "RHYTHM"
        cluesLabel.textAlignment = .center
        cluesLabel.font = UIFont.systemFont(ofSize: 44)
        cluesLabel.isUserInteractionEnabled = false
        view.addSubview(cluesLabel)
        
        let submit = UIButton(type: .system)
        submit.layer.borderColor = UIColor.lightGray.cgColor
        submit.layer.borderWidth = 5
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("   SUBMIT   ", for: .normal)
        //   submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.layer.borderColor = UIColor.lightGray.cgColor
        clear.layer.borderWidth = 5
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("   CLEAR   ", for: .normal)
        //    clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                                     scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                     cluesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                                     cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 30),
                                     currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                                     currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
                                     submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
                                     submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
                                     submit.heightAnchor.constraint(equalToConstant: 44),
                                     clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
                                     clear.heightAnchor.constraint(equalToConstant: 44),
                                     clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
                                     buttonsView.widthAnchor.constraint(equalToConstant: 750),
                                     buttonsView.heightAnchor.constraint(equalToConstant: 320),
                                     buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
                                     buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)])
        let width = 40
        let hight = 40
        
        var schet = 0
        let alfavit = ["q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m"]
        
        for row in 0..<3 {
            for column in 0..<9{
                if schet < 26 {
                    let letterButton = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                    letterButton.setTitle(alfavit[schet], for: .normal)
                    // letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                    let frame = CGRect(x: column * width, y: row * hight, width: width, height: hight)
                    letterButton.frame = frame
                    
                    buttonsView.addSubview(letterButton)
                    letterButtons.append(letterButton)
                    schet += 1
                }
                else {
                    continue
                }
            }
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadLevel()
//        
//    }
//    
    @objc func letterTapped (_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else {return}
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        sender.alpha = 0
        sender.titleLabel?.alpha = 0
        activatedButtons.append(sender)
        
    }
    
    @objc func submitTapped (_ sender: UIButton){
        guard let answerText = currentAnswer.text else {return}
        
        if let solutionPosition = solutions.firstIndex(of: answerText){
            activatedButtons.removeAll()
            
//          var splitAnswer = answerLabel.text?.components(separatedBy: "\n")
//         splitAnswer?[solutionPosition] = answerText
//            answerLabel.text = splitAnswer?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            defaultScore += 1
            
            if defaultScore % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present (ac, animated: true)
            }
        } else{
            score -= 1
            let ac = UIAlertController(title: "Ошибка", message: "Такого слова нет", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Продолжить", style: .default))
            present (ac, animated: true)
        }
    }
    
    func levelUp (action: UIAlertAction){
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons{
            button.isHidden = false
        }
    }
    
    @objc func clearTapped (_ sender: UIButton){
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
    }
    
    func loadLevel (){
        var clueString = ""
        var solutionsString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContets = try? String(contentsOf: levelFileURL){
                var lines = levelContets.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated(){
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionsString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
   //     answerLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        if letterButtons.count == letterBits.count {
            for i in 0..<letterButtons.count{
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
}
