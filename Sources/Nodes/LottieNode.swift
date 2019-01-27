//
//  LottieNode.swift
//  LottieXtend-iOS
//
//  Created by José Donor on 18/11/2018.
//

import AsyncDisplayKit
import Lottie
import ReactiveSwift
import ReactiveSwifty



public final class LottieNode: ASDisplayNode {

	// MARK: Views

	var lottieView: LOTAnimationView?


	// MARK: Properties

    /// Node disposable
    public lazy var disposable = CompositeDisposable()
    // Queue
	private lazy var queue = QueueScheduler(qos: .userInitiated, name: hexAddress(self))



	// MARK: - Initialize

    public override init() {
        super.init()
		setViewBlock { [unowned self] in

            let lottieView = LOTAnimationView()
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

			self.displayVisual()

			return container
		}
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

		let visual = self.visual
		self.visual = visual

		queue.queue.async { self.bindInputs() }
    }

    public override func didEnterDisplayState() {
        super.didEnterDisplayState()

		if disposable.isDisposed { disposable = .init() }

        displayVisual()
        queue.queue.async { self.bindInputs() }
    }

    public override func didExitDisplayState() {
        super.didExitDisplayState()

		inputs.reset()
		outputs.reset()
		disposable.dispose()
    }



	// MARK: - Inputs

	public struct Inputs {

		/// File containing animation or URL containing animation
		public let source = MutableProperty<((name: String, bundle: Bundle)?, URL?)>((nil, nil))

		/// Plays animation
		public let play = MutableActionProperty<()>()
		/// Plays animation on a given section
		public let playSection = MutableActionProperty<(from: CGFloat?, to: CGFloat)>()
		/// Pauses animation
		public let pause = MutableActionProperty<()>()
		/// Stops animation
		public let stop = MutableActionProperty<()>()

		/// Sets animation progress
		public let progress = MutableProperty<CGFloat>(0)

        fileprivate func reset() {
            play.reset()
            playSection.reset()
            pause.reset()
			stop.reset()
			progress.swap(0)
        }

	}


	public lazy var inputs = Inputs()

	private func bindInputs() {

        disposable += inputs.source.producer
            .observe(on: QueueScheduler.main)
            .startWithValues { [weak self] tuple in

				let (file, url) = tuple

				guard
					let self = self ,
					file != nil || url != nil
					else { return }


				let lottieView: LOTAnimationView

				if let url = url { lottieView = .init(contentsOf: url) }
				else { lottieView = .init(name: file!.name, bundle: file!.bundle) }

				self.clearLottieView()
				self.setupLottieView(lottieView)
				self.addLottieView(lottieView)

            }

		disposable += inputs.play.producer
            .observe(on: QueueScheduler.main)
			.startWithValues { [weak self] _ in
				self?.lottieView?.play { [weak self] in self?.didStopAnimation(isComplete: $0) }
				self?.outputs._isAnimating.swap(true)
			}

		disposable += inputs.playSection.producer
            .observe(on: QueueScheduler.main)
			.startWithValues { [weak self] start, end in

                let progress = self?.lottieView?.animationProgress ?? 0

				self?.lottieView?.play(fromProgress: start ?? progress, toProgress: end) { [weak self] in
                    self?.didStopAnimation(isComplete: $0)
				}

				self?.outputs._isAnimating.swap(true)

			}

		disposable += inputs.pause.producer
            .observe(on: QueueScheduler.main)
			.startWithValues { [weak self] _ in
				self?.lottieView?.pause()
				self?.outputs._isAnimating.swap(false)
			}

		disposable += inputs.stop.producer
            .observe(on: QueueScheduler.main)
			.startWithValues { [weak self] _ in
				self?.lottieView?.stop()
				self?.outputs._isAnimating.swap(false)
			}

		disposable += inputs.progress.producer
            .observe(on: QueueScheduler.main)
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
        public var wasStopped: ActionProperty<Bool> { return .init(self._wasStopped) }
        fileprivate let _wasStopped = MutableActionProperty<Bool>()

		fileprivate func reset() {
			_wasStopped.reset()
		}

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
		didSet { needsDisplay = needsDisplay || visual != oldValue }
	}

	private var needsDisplay = true

	public func displayVisual() {
		guard needsDisplay else { return }
		needsDisplay = false

        if let lottieView = lottieView {
            applyVisual(to: lottieView)
        }
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
