//
//  LottieNode+Proxy.swift
//  LottieXtend-iOS
//
//  Created by José Donor on 18/11/2018.
//

import Lottie



/// Animation view's proxy
extension LottieNode {

	// MARK: Properties

	/// Animation will repeat indefinitely
	public var autoRepeats: Bool {
		get { return lottieView?.loopAnimation ?? pendingProperties.autoRepeats }
		set {
			if let lottieView = lottieView { lottieView.loopAnimation = newValue }
			else { pendingProperties.autoRepeats = newValue }
		}
	}
	/// Animation will be reversed when repeating
	public var isReversed: Bool {
		get { return lottieView?.autoReverseAnimation ?? pendingProperties.isReversed }
		set {
			if let lottieView = lottieView { lottieView.autoReverseAnimation = newValue }
			else { pendingProperties.isReversed = newValue }
		}
	}
	/// Animation's speed
	public var speed: CGFloat {
		get { return lottieView?.animationSpeed ?? pendingProperties.speed }
		set {
			if let lottieView = lottieView { lottieView.animationSpeed = newValue }
			else { pendingProperties.speed = newValue }
		}
	}
	/// Layer will be rasterized when animation is paused
	public var shouldRasterize: Bool {
		get { return lottieView?.shouldRasterizeWhenIdle ?? pendingProperties.shouldRasterize }
		set {
			if let lottieView = lottieView { lottieView.shouldRasterizeWhenIdle = newValue }
			else { pendingProperties.shouldRasterize = newValue }
		}
	}
	/// Animation view's content mode
	public var viewContentMode: UIView.ContentMode {
		get { return lottieView?.contentMode ?? pendingProperties.contentMode }
		set {
			if let lottieView = lottieView { lottieView.contentMode = newValue }
			else { pendingProperties.contentMode = newValue }
		}
	}


	/// Animation's progress
	public var progress: CGFloat { return lottieView?.animationProgress ?? 0 }
	/// Animation's duration
	public var duration: CGFloat { return lottieView?.animationDuration ?? 1 }



	// MARK: Methods

	/// Adds a view to a given layer
	public func addSubView(_ view: UIView,
						   toLayerNamed name: String) {
		lottieView?.addSubView(view, toLayerNamed: name)
	}

	/// Adds a view and masks it with a given layer
	public func maskSubView(_ view: UIView,
						   	toLayerNamed name: String) {
		lottieView?.maskSubView(view, toLayerNamed: name)
	}

	/// Prints out all the key paths of the animation
	public func logKeypaths() {
		lottieView?.logHierarchyKeypaths()
	}

}
