//
//  LottieNode+Proxy.swift
//  LottieXtend-iOS
//
//  Created by José Donor on 18/11/2018.
//

import Lottie



/// Animation view's proxy
extension LottieNode {

    /// Progress
    public var progress: Double {
        return Double(lottieView?.animationProgress ?? 0)
    }


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
