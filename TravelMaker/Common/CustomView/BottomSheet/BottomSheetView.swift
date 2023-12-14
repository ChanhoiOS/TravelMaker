//
//  BottomSheetView.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/31/23.
//

import UIKit
import SnapKit
import CoreLocation

protocol SelectRecommendData {
    func selectSpace(_ data: RecommendAllData?)
}

final class BottomSheetView: PassThroughView {
    var recommendAllModel: ResponseRecommendALLModel?
    var delegate: SelectRecommendData?
    var currentGps: CLLocationCoordinate2D?
    
    enum Mode {
        case tip
        case full
    }

    private enum Const {
        static let duration = 0.5
        static let cornerRadius = 12.0
        static let barViewTopSpacing = 16.0
        static let barViewSize = CGSize(width: UIScreen.main.bounds.width * 0.07, height: 3.0)
        static let bottomSheetRatio: (Mode) -> Double = { mode in
            switch mode {
                case .tip:
                    return 0.87 // 위에서 부터의 값 (밑으로 갈수록 값이 커짐)
                case .full:
                    return 0.59
            }
        }
        
        static let bottomSheetYPosition: (Mode) -> Double = { mode in
            Self.bottomSheetRatio(mode) * UIScreen.main.bounds.height
        }
    }
      
    let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let barView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.DESIGN_WHITE
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var viewTitle: UILabel = {
        let label = UILabel()
        label.text = "추천 장소"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 22)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .white

        return view
    }()

    var mode: Mode = .tip {
        didSet {
            switch self.mode {
            case .tip:
                break
            case .full:
                break
            }
            
            self.updateConstraint(offset: Const.bottomSheetYPosition(self.mode))
        }
    }
    
    var bottomSheetColor: UIColor? {
        didSet { self.bottomSheetView.backgroundColor = self.bottomSheetColor }
    }
    
    var barViewColor: UIColor? {
        didSet { self.barView.backgroundColor = self.barViewColor }
    }
    
    required init?(coder: NSCoder, _ data: ResponseRecommendALLModel?, _ gps: CLLocationCoordinate2D?) {
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    init(frame: CGRect, _ data: ResponseRecommendALLModel?, _ gps: CLLocationCoordinate2D?) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.addGestureRecognizer(panGesture)
        
        self.bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bottomSheetView.layer.cornerRadius = Const.cornerRadius
        self.bottomSheetView.clipsToBounds = true
        self.bottomSheetView.layer.borderWidth = 0.5
        self.bottomSheetView.layer.borderColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        
        self.addSubview(self.bottomSheetView)
        self.bottomSheetView.addSubview(self.barView)
        
        self.bottomSheetView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Const.bottomSheetYPosition(.tip))
        }
        
        self.barView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(Const.barViewTopSpacing)
            $0.size.equalTo(Const.barViewSize)
        }
        
        self.bottomSheetView.addSubview(viewTitle)
        
        self.viewTitle.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(36)
        }
        
        self.bottomSheetView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.id)
        
        self.collectionView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(viewTitle.snp.bottom).offset(20)
            $0.height.equalTo(167)
        }
        
        recommendAllModel = data
        currentGps = gps
        collectionView.reloadData()
    }
    
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        let translationY = recognizer.translation(in: self).y
        let minY = self.bottomSheetView.frame.minY
        let offset = translationY + minY
        
        if Const.bottomSheetYPosition(.full)...Const.bottomSheetYPosition(.tip) ~= offset {
            self.updateConstraint(offset: offset)
            recognizer.setTranslation(.zero, in: self)
        }
        
        UIView.animate(
            withDuration: 0,
            delay: 0,
            options: .curveEaseOut,
            animations: self.layoutIfNeeded,
            completion: nil
        )
        
        guard recognizer.state == .ended else { return }
        
        UIView.animate(
            withDuration: Const.duration,
            delay: 0,
            options: .allowUserInteraction,
            animations: {
                self.mode = recognizer.velocity(in: self).y >= 0 ? Mode.tip : .full
            },
            completion: nil
        )
    }
    
    private func updateConstraint(offset: Double) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.bottomSheetView.snp.remakeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalToSuperview().inset(offset)
            }
            self.layoutIfNeeded()
        }, completion: nil)
       
    }
}

extension BottomSheetView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendAllModel?.data?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.id, for: indexPath)
        
        if let cell = cell as? RecommendCollectionViewCell {
            cell.model = recommendAllModel?.data?[indexPath.item]
            cell.distance.text = getDistance((LocationManager.shared.distance(currentGps, recommendAllModel?.data?[indexPath.item].latitude , recommendAllModel?.data?[indexPath.item].longitude))) + "km"
        }
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = Colors.DESIGN_WHITE.cgColor
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectSpace(recommendAllModel?.data?[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: collectionView.frame.height)
    }
}

extension BottomSheetView {
    func getDistance(_ distance: CLLocationDistance) -> String {
        let convertKm = distance / 1000
        let formattedDistance = String(format: "%.2f", convertKm)
        return formattedDistance
    }
}
