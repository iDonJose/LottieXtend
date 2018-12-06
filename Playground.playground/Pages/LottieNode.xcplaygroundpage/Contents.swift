import AsyncDisplayKit
import LottieXtend
import PlaygroundSupport


/*:
 ### `init(file:bundle:)`
 Initializes a LottieNode from a source file and bundle.
 */
let node = LottieNode(file: "switch.json", bundle: .main)

/*:
 ### `autoStart`, `autoRepeats`, `isReversed`, `speed`, `shouldRasterize`, `contentMode`
 Set properties before or after underlying animation view is loaded.
 */

node.visual.autoStart = true
node.visual.autoRepeats = true
node.visual.isReversed = false
node.visual.speed = 2
node.visual.shouldRasterize = true
node.visual.contentMode = .scaleAspectFit

/*:
 ### `setAnimation(file:bundle:)`
 Changes source file and bundle of animation.
 */
//node.setAnimation(file: "switch.json", bundle: .main)

/*:
 ### `Inputs.play`, `Inputs.playSection`, `Inputs.pause`, `Inputs. stop`, `Inputs.progress`
 Control animation.
 */

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    print("Pause animation")
    node.inputs.pause.swap(())
    print("Set animation's progress to 20%")
    node.inputs.progress.swap(0.2)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    print("Plays animation from 60% to 100%")
    node.inputs.playSection.swap((from: 0.6, to: 1))
}

/*:
 ### `Outputs.isAnimating`
 Animation's state.
 */
node.outputs.isAnimating.producer
    .skipRepeats()
    .startWithValues { print("🎥 Is animating : \($0)") }



let container = ASDisplayNode()
container.frame.size = .init(width: 400, height: 600)
container.addSubnode(node)
container.layoutSpecBlock = { _, _ in
    return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: node)
}

PlaygroundPage.current.liveView = container.view

//: < [Summary](Summary) | [Next](@next) >
