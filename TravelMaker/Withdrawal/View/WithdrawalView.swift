//
//  WithdrawalView.swift
//  HealthZZang
//
//  Created by 이찬호 on 2022/08/23.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class WithdrawalView: BaseViewController {
    
    var header: CommonHeader!
    var scrollView: UIScrollView!
    var contentView: UIView!
    var buttonView: UIView!
    var middleContainerView: UIView!
    var bottomContainerView: UIView!
    var pleaseContainerView: UIView!
    var collectionView: UICollectionView!
    var questionView: UIView!
    var bottomGrayView: UIView!
    var infoLabel: UILabel!
    var addInfoLabel: UILabel!
    var textView: UITextView!
    var nextBtn: BasicButton!
    
    let viewModel = WithdrawalViewModel()
    var disposeBag = DisposeBag()
    
    
    var questionList = ["제 기록을 삭제하려고 해요", "이용이 불편하고 장애가 많아요", "다른 커뮤니티 사이트가 더 좋아요", "사용빈도가 낮아요", "콘텐츠가 불만스러워요", "기타 사유"]
    var clickIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initRx()
        initTopView()
        initMiddleView()
        initCollectionView()
    }
    
    func initRx() {
        viewModel.output.responseDelete.subscribe(onNext: {[weak self] response in
            self?.goNextView()
        }, onError: {[weak self] error in
            print("error: ",error)
        })
        .disposed(by: disposeBag)
        
        viewModel.output.responseReason.subscribe(onNext: {[weak self] response in
            self?.deleteUser()
        }, onError: {[weak self] error in
            print("error: ",error)
        })
        .disposed(by: disposeBag)
    }
    
    func initTopView() {
        header = CommonHeaderBuilder()
            .setHeaderTitle("회원탈퇴")
            .setHeaderType(.normal)
            .build()
            .then {
                self.view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(self.view.topSafeAreaHeight)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(84)
                }
            }
        
        buttonView = UIView()
            .then {
                self.view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(100)
                    make.bottom.equalToSuperview().offset(-88)
                }
            }
           
        nextBtn = BasicButtonBuilder()
            .setActiveBackgroundColor(Colors.PRIMARY_BLUE)
            .setActiveFontColor(.white)
            .setDisabledBackgroundColor(Colors.PRIMARY_BLUE)
            .setDisabledFontColor(.white)
            .setFontSize(18)
            .setFontWeight(.bold)
            .setAnimationTimeInSec(0.15)
            .setCornerRadius(10)
            .setInitialTitle("회원탈퇴를 진행할게요.")
            .setDefaultStatus(.disabled)
            .build()
            .then {
                buttonView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-20)
                    make.bottom.equalToSuperview().offset(-20)
                    make.left.top.equalToSuperview().offset(20)
                }
            }
            .then {
                $0.onButtonTapped = { [weak self] in
                    self?.collectReason()
                }
            }
        
        scrollView = UIScrollView()
            .then {
                self.view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(header.snp.bottom).offset(0)
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(buttonView.snp.top).offset(0)
                }
            }
            .then {
                let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapKeyboardHide))
                singleTapGestureRecognizer.numberOfTapsRequired = 1
                singleTapGestureRecognizer.isEnabled = true
                singleTapGestureRecognizer.cancelsTouchesInView = false
                $0.addGestureRecognizer(singleTapGestureRecognizer)
            }
        
        contentView = UIView()
            .then {
                scrollView.addSubview($0)
                $0.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                    make.width.equalToSuperview()
                }
        }
        
        pleaseContainerView = UIView()
            .then {
                contentView.addSubview($0)
                $0.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.height.equalTo(100)
                }
            }
            .then {
                let pleasePhrases = UIView()
                $0.addSubview(pleasePhrases)
                pleasePhrases.layer.cornerRadius = 5
                pleasePhrases.backgroundColor = UIColor(red: 233.0/255.0, green: 240.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                pleasePhrases.snp.makeConstraints { make in
                    make.left.top.equalToSuperview().offset(20)
                    make.right.bottom.equalToSuperview().offset(-20)
                }

                let emojiImage = UIImageView()
                pleasePhrases.addSubview(emojiImage)
                emojiImage.image = UIImage(named: "withdrawal_emoji")
                emojiImage.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(29)
                    make.top.equalToSuperview().offset(18)
                    make.height.width.equalTo(24)
                }

                let phrases = UILabel()
                pleasePhrases.addSubview(phrases)
                phrases.text = "회원탈퇴를 다시 한 번 생각해주세요"
                phrases.font = UIFont(name: "SUIT-Bold", size: 18)
                phrases.textColor = UIColor(red: 48.0/255.0, green: 116.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                phrases.snp.makeConstraints { make in
                    make.left.equalTo(emojiImage.snp.right).offset(5)
                    make.top.equalToSuperview().offset(21)
                    make.bottom.equalToSuperview().offset(-21)
                    make.right.equalToSuperview().offset(-30)
                }
            }
    }
    
    func initMiddleView() {
        middleContainerView = UIView()
            .then {
                contentView.addSubview($0)
                $0.backgroundColor = .white
                $0.snp.makeConstraints { make in
                    make.top.equalTo(pleaseContainerView.snp.bottom).offset(0)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(530)
                }
            }
            .then {
                let label = UILabel()
                $0.addSubview(label)
                label.text = "탈퇴사유"
                label.font = UIFont(name: "SUIT-Regular", size: 18)
                label.textColor = UIColor(red: 98.0/255.0, green: 105.0/255.0, blue: 116.0/255.0, alpha: 1.0)
                
                label.snp.makeConstraints { make in
                    make.left.top.equalToSuperview().offset(20)
                }
            }
        
    }
     
    func initCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
     
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cellNib = UINib(nibName: "QuestionCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "QuestionCell")
        
        middleContainerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(58)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-27)
        }
        initBottomView()
    }
    
    func initBottomView() {
        bottomGrayView = UIView()
            .then {
                contentView.addSubview($0)
                $0.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(middleContainerView.snp.bottom).offset(0)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(20)
                }
            }
        
        bottomContainerView = UIView()
            .then {
                contentView.addSubview($0)
                $0.backgroundColor = .white
                $0.snp.makeConstraints { make in
                    make.top.equalTo(bottomGrayView.snp.bottom).offset(0)
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(420)
                }
            }
            .then {
                infoLabel = UILabel()
                $0.addSubview(infoLabel)
                infoLabel.text = "그 외 서비스에 개선되었으면 하는 내용을 자유롭게 적어주세요."
                infoLabel.font = UIFont(name: "SUIT-Regular", size: 18)
                infoLabel.textColor = UIColor(red: 98.0/255.0, green: 105.0/255.0, blue: 116.0/255.0, alpha: 1.0)
                infoLabel.numberOfLines = 0
                infoLabel.snp.makeConstraints { make in
                    make.left.top.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-20)
                }
            }
            .then {
                addInfoLabel = UILabel()
                $0.addSubview(addInfoLabel)
                addInfoLabel.text = "자세하게 적어주시면 서비스 개선에 큰 도움이 됩니다"
                addInfoLabel.font = UIFont(name: "SUIT-Regular", size: 14)
                addInfoLabel.textColor = UIColor(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
                addInfoLabel.numberOfLines = 0
                addInfoLabel.snp.makeConstraints { make in
                    make.top.equalTo(infoLabel.snp.bottom).offset(10)
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-20)
                }
            }
            .then {
                textView = UITextView(frame: CGRect(x: 20, y: 111, width: 335, height: 280))
                $0.addSubview(textView)
                textView.contentInsetAdjustmentBehavior = .automatic
                textView.center = self.view.center
                textView.textAlignment = NSTextAlignment.justified
                textView.textColor = .black
                textView.font = UIFont(name: "SUIT-Regular", size: 18)
                textView.backgroundColor = .white
                textView.layer.borderWidth = 1
                textView.layer.borderColor = CGColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
                
                textView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-20)
                    make.top.equalTo(addInfoLabel.snp.bottom).offset(20)
                    make.bottom.equalToSuperview().offset(-49)
                }
          
            }
    }
    
    func goNextView() {
        let vc = LoginView(nibName: "LoginView", bundle: nil)
        self.tabBarController?.navigationController?.offAllNamed(vc)
    }
    
    @objc func tapKeyboardHide() {
        self.view.endEditing(true)
    }
}

extension WithdrawalView {
    func collectReason() {
        var paramDic = [String: Any]()
        let reason = questionList[clickIndex]
        let improvements = textView.text ?? ""
        paramDic["outReason"] = reason
        paramDic["improvements"] = improvements
        
        self.viewModel.input.collectReason.onNext(paramDic)
    }
    
    func deleteUser() {
        var paramDic = [String: Any]()
        paramDic["loginType"] = SessionManager.shared.loginType
        paramDic["loginId"] = SessionManager.shared.loginId
        self.viewModel.input.deleteUserInfo.onNext(paramDic)
    }
}

extension WithdrawalView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.contentView.layer.cornerRadius = 5
        let title = questionList[indexPath.row]
        cell.titleLabel.text = title
        
        if clickIndex == indexPath.row {
            cell.contentView.backgroundColor = UIColor(red: 48.0/255.0, green: 116.0/255.0, blue: 248.0/255.0, alpha: 1.0)
            cell.contentView.layer.borderColor = CGColor(red: 48.0/255.0, green: 116.0/255.0, blue: 248.0/255.0, alpha: 1.0)
            cell.contentView.layer.borderWidth = 1
            cell.titleLabel.textColor = .white
            cell.checkContainer.backgroundColor = .white
            cell.checkBox.image = UIImage(named: "checkCircle")
        } else {
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.borderColor = CGColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
            cell.contentView.layer.borderWidth = 1
            cell.titleLabel.textColor = UIColor(red: 139.0/255.0, green: 141.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            cell.checkContainer.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
            cell.checkBox.image = UIImage(named: "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectColor(indexPath)
    }
    
    func selectColor(_ index: IndexPath) {
        clickIndex = index.row
        collectionView.reloadData()
    }
}
