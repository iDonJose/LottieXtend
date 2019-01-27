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

    /// Frame rate
    public var fps: Int? {
        return lottieView?.sceneModel?.framerate?.intValue
    }


	// MARK: Methods

	/// Converts a point from the animation view's coordinate space into one's of a specific layer.
	public func convert(_ point: CGPoint,
						toLayerNamed name: String) -> CGPoint? {
		return lottieView?.convert(point, toLayerNamed: name)
	}

	/// Converts a point from a layer's coordinate space into the one of the animation view.
	public func convert(_ point: CGPoint,
						fromLayerNamed name: String) -> CGPoint? {
		return lottieView?.convert(point, fromLayerNamed: name)
	}


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


	// MARK: - Value Delegate

	/// Cancels value callback for keypath.
	public func cancelValueCallback(for keypath: String) {
		lottieView?.cancelValueCallback(for: keypath)
	}


	/// Sets a float value for a given keypath
	public func setValue(_ value: CGFloat,
						 for keypath: String) {
		lottieView?.setValue(value, for: keypath)
	}

	/// Sets a closure that maps a progress to a float value for a given keypath
	public func setValue(for keypath: String,
						 _ valueCallback: @escaping (CGFloat) -> CGFloat) {
		lottieView?.setValue(for: keypath, valueCallback)
	}


	/// Sets a size for a given keypath
	public func setSize(_ size: CGSize,
						for keypath: String) {
		lottieView?.setSize(size, for: keypath)
	}

	/// Sets a closure that maps a progress to a size for a given keypath
	public func setSize(for keypath: String,
						_ sizeCallback: @escaping (CGFloat) -> CGSize) {
		lottieView?.setSize(for: keypath, sizeCallback)
	}


	/// Sets a point for a given keypath
	public func setPoint(_ point: CGPoint,
						 for keypath: String) {
		lottieView?.setPoint(point, for: keypath)
	}

	/// Sets a closure that maps a progress to a point for a given keypath
	public func setPoint(for keypath: String,
						 _ pointCallback: @escaping (CGFloat) -> CGPoint) {
		lottieView?.setPoint(for: keypath, pointCallback)
	}


	/// Sets a path for a given keypath
	public func setPath(_ path: UIBezierPath,
						for keypath: String) {
		lottieView?.setPath(path, for: keypath)
	}

	/// Sets a closure that maps a progress to a path for a given keypath
	public func setPath(for keypath: String,
						_ pathCallback: @escaping (CGFloat) -> UIBezierPath) {
		lottieView?.setPath(for: keypath, pathCallback)
	}


	/// Sets a color for a given keypath
	public func setColor(_ color: UIColor,
						 for keypath: String) {
		lottieView?.setColor(color, for: keypath)
	}

	/// Sets a closure that maps a progress to a color for a given keypath
	public func setColor(for keypath: String,
						 _ colorCallback: @escaping (CGFloat) -> UIColor) {
		lottieView?.setColor(for: keypath, colorCallback)
	}

}
