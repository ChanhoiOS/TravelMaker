//
//  AroundDetailView.swift
//  TravelMaker
//
//  Created by 이찬호 on 10/30/23.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import ImageSlideshow
import Kingfisher

class AroundDetailView: UIViewController {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var imageSlide: ImageSlideshow!
    
    var detailData: AroundData?

    override func viewDidLoad() {
        super.viewDidLoad()

        setScrollView()
        setImageSlide()
    }

    func setScrollView() {
        scrollView = UIScrollView()
            .then {
                self.view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(44)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-69)
                }
            }
            .then {
                contentView = UIView()
                $0.addSubview(contentView)
                contentView.translatesAutoresizingMaskIntoConstraints = false
                contentView.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.left.right.equalTo(self.view)
                }
            }
    }
    
    func setImageSlide() {
        imageSlide = ImageSlideshow()
            .then {
                contentView.addSubview($0)
                
                $0.snp.makeConstraints { make in
                    make.top.left.right.equalToSuperview()
                    make.height.equalTo(234)
                }
            }
            .then {
                $0.contentScaleMode = .scaleAspectFill
                
                if let imagesPath = detailData?.imagesPath {
                    $0.setImageInputs(getImageInputs(imagePaths: imagesPath))
                    $0.slideshowInterval = 3
                    $0.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
                }
            }
    }
    

}

extension AroundDetailView {
    func getImageInputs(imagePaths: [String]) -> [KFSource] {
        let sources = imagePaths.map {
            KFSource(urlString: Apis.imageUrl + $0)!
        }
        print("source: ", sources)
        return sources
    }
}
