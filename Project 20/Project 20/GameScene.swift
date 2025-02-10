import SpriteKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score = 0{
        didSet{
            
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: 80, y: 60)
        scoreLabel.zPosition = 1
        scoreLabel.fontSize = 44
        addChild(scoreLabel)
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        
        
        
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        // 1
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        // 2
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        // 3
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
            
        case 1:
            firework.color = .green
            
        case 2:
            firework.color = .red
            
        default:
            break
        }
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse"){
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks(){
        
            let movementAmount: CGFloat = 1800
            
            switch Int.random(in: 0...3){
            case 0:
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            case 1:
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: 100, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: 200, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: -100, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: -200, x: 512 + 200, y: bottomEdge)
            case 2:
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge - 200)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge - 100)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            case 3:
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge - 200)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge - 100)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            default:
                break
            }

    }
    
    func checkTouches(_ touches: Set<UITouch>){
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint{
            guard node.name == "firevork" else {continue}
            
            for parent in fireworks{
                guard let firework = parent.children.first as? SKSpriteNode else {continue}
                
                
                if firework.name == "selected" && firework.color == node.color{
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches )
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode (firework: SKNode){
        if let emitter = SKEmitterNode(fileNamed: "explode"){
            emitter.position = firework.position
            addChild(emitter)
        }
            
    }
    
    func explodeFirework (){
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else {continue}
            
            if firework.name == "selected"{
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
