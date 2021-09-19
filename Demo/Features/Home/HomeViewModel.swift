//
//  HomeViewModel.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import RxFlow
import RxCocoa
import Domain
import RxSwift
import NetworkPlatform

class HomeViewModel: ActivityHandlerType, ViewModelType, ErrorHandlerType, Stepper {
    let disposeBag = DisposeBag()
    private let apiLoading = ActivityIndicator()
    var activityIndicator: Driver<Bool> {
        return apiLoading.asDriver()
    }
    
    var errorResponse = PublishRelay<AppError>()
    enum RequestTagKey: String {
        case userInfo
    }
    
    var steps =  PublishRelay<Step>()
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let userInfo: Driver<UserInfo>
    }
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        errorTracker.asObservable().map { error in
            return AppError.getAppError(from: error as? ApiError)
        }.bind(to: errorResponse).disposed(by: disposeBag)
        
        let userInfo = input.trigger.flatMapLatest {
            return self.userUseCase.userInfo()
                .trackActivity(self.apiLoading)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .compactMap { $0 }
        }
        
        return Output(userInfo: userInfo)
    }
}
