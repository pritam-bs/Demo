//
//  UserUseCase.swift
//  Domain
//
//  Created by Pritam on 9/9/21.
//

import Foundation
import RxSwift

public protocol UserUseCase {
    func userInfo() -> Observable<UserInfo?>
}
