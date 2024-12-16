//
//  VDControllerType.swift
//  VenusCustomer
//
//  Created by Amit on 05/06/23.
//

import UIKit

protocol VCControllerType: UIViewController {
    associatedtype ViewModelType: VCViewModelProtocol
    func configure(with viewModel: ViewModelType)
    static func create() -> UIViewController
    func disableCompletionForEmptyInput()
}

extension VCControllerType {
    static func create(with viewModel: ViewModelType) -> UIViewController {
        return UIViewController()
    }

    func disableCompletionForEmptyInput() {}
}

protocol VCViewModelProtocol {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

protocol VCViewModelClassProtocol: AnyObject, VCViewModelProtocol {

}

extension VCViewModelClassProtocol {
    var memoryAddress: UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(self).toOpaque()
    }
}

extension UIViewController {
    var memoryAddress: UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(self).toOpaque()
    }
}
