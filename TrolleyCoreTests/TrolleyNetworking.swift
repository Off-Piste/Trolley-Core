//
//  Swift_Tests.swift
//  TrolleyCore
//
//  Created by Harry Wright on 22.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import Quick
import Nimble
@testable import TrolleyCore

class Trolley_Request_Swift: QuickSpec {

    override func spec() {
        describe("Trolley Networking") {
            var request: Request!

            beforeEach {
//                Trolley.shared.setLogging(false)
                request = Request("http://api.fixer.io")
            }

            // This will have to be run multiple
            // times as internet speed plays a 
            // factor
            describe("Data response") {
                context("Valid URL") {
                    it("Should download data") {
                        waitUntil { (done) in
                            request.response { (data, error) in
                                expect(data).toNot(beNil())
                                expect(error).to(beNil())
                                done()
                            }
                        }
                    }
                }
            }

            // This will have to be run multiple
            // times as internet speed plays a
            // factor
            describe("JSON response") {
                context("Valid URL") {
                    it("Should download data") {
                        waitUntil { (done) in
                            request.responseJSON { (json, error) in
                                expect(json).toNot(beNil())
                                expect(error).to(beNil())
                                done()
                            }
                        }
                    }
                }
            }

            describe("Request Builder"){
                context("Invalid URL") {
                    it("Should show an error") {
                        let req = Request("lo://hsdhghf gsdg892u.co//.kl")
                        expect(req.error).toNot(beNil())
                        expect(req.request).to(beNil())
                    }
                }

                context("Valid URL") {
                    it("Should pass") {
                        // Complex URL
                        let req = Request("http://www.google.ps/search?hl=en&client=firefox-a&hs=42F&rls=org.mozilla%3Aen-US%3Aofficial&q=The+type+%27Microsoft.Practices.ObjectBuilder.Locator%27+is+defined+in+an+assembly+that+is+not+referenced.+You+must+add+a+reference+to+assembly+&aq=f&aqi=&aql=&oq=")
                        expect(req.error).to(beNil())
                        expect(req.request).toNot(beNil())
                    }
                }
            }
        }
    }

}
