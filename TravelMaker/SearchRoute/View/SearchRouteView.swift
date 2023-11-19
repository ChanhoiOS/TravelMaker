//
//  SearchRouteView.swift
//  TravelMaker
//
//  Created by 이찬호 on 11/19/23.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

class SearchRouteView: BaseViewController, StoryboardView {
    var headerView: UIView!
    var headerLine: UIView!
    var middleLine: UIView!
    var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    let reactor = SearchRouteViewReactor()
    var searchResult: SearchRouteModel?
    
    var latitude = 37.50518440330725
    var longitude = 127.05485569769449
    
    var tabBarHeight: Int = 83
    
    private let backBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header_back_btn.png")
        return imageView
    }()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "장소 검색"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 20)
        return label
    }()
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력해 주세요."
        textField.font = UIFont(name: "SUIT-Bold", size: 18)
        textField.backgroundColor = Colors.TEXTFIELD_BACKGROUND
        return textField
    }()
    
    private let recommendTitle: UILabel = {
        let label = UILabel()
        label.text = "추천 장소"
        label.textColor = Colors.DESIGN_BLACK
        label.font = UIFont(name: "SUIT-Bold", size: 18)
        return label
    }()
    
    private let recommendText: UILabel = {
        let label = UILabel()
        label.text = "현재 위치로부터의 거리가 표시됩니다."
        label.textColor = Colors.DESIGN_GRAY
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        return label
    }()
    
    private lazy var confirmBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.DESIGN_GRAY
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Bold", size: 16)
        //button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initHeader()
        initTextField()
        getHeight()
        initRegisterView()
        setTableView()
        
        setGesture()
    }
    
    func initHeader() {
        headerView = UIView()
            .then {
                self.view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(44)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(59)
                }
            }
        
        headerView.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.width.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        headerView.addSubview(pageTitle)
        pageTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        headerLine = UIView()
            .then {
                self.view.addSubview($0)
                $0.backgroundColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(headerView.snp.bottom).offset(0)
                    make.height.equalTo(0.8)
                }
            }
    }
    
    func initTextField() {
        self.view.addSubview(textField)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftView?.tintColor = Colors.TEXTFIELD_BACKGROUND
        textField.leftViewMode = .always
        
        let image = UIImage(named: "search_icon")
        textField.withImage("right", image!, .clear)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(headerLine.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(recommendTitle)
        recommendTitle.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
        }
        
        self.view.addSubview(recommendText)
        recommendText.snp.makeConstraints { make in
            make.top.equalTo(recommendTitle.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(24)
        }
        
        middleLine = UIView()
            .then {
                self.view.addSubview($0)
                $0.backgroundColor = Colors.GRAY_LINE
                $0.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(24)
                    make.right.equalToSuperview().offset(-24)
                    make.top.equalTo(recommendText.snp.bottom).offset(16)
                    make.height.equalTo(0.8)
                }
        }
    }
    
    func initRegisterView() {
        self.view.addSubview(confirmBtn)
        
        confirmBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-tabBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(69)
        }
    }
    
    func getHeight() {
        tabBarHeight = Int(self.tabBarController?.tabBar.frame.height ?? 49.0)
    }
}

extension SearchRouteView {
    func setTableView() {
        tableView = UITableView()
            .then {
                self.view.addSubview($0)
                
                $0.delegate = self
                $0.dataSource = self
                
                $0.snp.makeConstraints { make in
                    make.top.equalTo(middleLine.snp.bottom).offset(16)
                    make.left.equalToSuperview().offset(24)
                    make.right.equalToSuperview().offset(-24)
                    make.bottom.equalTo(confirmBtn.snp.top).offset(-16)
                }
            }
            .then {
                $0.register(SearchRouteCell.self, forCellReuseIdentifier: SearchRouteCell.reuseIdentifier)
                $0.rowHeight = 67
                $0.separatorStyle = .none
            }
    }
}

extension SearchRouteView {
    func bind(reactor: SearchRouteViewReactor) {
        textField.rx.text
            .skip(1)
            .distinctUntilChanged()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { SearchRouteViewReactor.Action.search($0, self.latitude, self.longitude) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.action.onNext(.location(()))
        
        reactor.state
            .map { $0.locationResult }
            .bind(onNext: {[weak self] result in
                self?.latitude = result?.latitude ?? 37.50518440330725
                self?.longitude = result?.longitude ?? 127.05485569769449
            })
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.searchResult }
            .bind(onNext: { [weak self] result in
                self?.searchResult = result
                if let _ = result?.documents {
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SearchRouteView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.documents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRouteCell", for:  indexPath) as! SearchRouteCell
        
        cell.selectionStyle = .none
        
        cell.spaceName.text = searchResult?.documents?[indexPath.row].placeName ?? ""
        cell.spaceAddress.text = searchResult?.documents?[indexPath.row].addressName ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectView = SearchRouteSelectView(nibName: "SearchRouteSelectView", bundle: nil)
        selectView.longitude = searchResult?.documents?[indexPath.row].x ?? "37.50518440330725"
        selectView.latitude = searchResult?.documents?[indexPath.row].y ?? "127.05485569769449"
        selectView.placeName = searchResult?.documents?[indexPath.row].placeName ?? ""
        selectView.address = searchResult?.documents?[indexPath.row].addressName ?? ""
        selectView.categoryName = searchResult?.documents?[indexPath.row].categoryName ?? ""
        self.navigationController?.pushViewController(selectView, animated: true)
    }
}

extension SearchRouteView {
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backBtnAction))
        backBtn.addGestureRecognizer(tapGesture)
        backBtn.isUserInteractionEnabled = true
    }
    
    @objc func backBtnAction(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}
