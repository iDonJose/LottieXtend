import Lottie
import LottieXtend
import PlaygroundSupport


var lottieView = LOTAnimationView()

/*:
 ### `setAnimation(file:bundle:)`
 Sets animation source file and bundle.
 */

lottieView = LOTAnimationView.init(name: "animation.json", bundle: .main)

/*:
 ### `addSubView(_:toLayerNamed:)`
 Adds a view to a layer.
 */

let view_1 = UIView()
view_1.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
view_1.frame.size = .init(width: 20, height: 20)
lottieView.addSubView(view_1, toLayerNamed: "Circle 1")

/*:
 ### `maskSubView(:toLayerNamed:)`
 Adds a view and masks it with layer.
 */

let view_2 = UIView()
view_2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
view_2.frame.origin = .init(x: 20, y: 20)
//lottieView.maskSubView(view_2, toLayerNamed: "Circle 1")

/*:
 ### `setColor(_:for:)`
 Changes a layer's fill color.
 > See also `setValue(_:for:)`, `setPoint(_:for:)`, `setSize(_:for:)`, `setPath(_:for:)`
 */

lottieView.setColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: "Line 1.Forme 1.Fond 1.Color")

/*:
 ### `setColor(for:_:)`
 Changes a layer's fill color according to current progress.
 > See also `setValue(for:_:)`, `setPoint(for:_:)`, `setSize(for:_:)`, `setPath(for:_:)`
 */

DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
    lottieView.setColor(for: "Line 1.Forme 1.Fond 1.Color") { p in
        if p < 0.33 { print("Line is blue"); return #colorLiteral(red: 0.1233691564, green: 0.1807482785, blue: 0.9666399275, alpha: 1) }
        else if p < 0.66 { print("Line is white"); return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
        else { print("Line is red"); return #colorLiteral(red: 0.9666399275, green: 0.09782117499, blue: 0.2961584293, alpha: 1) }
    }
}

/*:
 ### `cancelValueCallback(for:)`
 Stops changing value.
 */

DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
    print("Stop changing line color")
    lottieView.cancelValueCallback(for: "Line 1.Forme 1.Fond 1.Color")
}


lottieView.frame.size = lottieView.sceneModel!.compBounds.size
lottieView.autoReverseAnimation = true
lottieView.loopAnimation = true
lottieView.play()

PlaygroundPage.current.liveView = lottieView

//: < [Summary](Summary) | [Next](@next) >
