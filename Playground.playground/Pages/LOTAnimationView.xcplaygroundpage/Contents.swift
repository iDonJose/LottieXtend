/*:
 ## `LOTAnimationView`
 */

import Lottie
import LottieXtend
import PlaygroundSupport


let lottieView = LOTAnimationView(name: "animation.json")
lottieView.frame.size = .init(width: 400, height: 400)
lottieView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

lottieView.autoReverseAnimation = true
lottieView.loopAnimation = true

/*:
 ### `addSubView(_:toLayerNamed:)`
 Adds a view to one layer of the animation
 */

let circle = UIView()
circle.frame.origin.x = -20
circle.frame.size = .init(width: 20, height: 20)
circle.layer.cornerRadius = 10
circle.backgroundColor = #colorLiteral(red: 0.2268531035, green: 0.9372549057, blue: 0.1249458688, alpha: 1)
lottieView.addSubView(circle, toLayerNamed: "Circle 1")


/*:
 ### `setColor(_:for:)`
 Changes color parameter in a layer
 > See also `setValue(_:for:)`, `setPoint(_:for:)`, `setSize(_:for:)`, `setPath(_:for:)`
 */

lottieView.setColor(#colorLiteral(red: 0.2031991126, green: 0.3204490806, blue: 0.9690987723, alpha: 1), for: "Line 1.Forme 1.Fond 1.Color")


/*:
 ### `setColor(for:_:)`
 Changes color parameter in a layer dynamically when progress changes
 > See also `setValue(for:_:)`, `setPoint(for:_:)`, `setSize(for:_:)`, `setPath(for:_:)`
 */

lottieView.setColor(for: "Line 1.Forme 1.Contour 1.Color") {
    return $0.truncatingRemainder(dividingBy: 0.2) < 0.1 ? #colorLiteral(red: 0.2791606399, green: 0.9690987723, blue: 0.2515343422, alpha: 1) : #colorLiteral(red: 0.9690987723, green: 0.4401682425, blue: 0.39307365, alpha: 1)
}

/*:
 ### `cancelValueCallback(for:)`
 Stops changing value.
 */

lottieView.cancelValueCallback(for: "Line 1.Forme 1.Fond 1.Color")


PlaygroundPage.current.liveView = lottieView
lottieView.play()

//: < [Summary](Summary) | [Next](@next) >
