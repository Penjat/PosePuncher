import SpriteKit

class TextInputPresenter {
    var node: SKNode = {
        let bodyNode = SKNode()
        bodyNode.addChild(SKShapeNode.init(circleOfRadius: 50))
        return bodyNode
    }()
}
