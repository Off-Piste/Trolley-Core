/////////////////////////////////////////////////////////////////////////////////
//
//  Log.swift
//  Test
//
//  Created by Harry Wright on 20.09.17.
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

internal extension trl_logger_t {
    func log(for level: LoggerLevel, _ msg: StaticString, _ args: [CVarArg]) {
        msg.withUTF8Buffer { (buffer) in
            buffer.baseAddress!.withMemoryRebound(to: CChar.self, capacity: buffer.count, { (str) in
                withVaList(args) { (va_list) -> Void in
                    self.log(level: level, fmt: str, va_list)
                }
            })
        }

    }
}

internal func TRLLog(for service: TRLLoggerService, _ msg: StaticString, _ args: CVarArg...) {
    trl_logger_t(forService: service).log(for: .default, msg, args)
}

internal func TRLDebugLogger(for service: TRLLoggerService, _ msg: StaticString, _ args: CVarArg...) {
    trl_logger_t(forService: service).log(for: .debug, msg, args)
}

internal func TRLInfoLogger(for service: TRLLoggerService, _ msg: StaticString, _ args: CVarArg...) {
    trl_logger_t(forService: service).log(for: .info, msg, args)
}

internal func TRLFaultLogger(for service: TRLLoggerService, _ msg: StaticString, _ args: CVarArg...) {
    trl_logger_t(forService: service).log(for: .fault, msg, args)
}

internal func TRLErrorLogger(for service: TRLLoggerService, _ msg: StaticString, _ args: CVarArg...) {
    trl_logger_t(forService: service).log(for: .error, msg, args)
}
