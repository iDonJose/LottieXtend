/*:
 > **Start Up**
 > 1. Install Pod depencies by running `$ pod install`
 > 1. Open `LottieXtend.xcworkspace`
 > 1. Build `LottieXtend-iOS` scheme with an iOS Simulator
 > 1. Open the `Playground.playground`
 > 1. Run Playground !

 ***

 # LottieXtend
 `LottieXtend` provides a (`Texture`'s) Node wrapping a Lottie animation view and adds some handy methods.

 ### Summary

 **LOTAnimationView**
 - [`setAnimation(file:bundle)`](LOTAnimationView) : Sets animation source file and bundle
 - [`addSubView(_:toLayerNamed:)`](LOTAnimationView) : Adds a view to a layer
 - [`maskSubView(_:toLayerNamed:)`](LOTAnimationView) : Adds a view and masks it with layer
 - [`setColor(_:for:)`, `setValue(_:for:)`, `setPoint(_:for:)`, `setSize(_:for:)`, `setPath(_:for:)`](LOTAnimationView) : Changes a layer's value
 - [`setColor(for:_:)`, `setValue(for:_:)`, `setPoint(for:_:)`, `setSize(for:_:)`, `setPath(for:_:)`](LOTAnimationView) : Adds a callback to change a layer's value given progress
 - [`cancelValueCallback(for:)`](LOTAnimationView) : Stops changing value

  **LottieNode**
 - [`init(file:bundle:)`](LottieNode) : Initializes a LottieNode from a source file and bundle
 - [`autoStart`, `autoRepeats`, `isReversed`, `speed`, `shouldRasterize`, `contentMode`](LottieNode) : Node's properties
 - [`setAnimation(file:bundle:)`](LottieNode) : Changes source file and bundle of animation
 - [`Inputs.play`, `Inputs.playSection`, `Inputs.pause`, `Inputs. stop`, `Inputs.progress`](LottieNode) : Control animation
 - [`Outputs.isAnimating`](LottieNode) : Animation's state

 */
