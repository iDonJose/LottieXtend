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

	var lottieView: LOTAnimationView?


	// MARK: Properties

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

            var lottieView: LOTAnimationView


            if let (name, bundle) = self.inputs.file.value {
                lottieView = LOTAnimationView(name: name, bundle: bundle)
            }
            else if let url = self.inputs.url.value {
                lottieView = LOTAnimationView(contentsOf: url)
            }
            else {
                lottieView = LOTAnimationView()
            }


            self.setupLottieView(lottieView)
            self.lottieView = lottieView

            defer {
                // Starts animation if needed
                if self.visual.autoStart {
                    lottieView.play { [weak self] in self?.didStopAnimation(isComplete: $0) }
                    self.outputs._isAnimating.swap(true)
                }
            }


            let container = UIView()
            container.addSubview(lottieView)

			return container
		}

		defer { visual = .init() }

	}


    private func setupLottieView(_ lottieView: LOTAnimationView) {

        lottieView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        applyVisual(to: lottieView)

    }

    private func addLottieView(_ lottieView: LOTAnimationView) {

        self.lottieView = lottieView

        lottieView.frame = view.bounds
        view.addSubview(lottieView)

        // Layouts
        invalidateCalculatedLayout()
        supernode?.setNeedsLayout()

        // Starts animation if needed
        if visual.autoStart {
            lottieView.play { [weak self] in self?.didStopAnimation(isComplete: $0) }
            outputs._isAnimating.swap(true)
        }

    }

    private func clearLottieView() {

        lottieView?.stop()
        lottieView?.removeFromSuperview()
        lottieView = nil
        outputs._isAnimating.swap(false)

    }



	// MARK: - Lifecycle

    public override func didLoad() {
		super.didLoad()
		displayVisual()
		queue.queue.async { self.bindInputs() }
	}



	// MARK: - Inputs

	public struct Inputs {

        /// File containing animation
        public let file = MutableProperty<(name: String, bundle: Bundle)?>(nil)
        /// URL containing animation
        public let url = MutableProperty<URL?>(nil)

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

        inputs.file.producer
            .start(on: UIScheduler())
            .skipNil()
            .startWithValues { [weak self] name, bundle in
                let lottieView = LOTAnimationView(name: name, bundle: bundle)
                self?.clearLottieView()
                self?.setupLottieView(lottieView)
                self?.addLottieView(lottieView)
            }

        inputs.url.producer
            .start(on: UIScheduler())
            .skipNil()
            .startWithValues { [weak self] url in
                let lottieView = LOTAnimationView(contentsOf: url)
                self?.clearLottieView()
                self?.setupLottieView(lottieView)
                self?.addLottieView(lottieView)
            }


		inputs.play.producer
			.start(on: UIScheduler())
			.skipNil()
			.startWithValues { [weak self] _ in
				self?.lottieView?.play { [weak self] in self?.didStopAnimation(isComplete: $0) }
				self?.outputs._isAnimating.swap(true)
			}

		inputs.playSection.producer
			.start(on: UIScheduler())
			.skipNil()
			.startWithValues { [weak self] start, end in

                let progress = self?.lottieView?.animationProgress ?? 0

				self?.lottieView?.play(fromProgress: start ?? progress, toProgress: end) { [weak self] in
                    self?.didStopAnimation(isComplete: $0)
                }

				self?.outputs._isAnimating.swap(true)

			}

		inputs.pause.producer
			.start(on: UIScheduler())
			.skipNil()
			.startWithValues { [weak self] _ in
				self?.lottieView?.pause()
				self?.outputs._isAnimating.swap(false)
			}

		inputs.stop.producer
			.start(on: UIScheduler())
			.skipNil()
			.startWithValues { [weak self] _ in
				self?.lottieView?.stop()
				self?.outputs._isAnimating.swap(false)
			}

		inputs.progress.producer
			.start(on: UIScheduler())
			.skipNil()
            .skipRepeats()
			.startWithValues { [weak self] in
				self?.lottieView?.animationProgress = $0
				self?.outputs._isAnimating.swap(false)
			}

	}



	// MARK: - Outputs

	public struct Outputs {

        /// Animation is running
		public var isAnimating: Property<Bool> { return .init(self._isAnimating) }
		fileprivate let _isAnimating = MutableProperty<Bool>(false)

        /// Animation was stopped, forwarding wether animation was not interrupted and went through a the targeted progress
        public var wasStopped: Property<Bool?> { return .init(self._wasStopped) }
        fileprivate let _wasStopped = MutableProperty<Bool?>(nil)

	}


	public lazy var outputs = Outputs()



    // MARK: - Methods

    private func didStopAnimation(isComplete: Bool) {
        outputs._isAnimating.swap(false)
        outputs._wasStopped.swap(isComplete)
    }



	// MARK: - Layout

	public override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {

		return lottieView?.sceneModel?.compBounds.size
			?? constrainedSize
	}



	// MARK: - Visual

	public var visual = Visual() {
		didSet { needsDisplay = visual != oldValue }
	}

	private var needsDisplay = false

	public func displayVisual() {

		guard needsDisplay else { return }
		needsDisplay = false

		guard let lottieView = lottieView else { return }

		applyVisual(to: lottieView)

	}

    private func applyVisual(to lottieView: LOTAnimationView) {
        lottieView.loopAnimation = visual.autoRepeats
        lottieView.autoReverseAnimation = visual.isReversed
        lottieView.animationSpeed = visual.speed
        lottieView.shouldRasterizeWhenIdle = visual.shouldRasterize
        lottieView.contentMode = visual.contentMode
    }


	public struct Visual: Equatable {

		/// Animation will start automatically
		public var autoStart: Bool
		/// Animation will repeat indefinitely
		public var autoRepeats: Bool
		/// Animation will be reversed when repeating
		public var isReversed: Bool
		/// Animation's speed
		public var speed: CGFloat
		/// Layer will be rasterized when animation is paused
		public var shouldRasterize: Bool
		/// Animation view's content mode
		public var contentMode: UIView.ContentMode


		// MARK: - Initialize

		public init() {
			self.init(autoStart: false)
		}

		public init(autoStart: Bool = false,
					autoRepeats: Bool = false,
					isReversed: Bool = false,
					speed: CGFloat = 1,
					shouldRasterize: Bool = true,
					contentMode: UIView.ContentMode = .scaleAspectFit) {

			self.autoStart = autoStart
			self.autoRepeats = autoRepeats
			self.isReversed = isReversed
			self.speed = speed
			self.shouldRasterize = shouldRasterize
			self.contentMode = contentMode

		}

	}

}
