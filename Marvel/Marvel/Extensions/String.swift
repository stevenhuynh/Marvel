//
//  String.swift
//  Marvel
//
//  Created by shuynh on 9/15/21.
//

import Foundation
import CryptoKit

extension String {
    func md5() -> String! {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

    

