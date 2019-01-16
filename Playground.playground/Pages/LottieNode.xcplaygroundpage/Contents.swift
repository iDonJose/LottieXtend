/*:
 ## `LottieNode`
 */

import AsyncDisplayKit
import LottieXtend
import PlaygroundSupport


let node = LottieNode()

node.frame.size = .init(width: 400, height: 300)
node.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

node.visual.autoStart = false
node.visual.autoRepeats = true
node.visual.isReversed = false
node.visual.speed = 2
node.visual.shouldRasterize = true
node.visual.contentMode = .scaleAspectFit


node.inputs.source.swap(((name: "switch.json", bundle: .main), nil))

node.outputs.isAnimating.producer
    .startWithValues { print("\($0 ? "▶️" : "⏸")") }

node.inputs.play.swap(())


PlaygroundPage.current.liveView = node.view

//: < [Summary](Summary) | [Next](@next) >
