//
//  CarouselCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit

final class CarouselCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var model: CarouselModel?
    private var savedModel: CarouselModel?
    private var savedPage: Int = 0
    private var timer: Timer?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.register(CarouselItemCell.self, forCellWithReuseIdentifier: CarouselItemCell.reuseIdentifier)
        return cv
    }()

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    private var pageControlBelowConstraints: [NSLayoutConstraint] = []
    private var pageControlInsideConstraints: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])

        pageControlBelowConstraints = [
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]

        pageControlInsideConstraints = [
            pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ]
    }

    public func configure(with model: CarouselModel) {
        self.model = model

        // Setup page control colors
        pageControl.currentPageIndicatorTintColor = model.currentPageDotColor ?? .systemBlue
        pageControl.pageIndicatorTintColor = model.pageDotColor ?? .systemGray3

        if savedModel != model {
            savedModel = model
            collectionView.reloadData()
        }

        let index = min(savedPage, model.items.count - 1)
        let path = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: false)
        }

        pageControl.numberOfPages = model.items.count
        pageControl.currentPage = index

        NSLayoutConstraint.deactivate(pageControlBelowConstraints)
        NSLayoutConstraint.deactivate(pageControlInsideConstraints)

        switch model.paginationPlacement {
        case .below: NSLayoutConstraint.activate(pageControlBelowConstraints)
        case .inside: NSLayoutConstraint.activate(pageControlInsideConstraints)
        }

        timer?.invalidate()
        if model.autoPlayInterval > 0, model.items.count > 1 {
            timer = Timer.scheduledTimer(withTimeInterval: model.autoPlayInterval, repeats: true) { [weak self] _ in
                self?.scrollToNext()
            }
        }
    }

    private func scrollToNext() {
        guard let model = model, model.items.count > 1 else { return }

        let currentPage = savedPage
        let nextItem = (currentPage + 1) % model.items.count

        switch model.transitionStyle {
        case .fade:
            fadeTransitionToPage(nextItem)
        case .slideLeft:
            slideTransitionToPage(nextItem, direction: .left)
        case .slideRight:
            slideTransitionToPage(nextItem, direction: .right)
        default:
            let indexPath = IndexPath(item: nextItem, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            updatePageControlManually(nextItem)
        }
    }

    private func fadeTransitionToPage(_ page: Int) {
        guard let model = model else { return }
        guard let currentCell = collectionView.visibleCells.first else { return }
        let snapshot = currentCell.snapshotView(afterScreenUpdates: false)
        snapshot?.frame = currentCell.frame

        if let snapshot = snapshot {
            collectionView.addSubview(snapshot)
        }

        let indexPath = IndexPath(item: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)

        UIView.animate(withDuration: 0.4, animations: {
            snapshot?.alpha = 0
        }, completion: { _ in
            snapshot?.removeFromSuperview()
            self.updatePageControlManually(page)
        })
    }

    private enum SlideDirection {
        case left, right
    }

    private func slideTransitionToPage(_ page: Int, direction: SlideDirection) {
        guard let model = model else { return }

        let transition = CATransition()
        transition.type = .push
        transition.subtype = direction == .left ? .fromRight : .fromLeft
        transition.duration = 0.35
        collectionView.layer.add(transition, forKey: kCATransition)

        let indexPath = IndexPath(item: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        updatePageControlManually(page)
    }

    private func updatePageControlManually(_ page: Int) {
        savedPage = page
        pageControl.currentPage = page
    }

    // MARK: ScrollView Delegate

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControlFromScroll()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageControlFromScroll()
    }

    private func updatePageControlFromScroll() {
        let pageWidth = collectionView.frame.width
        let fractionalPage = collectionView.contentOffset.x / pageWidth
        let page = Int(round(fractionalPage))
        guard let model = model, page < model.items.count else { return }
        updatePageControlManually(page)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
    }

    // MARK: Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselItemCell.reuseIdentifier, for: indexPath) as? CarouselItemCell,
            let item = model?.items[indexPath.item]
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: item, contentMode: model?.imageContentMode ?? .scaleAspectFill, hideText: model?.hideText ?? false)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model?.items[indexPath.item].didTap?()
    }
}

