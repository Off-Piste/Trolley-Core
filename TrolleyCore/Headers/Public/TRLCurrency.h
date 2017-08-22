//
//  TRLCurrency.h
//  Trolley
//
//  Created by Harry Wright on 18.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TRLCurrencyCode) {
    TRLCurrencyCodeAED = 0,
    TRLCurrencyCodeAFN,
    TRLCurrencyCodeALL,
    TRLCurrencyCodeAMD,
    TRLCurrencyCodeANG,
    TRLCurrencyCodeAOA,
    TRLCurrencyCodeARS,
    TRLCurrencyCodeAUD,
    TRLCurrencyCodeAWG,
    TRLCurrencyCodeAZN,
    TRLCurrencyCodeBAM,
    TRLCurrencyCodeBBD,
    TRLCurrencyCodeBDT,
    TRLCurrencyCodeBGN,
    TRLCurrencyCodeBHD,
    TRLCurrencyCodeBIF,
    TRLCurrencyCodeBMD,
    TRLCurrencyCodeBND,
    TRLCurrencyCodeBOB,
    TRLCurrencyCodeBRL,
    TRLCurrencyCodeBSD,
    TRLCurrencyCodeBWP,
    TRLCurrencyCodeBYR,
    TRLCurrencyCodeBZD,
    TRLCurrencyCodeCAD,
    TRLCurrencyCodeCHF,
    TRLCurrencyCodeCLP,
    TRLCurrencyCodeCNY,
    TRLCurrencyCodeCOP,
    TRLCurrencyCodeCRC,
    TRLCurrencyCodeCUP,
    TRLCurrencyCodeCVE,
    TRLCurrencyCodeCZK,
    TRLCurrencyCodeDJF,
    TRLCurrencyCodeDKK,
    TRLCurrencyCodeDOP,
    TRLCurrencyCodeDZD,
    TRLCurrencyCodeEGP,
    TRLCurrencyCodeERN,
    TRLCurrencyCodeETB,
    TRLCurrencyCodeEUR,
    TRLCurrencyCodeFJD,
    TRLCurrencyCodeFKP,
    TRLCurrencyCodeGBP,
    TRLCurrencyCodeGEL,
    TRLCurrencyCodeGHS,
    TRLCurrencyCodeGIP,
    TRLCurrencyCodeGMD,
    TRLCurrencyCodeGNF,
    TRLCurrencyCodeGTQ,
    TRLCurrencyCodeGYD,
    TRLCurrencyCodeHKD,
    TRLCurrencyCodeHNL,
    TRLCurrencyCodeHRK,
    TRLCurrencyCodeHUF,
    TRLCurrencyCodeIDR,
    TRLCurrencyCodeILS,
    TRLCurrencyCodeINR,
    TRLCurrencyCodeIQD,
    TRLCurrencyCodeIRR,
    TRLCurrencyCodeISK,
    TRLCurrencyCodeJMD,
    TRLCurrencyCodeJOD,
    TRLCurrencyCodeJPY,
    TRLCurrencyCodeKES,
    TRLCurrencyCodeKGS,
    TRLCurrencyCodeKHR,
    TRLCurrencyCodeKMF,
    TRLCurrencyCodeKPW,
    TRLCurrencyCodeKRW,
    TRLCurrencyCodeKWD,
    TRLCurrencyCodeKYD,
    TRLCurrencyCodeKZT,
    TRLCurrencyCodeLAK,
    TRLCurrencyCodeLBP,
    TRLCurrencyCodeLKR,
    TRLCurrencyCodeLRD,
    TRLCurrencyCodeLYD,
    TRLCurrencyCodeMAD,
    TRLCurrencyCodeMDL,
    TRLCurrencyCodeMGA,
    TRLCurrencyCodeMKD,
    TRLCurrencyCodeMMK,
    TRLCurrencyCodeMNT,
    TRLCurrencyCodeMOP,
    TRLCurrencyCodeMRO,
    TRLCurrencyCodeMUR,
    TRLCurrencyCodeMVR,
    TRLCurrencyCodeMWK,
    TRLCurrencyCodeMXN,
    TRLCurrencyCodeMYR,
    TRLCurrencyCodeMZN,
    TRLCurrencyCodeNGN,
    TRLCurrencyCodeNIO,
    TRLCurrencyCodeNOK,
    TRLCurrencyCodeNPR,
    TRLCurrencyCodeNZD,
    TRLCurrencyCodeOMR,
    TRLCurrencyCodePEN,
    TRLCurrencyCodePGK,
    TRLCurrencyCodePHP,
    TRLCurrencyCodePKR,
    TRLCurrencyCodePLN,
    TRLCurrencyCodePYG,
    TRLCurrencyCodeQAR,
    TRLCurrencyCodeRON,
    TRLCurrencyCodeRSD,
    TRLCurrencyCodeRUB,
    TRLCurrencyCodeRWF,
    TRLCurrencyCodeSAR,
    TRLCurrencyCodeSBD,
    TRLCurrencyCodeSCR,
    TRLCurrencyCodeSDG,
    TRLCurrencyCodeSEK,
    TRLCurrencyCodeSGD,
    TRLCurrencyCodeSHP,
    TRLCurrencyCodeSLL,
    TRLCurrencyCodeSOS,
    TRLCurrencyCodeSRD,
    TRLCurrencyCodeSSP,
    TRLCurrencyCodeSTD,
    TRLCurrencyCodeSYP,
    TRLCurrencyCodeSZL,
    TRLCurrencyCodeTHB,
    TRLCurrencyCodeTJS,
    TRLCurrencyCodeTMT,
    TRLCurrencyCodeTND,
    TRLCurrencyCodeTOP,
    TRLCurrencyCodeTRY,
    TRLCurrencyCodeTTD,
    TRLCurrencyCodeTWD,
    TRLCurrencyCodeTZS,
    TRLCurrencyCodeUAH,
    TRLCurrencyCodeUGX,
    TRLCurrencyCodeUSD,
    TRLCurrencyCodeUYU,
    TRLCurrencyCodeUZS,
    TRLCurrencyCodeVEF,
    TRLCurrencyCodeVND,
    TRLCurrencyCodeVUV,
    TRLCurrencyCodeWST,
    TRLCurrencyCodeXAF,
    TRLCurrencyCodeXCD,
    TRLCurrencyCodeXOF,
    TRLCurrencyCodeXPF,
    TRLCurrencyCodeYER,
    TRLCurrencyCodeZAR,
    TRLCurrencyCodeZMW,
    TRLCurrencyCodeZWL
} NS_SWIFT_NAME(Currency);

NS_ASSUME_NONNULL_BEGIN

@interface TRLCurrency : NSObject

@property (readonly) TRLCurrencyCode code;

+ (instancetype)defaultCurrency NS_SWIFT_NAME(default());

- (instancetype)init;

- (instancetype)initWithCurrencyCode:(NSString *)currencyCode;

- (instancetype)initWithTRLCurrencyCode:(TRLCurrencyCode)currencyCode NS_SWIFT_NAME(init(currency:));

- (NSString *)description;

@end

TRLCurrencyCode codeForCurrencyCode(NSString * currencyCode);

NSString* stringCode(TRLCurrencyCode code);

NS_ASSUME_NONNULL_END
