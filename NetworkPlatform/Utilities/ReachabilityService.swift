//
//  ReachabilityService.swift
//  NetworkPlatform
//
//  Created by Pritam on 18/9/21.
//
import Reachability
import RxSwift

class ReachabilityService {
    private let reachability: Reachability
    private let reachabilitySubject: BehaviorSubject<ReachabilityStatus>
    
    var reachabilityStatus: Observable<ReachabilityStatus> {
        return reachabilitySubject.asObservable()
    }
    
    init() throws {
        guard let reachability = try? Reachability() else { throw ReachabilityServiceError.creationFailure }
        let subject = BehaviorSubject<ReachabilityStatus>(value: .none)
        
        let queue = DispatchQueue(label: "reachability.wificheck")
        
        reachability.whenReachable = { obj in
            queue.async {
                switch obj.connection {
                case .wifi:
                    subject.on(.next(.wifi))
                case .cellular:
                    subject.on(.next(.cellular))
                default:
                    break
                }
            }
        }
        
        reachability.whenUnreachable = { _ in
            queue.async {
                subject.on(.next(.unavailable))
            }
        }
        
        try reachability.startNotifier()
        self.reachability = reachability
        reachabilitySubject = subject
    }
    
    deinit {
        self.reachability.stopNotifier()
    }
}

enum ReachabilityStatus {
    case cellular
    case wifi
    case unavailable
    case none
    
    var isReachable: Bool {
        switch self {
        case .cellular, .wifi:
            return true
        default:
            return false
        }
    }
}

enum ReachabilityServiceError: Error {
    case creationFailure
}
