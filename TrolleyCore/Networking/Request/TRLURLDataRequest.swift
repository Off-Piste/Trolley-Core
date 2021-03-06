/////////////////////////////////////////////////////////////////////////////////
//
//  TRLURLDataRequest.swift
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 12.09.17.
//  Copyright © 2017 Off-Piste.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

/// <#Description#>
public typealias Parameters = [String: Any]

/// <#Description#>
public typealias Headers = [String: Any]

/// <#Description#>
///
/// - Parameters:
///   - url: <#url description#>
///   - method: <#method description#>
///   - parameters: <#parameters description#>
///   - encoding: <#encoding description#>
///   - headers: <#headers description#>
/// - Returns: <#return value description#>
public func Request(
    _ url: String,
    method: HTTPMethod = .GET,
    parameters: Parameters? = nil,
    encoding: TRLURLParameterEncoding = TRLURLEncoding.default,
    headers: Headers? = nil
    ) -> TRLURLDataRequest
{
    return TRLURLSessionManager.default.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}
