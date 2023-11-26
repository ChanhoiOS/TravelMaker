//
//  OnboardingView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/12.
//

import UIKit

class OnboardingView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    var contentText = ["내 손으로 직접 만드는\n여행 노선", "내 주변의 장소들을\n한눈에 확인", "여행갈땐?\nTravelMaker"]
    var contentImage = ["onboarding_bag.png", "onboarding_map.png", "onboarding_logo.png"]
    
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        setCollectionView()
        setUI()
    }
    
    @IBAction func finish(_ sender: Any) {
        self.dismiss(animated: true) {
            UserDefaultsManager.shared.showOnboarding = true
        }
    }
    
    private func setUI() {
        pageControl.isUserInteractionEnabled = false
        startButton.titleLabel?.font =  UIFont(name: "SUIT-Bold", size: 20)
    }
        
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let nib = UINib(nibName: "OnboardingCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "OnboardingCell")
    }
}

extension OnboardingView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell else { return UICollectionViewCell() }
        cell.contentLabel.text = contentText[indexPath.row]
        cell.contentImage.image = UIImage(named: contentImage[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

// MARK: - CollectionView Delegate Flow Layout
extension OnboardingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 400)
    }
}
