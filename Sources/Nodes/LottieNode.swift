//
//  LottieNode.swift
//  LottieXtend-iOS
//
//  Created by José Donor on 18/11/2018.
//

import AsyncDisplayKit
import Lottie
import ReactiveSwift



public final class LottieNode: ASDisplayNode {

	// MARK: Views

	var lottieView: LOTAnimationView!


	// MARK: Properties

	/// Will start animation automatically
	public var autoStart = false

	var pendingProperties: Properties! = .init()

	struct Properties {
		var autoRepeats = false
		var isReversed = false
		var speed: CGFloat = 1
		var shouldRasterize = true
		var contentMode: UIView.ContentMode = .scaleAspectFit
	}

	private lazy var queue = QueueScheduler(qos: .userInitiated, name: hexAddress(self))



	// MARK: - Initialize

	/// Initializes a new LottieNode.
	///
	/// - Parameters:
	///   - file: Name of the file containing the animation
	///   - bundle: Bundle
	///	  - autoStart: Will start animation automatically
	///   - setupView: Sets up animation view once initialized
	public init(file: String? = nil,
				bundle: Bundle = .main) {
		super.init()

		setViewBlock { [unowned self] in

			self.lottieView = LOTAnimationView()

			if let file = file {
				self.lottieView.setAnimation(file: file, bundle: bundle)
			}

			self.lottieView.shouldRasterizeWhenIdle = true

			self.lottieView.completionBlock = { [weak self] _ in
				self?.outputs._isAnimating.swap(false)
			}

			self.lottieView.loopAnimation = self.pendingProperties.autoRepeats
			self.lottieView.autoReverseAnimation = self.pendingProperties.isReversed
			self.lottieView.animationSpeed = self.pendingProperties.speed
			self.lottieView.shouldRasterizeWhenIdle = self.pendingProperties.shouldRasterize
			self.lottieView.contentMode = self.pendingProperties.contentMode

			if self.autoStart {
				self.lottieView.play()
				self.outputs._isAnimating.swap(true)
			}

			// Releases pendingProperties as is no more needed
			self.pendingProperties = nil

			return self.lottieView!
		}

	}



	// MARK: - Lifecycle

	public override func didEnterDisplayState() {
		super.didEnterDisplayState()
		queue.queue.async { self.bindInputs() }
	}



	// MARK: - Methods

	/// Changes animation source file and bundle.
	///
	/// - Parameters:
	///   - file: File name
	///   - bundle: Bundle
	public func setAnimation(file: String,
							 bundle: Bundle = .main) {

		lottieView.setAnimation(file: file, bundle: bundle)

		invalidateCalculatedLayout()
		supernode?.setNeedsLayout()

		if autoStart {
			lottieView.play()
			outputs._isAnimating.swap(true)
		}

	}



	// MARK: - Inputs

	public struct Inputs {

		/// Plays animation
		public let play = MutableProperty<()?>(nil)
		/// Plays animation on a given section
		public let playSection = MutableProperty<(from: CGFloat?, to: CGFloat)?>(nil)
		/// Pauses animation
		public let pause = MutableProperty<()?>(nil)
		/// Stops animation
		public let stop = MutableProperty<()?>(nil)

		/// Sets animation progress
		public let progress = MutableProperty<CGFloat?>(nil)

	}


	public lazy var inputs = Inputs()

	private func bindInputs() {

		inputs.play.producer
			.observe(on: UIScheduler())
			.skipNil()
			.startWithValues { [weak self] _ in
				self?.lottieView.play()
				self?.outputs._isAnimating.swap(true)
			}

		inputs.playSection.producer
			.observe(on: UIScheduler())
			.skipNil()
			.startWithValues { [weak self] start, end in
				guard let self = self else { return }

				if let start = start {
					self.lottieView.play(fromProgress: start, toProgress: end, withCompletion: nil)
				}
				else {
					self.lottieView.play(toProgress: end, withCompletion: nil)
				}

				self.outputs._isAnimating.swap(true)

			}

		inputs.pause.producer
			.observe(on: UIScheduler())
			.skipNil()
			.startWithValues { [weak self] _ in
				self?.lottieView.pause()
				self?.outputs._isAnimating.swap(false)
			}

		inputs.stop.producer
			.observe(on: UIScheduler())
			.skipNil()
			.startWithValues { [weak self] _ in
				self?.lottieView.stop()
				self?.outputs._isAnimating.swap(false)
			}

		inputs.progress.producer
			.observe(on: UIScheduler())
			.skipNil()
			.startWithValues { [weak self] in
				self?.lottieView.animationProgress = $0
				self?.outputs._isAnimating.swap(false)
			}

	}



	// MARK: - Outputs

	public struct Outputs {

		public var isAnimating: Property<Bool> { return .init(self._isAnimating) }
		fileprivate let _isAnimating = MutableProperty<Bool>(false)

	}


	public lazy var outputs = Outputs()



	// MARK: - Layout

	public override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {

		return lottieView.sceneModel?.compBounds.size
			?? constrainedSize
	}

}
