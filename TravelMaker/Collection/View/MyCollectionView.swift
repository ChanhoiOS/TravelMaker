//
//  MyCollectionView.swift
//  TravelMaker
//
//  Created by 이찬호 on 2023/09/13.
//

import UIKit
import Moya
import PinLayout
import FlexLayout

class MyCollectionView: UIViewController {

    let flexView = UIView()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "컬렉션"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()
    
    private let recommendListView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let mySpaceListView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let myRouteListView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let recommendImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "collection_recommend")
        return imageView
    }()
    
    private let mySpaceImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "collection_mySpace")
        return imageView
    }()
    
    private let myRouteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "collection_myRoute")
        return imageView
    }()
    
    private let recommendTitle: UILabel = {
        let label = UILabel()
        label.text = "추천 저장목록"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 18)
        return label
    }()
    
    private let mySpaceTitle: UILabel = {
        let label = UILabel()
        label.text = "내 장소목록"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 18)
        return label
    }()
    
    private let myRouteTitle: UILabel = {
        let label = UILabel()
        label.text = "나만의 노선"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 18)
        return label
    }()
    
    private let recommendCount: UILabel = {
        let label = UILabel()
        label.text = "0개"
        label.textColor = Colors.COLLECTION_COUNT_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let mySpaceCount: UILabel = {
        let label = UILabel()
        label.text = "0개"
        label.textColor = Colors.COLLECTION_COUNT_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let myRouteCount: UILabel = {
        let label = UILabel()
        label.text = "0개"
        label.textColor = Colors.COLLECTION_COUNT_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private let recommendArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "collection_detail_arrow")
        return imageView
    }()
    
    private let mySpaceArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "collection_detail_arrow")
        return imageView
    }()
    
    private let myRouteArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "collection_detail_arrow")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFlexView()
        
        setGesture()
    }
    
    override func viewDidLayoutSubviews() {
        
        flexView.pin.all(view.pin.safeArea)
        flexView.flex.layout()
    }
    
    func setFlexView() {
        view.addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem().direction(.row).height(59).alignItems(.center).justifyContent(.center).define { flex in
                flex.addItem(pageTitle)
            }
            
            flex.addItem().backgroundColor(Colors.DESIGN_BACKGROUND).define { flex in
                
                flex.addItem(recommendListView).direction(.row).alignItems(.center).justifyContent(.spaceBetween).marginTop(32).height(91).marginHorizontal(24).backgroundColor(.white).define { flex in
                    
                    flex.addItem().width(88).define { flex in
                        flex.addItem(recommendImage).marginLeft(20).height(48).width(48).cornerRadius(24)
                    }
                    
                    flex.addItem().width(120).define { flex in
                        flex.addItem().define { flex in
                            flex.addItem(recommendTitle).marginTop(24)
                        }
                        flex.addItem().define { flex in
                            flex.addItem(recommendCount).marginBottom(24)
                        }
                    }.grow(3)
                    
                    flex.addItem().define { flex in
                        flex.addItem(recommendArrow).width(26).height(26)
                    }.grow(1)
                }
                
                flex.addItem(mySpaceListView).direction(.row).alignItems(.center).justifyContent(.spaceBetween).marginTop(32).height(91).marginHorizontal(24).backgroundColor(.white).define { flex in
                    
                    flex.addItem().width(88).define { flex in
                        flex.addItem(mySpaceImage).marginLeft(20).height(48).width(48).cornerRadius(24)
                    }
                    
                    flex.addItem().width(120).define { flex in
                        flex.addItem().define { flex in
                            flex.addItem(mySpaceTitle).marginTop(24)
                        }
                        flex.addItem().define { flex in
                            flex.addItem(mySpaceCount).marginBottom(24)
                        }
                    }.grow(3)
                    
                    flex.addItem().define { flex in
                        flex.addItem(mySpaceArrow).width(26).height(26)
                    }.grow(1)
                }
                
                flex.addItem(myRouteListView).direction(.row).alignItems(.center).justifyContent(.spaceBetween).marginTop(32).height(91).marginHorizontal(24).backgroundColor(.white).define { flex in
                    
                    flex.addItem().width(88).define { flex in
                        flex.addItem(myRouteImage).marginLeft(20).height(48).width(48).cornerRadius(24)
                    }
                    
                    flex.addItem().width(120).define { flex in
                        flex.addItem().define { flex in
                            flex.addItem(myRouteTitle).marginTop(24)
                        }
                        flex.addItem().define { flex in
                            flex.addItem(myRouteCount).marginBottom(24)
                        }
                    }.grow(3)
                    
                    flex.addItem().define { flex in
                        flex.addItem(myRouteArrow).width(26).height(26)
                    }.grow(1)
                }
            }.grow(2)
            
            flex.addItem().backgroundColor(Colors.DESIGN_BACKGROUND).grow(1)
        }
        
    }

}

extension MyCollectionView {
    func setGesture() {
        let myRecommend = UITapGestureRecognizer(target: self, action: #selector(goMyRecommendList))
        recommendListView.addGestureRecognizer(myRecommend)
        recommendListView.isUserInteractionEnabled = true
        
        let mySpace = UITapGestureRecognizer(target: self, action: #selector(goMySpaceList))
        mySpaceListView.addGestureRecognizer(mySpace)
        mySpaceListView.isUserInteractionEnabled = true
        
        let myRoute = UITapGestureRecognizer(target: self, action: #selector(goMyRoute))
        myRouteListView.addGestureRecognizer(myRoute)
        myRouteListView.isUserInteractionEnabled = true
    }
    
    @objc func goMyRecommendList(sender: UITapGestureRecognizer) {
        let vc = MyRecommendListView(nibName: "MyRecommendListView", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goMySpaceList(sender: UITapGestureRecognizer) {
        let vc = MyRouteView(nibName: "MyRouteView", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goMyRoute(sender: UITapGestureRecognizer) {
        let vc = MyRouteView(nibName: "MyRouteView", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
