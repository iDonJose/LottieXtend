//
//  LOTAnimationView.swift
//  LottieXtend-iOS
//
//  Created by José Donor on 18/11/2018.
//

import Lottie



extension LOTAnimationView {

	// MARK: - Sub-View

	/// Converts a point from the animation view's coordinate space into one's of a specific layer.
	public func convert(_ point: CGPoint,
						toLayerNamed name: String) -> CGPoint {
		return convert(point, toKeypathLayer: LOTKeypath(string: name))
	}

	/// Converts a point from a layer's coordinate space into the one of the animation view.
	public func convert(_ point: CGPoint,
						fromLayerNamed name: String) -> CGPoint {
		return convert(point, fromKeypathLayer: LOTKeypath(string: name))
	}

	/// Adds a view to a given layer.
	public func addSubView(_ view: UIView,
						   toLayerNamed name: String) {
		addSubview(view, toKeypathLayer: LOTKeypath(string: name))
	}

	/// Adds a view and masks it with a given layer.
	public func maskSubView(_ view: UIView,
							toLayerNamed name: String) {
		maskSubview(view, toKeypathLayer: LOTKeypath(string: name))
	}


	// MARK: - Value Delegate

	/// Cancels value callback for keypath.
	public func cancelValueCallback(for keypath: String) {
		delegates[keypath] = nil
	}


	// MARK: CGFloat Value

	/// Sets a float value for a given keypath
	public func setValue(_ value: CGFloat,
						 for keypath: String) {

		let colorDelegate = LOTNumberValueCallback(number: value)
		setValueDelegate(colorDelegate, for: keypath)

	}

	/// Sets a closure that maps a progress to a float value for a given keypath
	public func setValue(for keypath: String,
						 _ valueCallback: @escaping (CGFloat) -> CGFloat) {

		let colorDelegate = LOTNumberBlockCallback { [unowned self] frame, _, _, _, _, _, _ -> CGFloat in

			let sceneModel = self.sceneModel
			let start = CGFloat(sceneModel?.startFrame?.floatValue ?? 0)
			let end = CGFloat(sceneModel?.endFrame?.floatValue ?? 0)

			let progress = min(max(0, (frame - start) / (end - start)), 1)

			return valueCallback(progress)

		}

		setValueDelegate(colorDelegate, for: keypath)

	}


	// MARK: CGSize Value

	/// Sets a size for a given keypath
	public func setSize(_ size: CGSize,
						for keypath: String) {

		let sizeDelegate = LOTSizeValueCallback(size: size)
		setValueDelegate(sizeDelegate, for: keypath)

	}

	/// Sets a closure that maps a progress to a size for a given keypath
	public func setSize(for keypath: String,
						_ sizeCallback: @escaping (CGFloat) -> CGSize) {

		let sizeDelegate = LOTSizeBlockCallback { [unowned self] frame, _, _, _, _, _, _ -> CGSize in

			let sceneModel = self.sceneModel
			let start = CGFloat(sceneModel?.startFrame?.floatValue ?? 0)
			let end = CGFloat(sceneModel?.endFrame?.floatValue ?? 0)

			let progress = min(max(0, (frame - start) / (end - start)), 1)

			return sizeCallback(progress)

		}

		setValueDelegate(sizeDelegate, for: keypath)

	}


	// MARK: CGPoint Value

	/// Sets a point for a given keypath
	public func setPoint(_ point: CGPoint,
						 for keypath: String) {

		let pointDelegate = LOTPointValueCallback.withPointValue(point)
		setValueDelegate(pointDelegate, for: keypath)

	}

	/// Sets a closure that maps a progress to a point for a given keypath
	public func setPoint(for keypath: String,
						 _ pointCallback: @escaping (CGFloat) -> CGPoint) {

		let pointDelegate = LOTPointBlockCallback { [unowned self] frame, _, _, _, _, _, _ -> CGPoint in

			let sceneModel = self.sceneModel
			let start = CGFloat(sceneModel?.startFrame?.floatValue ?? 0)
			let end = CGFloat(sceneModel?.endFrame?.floatValue ?? 0)

			let progress = min(max(0, (frame - start) / (end - start)), 1)

			return pointCallback(progress)

		}

		setValueDelegate(pointDelegate, for: keypath)

	}


	// MARK: UIBezierPath Value

	/// Sets a path for a given keypath
	public func setPath(_ path: UIBezierPath,
						for keypath: String) {

		let pathDelegate = LOTPathValueCallback(path: path.cgPath)
		setValueDelegate(pathDelegate, for: keypath)

	}

	/// Sets a closure that maps a progress to a path for a given keypath
	public func setPath(for keypath: String,
						_ pathCallback: @escaping (CGFloat) -> UIBezierPath) {

		let pathDelegate = LOTPathBlockCallback { [unowned self] frame, _, _, _ -> Unmanaged<CGPath> in

			let sceneModel = self.sceneModel
			let start = CGFloat(sceneModel?.startFrame?.floatValue ?? 0)
			let end = CGFloat(sceneModel?.endFrame?.floatValue ?? 0)

			let progress = min(max(0, (frame - start) / (end - start)), 1)

			return Unmanaged<CGPath>.passRetained(pathCallback(progress).cgPath)

		}

		setValueDelegate(pathDelegate, for: keypath)

	}


	// MARK: UIColor Value

	/// Sets a color for a given keypath
	public func setColor(_ color: UIColor,
						 for keypath: String) {

		let colorDelegate = LOTColorValueCallback(color: color.cgColor)
		setValueDelegate(colorDelegate, for: keypath)

	}

	/// Sets a closure that maps a progress to a color for a given keypath
	public func setColor(for keypath: String,
						 _ colorCallback: @escaping (CGFloat) -> UIColor) {

		let colorDelegate = LOTColorBlockCallback { [unowned self] frame, _, _, _, _, _, _ -> Unmanaged<CGColor> in

			let sceneModel = self.sceneModel
			let start = CGFloat(sceneModel?.startFrame?.floatValue ?? 0)
			let end = CGFloat(sceneModel?.endFrame?.floatValue ?? 0)

			let progress = min(max(0, (frame - start) / (end - start)), 1)

			return Unmanaged.passRetained(colorCallback(progress).cgColor)

		}

		setValueDelegate(colorDelegate, for: keypath)

	}



	// MARK: - Helpers

	private func setValueDelegate<T: NSObject & LOTValueDelegate>(_ delegate: T,
								  for keypath: String) {

		delegates[keypath] = delegate
		setValueDelegate(delegate, for: .init(string: keypath))

	}

}



private var key: UInt8 = 0

extension LOTAnimationView {

	/// Holds Animation view's delegates
	private var delegates: [String: NSObject] {
		get {
			if let delegates = objc_getAssociatedObject(self, &key) as? [String: NSObject] { return delegates }
			else {
				let delegates = [String: NSObject]()
				objc_setAssociatedObject(self, &key, delegates, .OBJC_ASSOCIATION_RETAIN)
				return delegates
			}
		}
		set {
			objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}

}
