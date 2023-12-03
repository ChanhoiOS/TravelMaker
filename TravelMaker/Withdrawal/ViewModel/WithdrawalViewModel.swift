//
//  WithdrawalViewModel.swift
//  HealthZZang
//
//  Created by 이찬호 on 2022/08/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol WithdrawalViewModelType {
    associatedtype Input
    associatedtype Output
}

class WithdrawalViewModel: WithdrawalViewModelType {
    
    var input: Input
    var output: Output
    var disposeBag = DisposeBag()
    
    struct Input {
        var deleteUserInfo: PublishSubject<[String: Any]>
        var collectReason: PublishSubject<[String: Any]>
    }
    
    struct Output {
        var responseDelete: PublishSubject<Void>//PublishSubject<WithdrawalModel?>
        var responseReason: PublishSubject<Void>
    }
    
    init() {
        input = Input(deleteUserInfo: PublishSubject<[String: Any]>(), collectReason: PublishSubject<[String: Any]>())
        output = Output(responseDelete: PublishSubject<Void>(), responseReason: PublishSubject<Void>())
        
        input.deleteUserInfo.subscribe(onNext: {[weak self] data in
            self?.requestDelete(data)
        }, onError: {[weak self] error in
            print("error: ",error)
        })
        .disposed(by: disposeBag)
        
        input.collectReason.subscribe(onNext: {[weak self] data in
            self?.collectData(data)
        }, onError: {[weak self] error in
            print("error: ",error)
        })
        .disposed(by: disposeBag)
    }
    
    func requestDelete(_ data: [String: Any]) {
        let paramDic = [String: Any]()
        
        ApiManager.shared.delete(url: Apis.leave, paramDic: paramDic) {
            print("**** 회원정보삭제 성공 **** ")
            self.output.responseDelete.onNext(())
        } failHandler: {
            print("**** 탈퇴 사유 수집 실패 ****")
        }
    }
    
    func collectData(_ data: [String: Any]) {
        var paramDic = [String: Any]()
        let reason = data["outReason"] as? String ?? ""
        let improvements = data["improvements"] as? String ?? ""
        
        paramDic["outReason"] = reason
        paramDic["improvements"] = improvements
        
        ApiManager.shared.post(url: Apis.leave_reason, paramDic: paramDic) {
            print("**** 탈퇴 사유 수집 성공 ****")
            self.output.responseReason.onNext(())
        } failHandler: {
            print("**** 탈퇴 사유 수집 실패 ****")
        }
    }
}
