//
//  TRLCurrency.m
//  Trolley
//
//  Created by Harry Wright on 18.08.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#import <TrolleyCore/TRLCurrency.h>
#import <TrolleyCore/TrolleyCore-Swift.h>

@implementation TRLCurrency

+ (instancetype)defaultCurrency {
    return [[TRLCurrency alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLocale *locale = [NSLocale currentLocale];
        NSString *currencyCode = [locale currencyCode];
        self->_code = codeForCurrencyCode(currencyCode);
    }
    return self;
}

- (instancetype)initWithCurrencyCode:(NSString *)currencyCode {
    self = [super init];
    if (self) {
        self->_code = codeForCurrencyCode(currencyCode);
//        [TRLLogger.default_ ]
    }
    return self;
}

- (instancetype)initWithTRLCurrencyCode:(TRLCurrencyCode)currencyCode {
    self = [super init];
    if (self) {
        self->_code = currencyCode;
    }
    return self;
}

- (NSString *)description {
    return stringCode(self.code);
}

@end

TRLCurrencyCode codeForCurrencyCode(NSString * currencyCode) {
    if ([currencyCode isEqual: @"AED"]) {
        return TRLCurrencyCodeAED;
    } else if ([currencyCode isEqual: @"AFN"]) {
        return TRLCurrencyCodeAFN;
    } else if ([currencyCode isEqual: @"ALL"]) {
        return TRLCurrencyCodeALL;
    } else if ([currencyCode isEqual: @"AMD"]) {
        return TRLCurrencyCodeAMD;
    } else if ([currencyCode isEqual: @"ANG"]) {
        return TRLCurrencyCodeANG;
    } else if ([currencyCode isEqual: @"AOA"]) {
        return TRLCurrencyCodeAOA;
    } else if ([currencyCode isEqual: @"ARS"]) {
        return TRLCurrencyCodeARS;
    } else if ([currencyCode isEqual: @"AUD"]) {
        return TRLCurrencyCodeAUD;
    } else if ([currencyCode isEqual: @"AWG"]) {
        return TRLCurrencyCodeAWG;
    } else if ([currencyCode isEqual: @"AZN"]) {
        return TRLCurrencyCodeAZN;
    } else if ([currencyCode isEqual: @"BAM"]) {
        return TRLCurrencyCodeBAM;
    } else if ([currencyCode isEqual: @"BBD"]) {
        return TRLCurrencyCodeBBD;
    } else if ([currencyCode isEqual: @"BDT"]) {
        return TRLCurrencyCodeBDT;
    } else if ([currencyCode isEqual: @"BGN"]) {
        return TRLCurrencyCodeBGN;
    } else if ([currencyCode isEqual: @"BHD"]) {
        return TRLCurrencyCodeBHD;
    } else if ([currencyCode isEqual: @"BIF"]) {
        return TRLCurrencyCodeBIF;
    } else if ([currencyCode isEqual: @"BMD"]) {
        return TRLCurrencyCodeBMD;
    } else if ([currencyCode isEqual: @"BND"]) {
        return TRLCurrencyCodeBND;
    } else if ([currencyCode isEqual: @"BOB"]) {
        return TRLCurrencyCodeBOB;
    } else if ([currencyCode isEqual: @"BRL"]) {
        return TRLCurrencyCodeBRL;
    } else if ([currencyCode isEqual: @"BSD"]) {
        return TRLCurrencyCodeBSD;
    } else if ([currencyCode isEqual: @"BWP"]) {
        return TRLCurrencyCodeBWP;
    } else if ([currencyCode isEqual: @"BYR"]) {
        return TRLCurrencyCodeBYR;
    } else if ([currencyCode isEqual: @"BZD"]) {
        return TRLCurrencyCodeBZD;
    } else if ([currencyCode isEqual: @"CAD"]) {
        return TRLCurrencyCodeCAD;
    } else if ([currencyCode isEqual: @"CHF"]) {
        return TRLCurrencyCodeCHF;
    } else if ([currencyCode isEqual: @"CLP"]) {
        return TRLCurrencyCodeCLP;
    } else if ([currencyCode isEqual: @"CNY"]) {
        return TRLCurrencyCodeCNY;
    } else if ([currencyCode isEqual: @"COP"]) {
        return TRLCurrencyCodeCOP;
    } else if ([currencyCode isEqual: @"CRC"]) {
        return TRLCurrencyCodeCRC;
    } else if ([currencyCode isEqual: @"CUP"]) {
        return TRLCurrencyCodeCUP;
    } else if ([currencyCode isEqual: @"CVE"]) {
        return TRLCurrencyCodeCVE;
    } else if ([currencyCode isEqual: @"CZK"]) {
        return TRLCurrencyCodeCZK;
    } else if ([currencyCode isEqual: @"DJF"]) {
        return TRLCurrencyCodeDJF;
    } else if ([currencyCode isEqual: @"DKK"]) {
        return TRLCurrencyCodeDKK;
    } else if ([currencyCode isEqual: @"DOP"]) {
        return TRLCurrencyCodeDOP;
    } else if ([currencyCode isEqual: @"DZD"]) {
        return TRLCurrencyCodeDZD;
    } else if ([currencyCode isEqual: @"EGP"]) {
        return TRLCurrencyCodeEGP;
    } else if ([currencyCode isEqual: @"ERN"]) {
        return TRLCurrencyCodeERN;
    } else if ([currencyCode isEqual: @"ETB"]) {
        return TRLCurrencyCodeETB;
    } else if ([currencyCode isEqual: @"EUR"]) {
        return TRLCurrencyCodeEUR;
    } else if ([currencyCode isEqual: @"FJD"]) {
        return TRLCurrencyCodeFJD;
    } else if ([currencyCode isEqual: @"FKP"]) {
        return TRLCurrencyCodeFKP;
    } else if ([currencyCode isEqual: @"GBP"]) {
        return TRLCurrencyCodeGBP;
    } else if ([currencyCode isEqual: @"GEL"]) {
        return TRLCurrencyCodeGEL;
    } else if ([currencyCode isEqual: @"GHS"]) {
        return TRLCurrencyCodeGHS;
    } else if ([currencyCode isEqual: @"GIP"]) {
        return TRLCurrencyCodeGIP;
    } else if ([currencyCode isEqual: @"GMD"]) {
        return TRLCurrencyCodeGMD;
    } else if ([currencyCode isEqual: @"GNF"]) {
        return TRLCurrencyCodeGNF;
    } else if ([currencyCode isEqual: @"GTQ"]) {
        return TRLCurrencyCodeGTQ;
    } else if ([currencyCode isEqual: @"GYD"]) {
        return TRLCurrencyCodeGYD;
    } else if ([currencyCode isEqual: @"HKD"]) {
        return TRLCurrencyCodeHKD;
    } else if ([currencyCode isEqual: @"HNL"]) {
        return TRLCurrencyCodeHNL;
    } else if ([currencyCode isEqual: @"HRK"]) {
        return TRLCurrencyCodeHRK;
    } else if ([currencyCode isEqual: @"HUF"]) {
        return TRLCurrencyCodeHUF;
    } else if ([currencyCode isEqual: @"IDR"]) {
        return TRLCurrencyCodeIDR;
    } else if ([currencyCode isEqual: @"ILS"]) {
        return TRLCurrencyCodeILS;
    } else if ([currencyCode isEqual: @"INR"]) {
        return TRLCurrencyCodeINR;
    } else if ([currencyCode isEqual: @"IQD"]) {
        return TRLCurrencyCodeIQD;
    } else if ([currencyCode isEqual: @"IRR"]) {
        return TRLCurrencyCodeIRR;
    } else if ([currencyCode isEqual: @"ISK"]) {
        return TRLCurrencyCodeISK;
    } else if ([currencyCode isEqual: @"JMD"]) {
        return TRLCurrencyCodeJMD;
    } else if ([currencyCode isEqual: @"JOD"]) {
        return TRLCurrencyCodeJOD;
    } else if ([currencyCode isEqual: @"JPY"]) {
        return TRLCurrencyCodeJPY;
    } else if ([currencyCode isEqual: @"KES"]) {
        return TRLCurrencyCodeKES;
    } else if ([currencyCode isEqual: @"KGS"]) {
        return TRLCurrencyCodeKGS;
    } else if ([currencyCode isEqual: @"KHR"]) {
        return TRLCurrencyCodeKHR;
    } else if ([currencyCode isEqual: @"KMF"]) {
        return TRLCurrencyCodeKMF;
    } else if ([currencyCode isEqual: @"KPW"]) {
        return TRLCurrencyCodeKPW;
    } else if ([currencyCode isEqual: @"KRW"]) {
        return TRLCurrencyCodeKRW;
    } else if ([currencyCode isEqual: @"KWD"]) {
        return TRLCurrencyCodeKWD;
    } else if ([currencyCode isEqual: @"KYD"]) {
        return TRLCurrencyCodeKYD;
    } else if ([currencyCode isEqual: @"KZT"]) {
        return TRLCurrencyCodeKZT;
    } else if ([currencyCode isEqual: @"LAK"]) {
        return TRLCurrencyCodeLAK;
    } else if ([currencyCode isEqual: @"LBP"]) {
        return TRLCurrencyCodeLBP;
    } else if ([currencyCode isEqual: @"LKR"]) {
        return TRLCurrencyCodeLKR;
    } else if ([currencyCode isEqual: @"LRD"]) {
        return TRLCurrencyCodeLRD;
    } else if ([currencyCode isEqual: @"LYD"]) {
        return TRLCurrencyCodeLYD;
    } else if ([currencyCode isEqual: @"MAD"]) {
        return TRLCurrencyCodeMAD;
    } else if ([currencyCode isEqual: @"MDL"]) {
        return TRLCurrencyCodeMDL;
    } else if ([currencyCode isEqual: @"MGA"]) {
        return TRLCurrencyCodeMGA;
    } else if ([currencyCode isEqual: @"MKD"]) {
        return TRLCurrencyCodeMKD;
    } else if ([currencyCode isEqual: @"MMK"]) {
        return TRLCurrencyCodeMMK;
    } else if ([currencyCode isEqual: @"MNT"]) {
        return TRLCurrencyCodeMNT;
    } else if ([currencyCode isEqual: @"MOP"]) {
        return TRLCurrencyCodeMOP;
    } else if ([currencyCode isEqual: @"MRO"]) {
        return TRLCurrencyCodeMRO;
    } else if ([currencyCode isEqual: @"MUR"]) {
        return TRLCurrencyCodeMUR;
    } else if ([currencyCode isEqual: @"MVR"]) {
        return TRLCurrencyCodeMVR;
    } else if ([currencyCode isEqual: @"MWK"]) {
        return TRLCurrencyCodeMWK;
    } else if ([currencyCode isEqual: @"MXN"]) {
        return TRLCurrencyCodeMXN;
    } else if ([currencyCode isEqual: @"MYR"]) {
        return TRLCurrencyCodeMYR;
    } else if ([currencyCode isEqual: @"MZN"]) {
        return TRLCurrencyCodeMZN;
    } else if ([currencyCode isEqual: @"NGN"]) {
        return TRLCurrencyCodeNGN;
    } else if ([currencyCode isEqual: @"NIO"]) {
        return TRLCurrencyCodeNIO;
    } else if ([currencyCode isEqual: @"NOK"]) {
        return TRLCurrencyCodeNOK;
    } else if ([currencyCode isEqual: @"NPR"]) {
        return TRLCurrencyCodeNPR;
    } else if ([currencyCode isEqual: @"NZD"]) {
        return TRLCurrencyCodeNZD;
    } else if ([currencyCode isEqual: @"OMR"]) {
        return TRLCurrencyCodeOMR;
    } else if ([currencyCode isEqual: @"PEN"]) {
        return TRLCurrencyCodePEN;
    } else if ([currencyCode isEqual: @"PGK"]) {
        return TRLCurrencyCodePGK;
    } else if ([currencyCode isEqual: @"PHP"]) {
        return TRLCurrencyCodePHP;
    } else if ([currencyCode isEqual: @"PKR"]) {
        return TRLCurrencyCodePKR;
    } else if ([currencyCode isEqual: @"PLN"]) {
        return TRLCurrencyCodePLN;
    } else if ([currencyCode isEqual: @"PYG"]) {
        return TRLCurrencyCodePYG;
    } else if ([currencyCode isEqual: @"QAR"]) {
        return TRLCurrencyCodeQAR;
    } else if ([currencyCode isEqual: @"RON"]) {
        return TRLCurrencyCodeRON;
    } else if ([currencyCode isEqual: @"RSD"]) {
        return TRLCurrencyCodeRSD;
    } else if ([currencyCode isEqual: @"RUB"]) {
        return TRLCurrencyCodeRUB;
    } else if ([currencyCode isEqual: @"RWF"]) {
        return TRLCurrencyCodeRWF;
    } else if ([currencyCode isEqual: @"SAR"]) {
        return TRLCurrencyCodeSAR;
    } else if ([currencyCode isEqual: @"SBD"]) {
        return TRLCurrencyCodeSBD;
    } else if ([currencyCode isEqual: @"SCR"]) {
        return TRLCurrencyCodeSCR;
    } else if ([currencyCode isEqual: @"SDG"]) {
        return TRLCurrencyCodeSDG;
    } else if ([currencyCode isEqual: @"SEK"]) {
        return TRLCurrencyCodeSEK;
    } else if ([currencyCode isEqual: @"SGD"]) {
        return TRLCurrencyCodeSGD;
    } else if ([currencyCode isEqual: @"SHP"]) {
        return TRLCurrencyCodeSHP;
    } else if ([currencyCode isEqual: @"SLL"]) {
        return TRLCurrencyCodeSLL;
    } else if ([currencyCode isEqual: @"SOS"]) {
        return TRLCurrencyCodeSOS;
    } else if ([currencyCode isEqual: @"SRD"]) {
        return TRLCurrencyCodeSRD;
    } else if ([currencyCode isEqual: @"SSP"]) {
        return TRLCurrencyCodeSSP;
    } else if ([currencyCode isEqual: @"STD"]) {
        return TRLCurrencyCodeSTD;
    } else if ([currencyCode isEqual: @"SYP"]) {
        return TRLCurrencyCodeSYP;
    } else if ([currencyCode isEqual: @"SZL"]) {
        return TRLCurrencyCodeSZL;
    } else if ([currencyCode isEqual: @"THB"]) {
        return TRLCurrencyCodeTHB;
    } else if ([currencyCode isEqual: @"TJS"]) {
        return TRLCurrencyCodeTJS;
    } else if ([currencyCode isEqual: @"TMT"]) {
        return TRLCurrencyCodeTMT;
    } else if ([currencyCode isEqual: @"TND"]) {
        return TRLCurrencyCodeTND;
    } else if ([currencyCode isEqual: @"TOP"]) {
        return TRLCurrencyCodeTOP;
    } else if ([currencyCode isEqual: @"TRY"]) {
        return TRLCurrencyCodeTRY;
    } else if ([currencyCode isEqual: @"TTD"]) {
        return TRLCurrencyCodeTTD;
    } else if ([currencyCode isEqual: @"TWD"]) {
        return TRLCurrencyCodeTWD;
    } else if ([currencyCode isEqual: @"TZS"]) {
        return TRLCurrencyCodeTZS;
    } else if ([currencyCode isEqual: @"UAH"]) { 
        return TRLCurrencyCodeUAH;
    } else if ([currencyCode isEqual: @"UGX"]) { 
        return TRLCurrencyCodeUGX;
    } else if ([currencyCode isEqual: @"USD"]) { 
        return TRLCurrencyCodeUSD;
    } else if ([currencyCode isEqual: @"UYU"]) { 
        return TRLCurrencyCodeUYU;
    } else if ([currencyCode isEqual: @"UZS"]) { 
        return TRLCurrencyCodeUZS;
    } else if ([currencyCode isEqual: @"VEF"]) { 
        return TRLCurrencyCodeVEF;
    } else if ([currencyCode isEqual: @"VND"]) { 
        return TRLCurrencyCodeVND;
    } else if ([currencyCode isEqual: @"VUV"]) { 
        return TRLCurrencyCodeVUV;
    } else if ([currencyCode isEqual: @"WST"]) { 
        return TRLCurrencyCodeWST;
    } else if ([currencyCode isEqual: @"XAF"]) { 
        return TRLCurrencyCodeXAF;
    } else if ([currencyCode isEqual: @"XCD"]) { 
        return TRLCurrencyCodeXCD;
    } else if ([currencyCode isEqual: @"XOF"]) { 
        return TRLCurrencyCodeXOF;
    } else if ([currencyCode isEqual: @"XPF"]) { 
        return TRLCurrencyCodeXPF;
    } else if ([currencyCode isEqual: @"YER"]) { 
        return TRLCurrencyCodeYER;
    } else if ([currencyCode isEqual: @"ZAR"]) { 
        return TRLCurrencyCodeZAR;
    } else if ([currencyCode isEqual: @"ZMW"]) { 
        return TRLCurrencyCodeZMW;
    } else if ([currencyCode isEqual: @"ZWL"]) { 
        return TRLCurrencyCodeZWL;
    } else { 
        return TRLCurrencyCodeGBP;
    }
}

NSString* stringCode(TRLCurrencyCode code) {
    switch (code) {
        case TRLCurrencyCodeAED: return @"AED";
        case TRLCurrencyCodeAFN: return @"AFN";
        case TRLCurrencyCodeALL: return @"ALL";
        case TRLCurrencyCodeAMD: return @"AMD";
        case TRLCurrencyCodeANG: return @"ANG";
        case TRLCurrencyCodeAOA: return @"AOA";
        case TRLCurrencyCodeARS: return @"ARS";
        case TRLCurrencyCodeAUD: return @"AUD";
        case TRLCurrencyCodeAWG: return @"AWG";
        case TRLCurrencyCodeAZN: return @"AZN";
        case TRLCurrencyCodeBAM: return @"BAM";
        case TRLCurrencyCodeBBD: return @"BBD";
        case TRLCurrencyCodeBDT: return @"BDT";
        case TRLCurrencyCodeBGN: return @"BGN";
        case TRLCurrencyCodeBHD: return @"BHD";
        case TRLCurrencyCodeBIF: return @"BIF";
        case TRLCurrencyCodeBMD: return @"BMD";
        case TRLCurrencyCodeBND: return @"BND";
        case TRLCurrencyCodeBOB: return @"BOB";
        case TRLCurrencyCodeBRL: return @"BRL";
        case TRLCurrencyCodeBSD: return @"BSD";
        case TRLCurrencyCodeBWP: return @"BWP";
        case TRLCurrencyCodeBYR: return @"BYR";
        case TRLCurrencyCodeBZD: return @"BZD";
        case TRLCurrencyCodeCAD: return @"CAD";
        case TRLCurrencyCodeCHF: return @"CHF";
        case TRLCurrencyCodeCLP: return @"CLP";
        case TRLCurrencyCodeCNY: return @"CNY";
        case TRLCurrencyCodeCOP: return @"COP";
        case TRLCurrencyCodeCRC: return @"CRC";
        case TRLCurrencyCodeCUP: return @"CUP";
        case TRLCurrencyCodeCVE: return @"CVE";
        case TRLCurrencyCodeCZK: return @"CZK";
        case TRLCurrencyCodeDJF: return @"DJF";
        case TRLCurrencyCodeDKK: return @"DKK";
        case TRLCurrencyCodeDOP: return @"DOP";
        case TRLCurrencyCodeDZD: return @"DZD";
        case TRLCurrencyCodeEGP: return @"EGP";
        case TRLCurrencyCodeERN: return @"ERN";
        case TRLCurrencyCodeETB: return @"ETB";
        case TRLCurrencyCodeEUR: return @"EUR";
        case TRLCurrencyCodeFJD: return @"FJD";
        case TRLCurrencyCodeFKP: return @"FKP";
        case TRLCurrencyCodeGBP: return @"GBP";
        case TRLCurrencyCodeGEL: return @"GEL";
        case TRLCurrencyCodeGHS: return @"GHS";
        case TRLCurrencyCodeGIP: return @"GIP";
        case TRLCurrencyCodeGMD: return @"GMD";
        case TRLCurrencyCodeGNF: return @"GNF";
        case TRLCurrencyCodeGTQ: return @"GTQ";
        case TRLCurrencyCodeGYD: return @"GYD";
        case TRLCurrencyCodeHKD: return @"HKD";
        case TRLCurrencyCodeHNL: return @"HNL";
        case TRLCurrencyCodeHRK: return @"HRK";
        case TRLCurrencyCodeHUF: return @"HUF";
        case TRLCurrencyCodeIDR: return @"IDR";
        case TRLCurrencyCodeILS: return @"ILS";
        case TRLCurrencyCodeINR: return @"INR";
        case TRLCurrencyCodeIQD: return @"IQD";
        case TRLCurrencyCodeIRR: return @"IRR";
        case TRLCurrencyCodeISK: return @"ISK";
        case TRLCurrencyCodeJMD: return @"JMD";
        case TRLCurrencyCodeJOD: return @"JOD";
        case TRLCurrencyCodeJPY: return @"JPY";
        case TRLCurrencyCodeKES: return @"KES";
        case TRLCurrencyCodeKGS: return @"KGS";
        case TRLCurrencyCodeKHR: return @"KHR";
        case TRLCurrencyCodeKMF: return @"KMF";
        case TRLCurrencyCodeKPW: return @"KPW";
        case TRLCurrencyCodeKRW: return @"KRW";
        case TRLCurrencyCodeKWD: return @"KWD";
        case TRLCurrencyCodeKYD: return @"KYD";
        case TRLCurrencyCodeKZT: return @"KZT";
        case TRLCurrencyCodeLAK: return @"LAK";
        case TRLCurrencyCodeLBP: return @"LBP";
        case TRLCurrencyCodeLKR: return @"LKR";
        case TRLCurrencyCodeLRD: return @"LRD";
        case TRLCurrencyCodeLYD: return @"LYD";
        case TRLCurrencyCodeMAD: return @"MAD";
        case TRLCurrencyCodeMDL: return @"MDL";
        case TRLCurrencyCodeMGA: return @"MGA";
        case TRLCurrencyCodeMKD: return @"MKD";
        case TRLCurrencyCodeMMK: return @"MMK";
        case TRLCurrencyCodeMNT: return @"MNT";
        case TRLCurrencyCodeMOP: return @"MOP";
        case TRLCurrencyCodeMRO: return @"MRO";
        case TRLCurrencyCodeMUR: return @"MUR";
        case TRLCurrencyCodeMVR: return @"MVR";
        case TRLCurrencyCodeMWK: return @"MWK";
        case TRLCurrencyCodeMXN: return @"MXN";
        case TRLCurrencyCodeMYR: return @"MYR";
        case TRLCurrencyCodeMZN: return @"MZN";
        case TRLCurrencyCodeNGN: return @"NGN";
        case TRLCurrencyCodeNIO: return @"NIO";
        case TRLCurrencyCodeNOK: return @"NOK";
        case TRLCurrencyCodeNPR: return @"NPR";
        case TRLCurrencyCodeNZD: return @"NZD";
        case TRLCurrencyCodeOMR: return @"OMR";
        case TRLCurrencyCodePEN: return @"PEN";
        case TRLCurrencyCodePGK: return @"PGK";
        case TRLCurrencyCodePHP: return @"PHP";
        case TRLCurrencyCodePKR: return @"PKR";
        case TRLCurrencyCodePLN: return @"PLN";
        case TRLCurrencyCodePYG: return @"PYG";
        case TRLCurrencyCodeQAR: return @"QAR";
        case TRLCurrencyCodeRON: return @"RON";
        case TRLCurrencyCodeRSD: return @"RSD";
        case TRLCurrencyCodeRUB: return @"RUB";
        case TRLCurrencyCodeRWF: return @"RWF";
        case TRLCurrencyCodeSAR: return @"SAR";
        case TRLCurrencyCodeSBD: return @"SBD";
        case TRLCurrencyCodeSCR: return @"SCR";
        case TRLCurrencyCodeSDG: return @"SDG";
        case TRLCurrencyCodeSEK: return @"SEK";
        case TRLCurrencyCodeSGD: return @"SGD";
        case TRLCurrencyCodeSHP: return @"SHP";
        case TRLCurrencyCodeSLL: return @"SLL";
        case TRLCurrencyCodeSOS: return @"SOS";
        case TRLCurrencyCodeSRD: return @"SRD";
        case TRLCurrencyCodeSSP: return @"SSP";
        case TRLCurrencyCodeSTD: return @"STD";
        case TRLCurrencyCodeSYP: return @"SYP";
        case TRLCurrencyCodeSZL: return @"SZL";
        case TRLCurrencyCodeTHB: return @"THB";
        case TRLCurrencyCodeTJS: return @"TJS";
        case TRLCurrencyCodeTMT: return @"TMT";
        case TRLCurrencyCodeTND: return @"TND";
        case TRLCurrencyCodeTOP: return @"TOP";
        case TRLCurrencyCodeTRY: return @"TRY";
        case TRLCurrencyCodeTTD: return @"TTD";
        case TRLCurrencyCodeTWD: return @"TWD";
        case TRLCurrencyCodeTZS: return @"TZS";
        case TRLCurrencyCodeUAH: return @"UAH";
        case TRLCurrencyCodeUGX: return @"UGX";
        case TRLCurrencyCodeUSD: return @"USD";
        case TRLCurrencyCodeUYU: return @"UYU";
        case TRLCurrencyCodeUZS: return @"UZS";
        case TRLCurrencyCodeVEF: return @"VEF";
        case TRLCurrencyCodeVND: return @"VND";
        case TRLCurrencyCodeVUV: return @"VUV";
        case TRLCurrencyCodeWST: return @"WST";
        case TRLCurrencyCodeXAF: return @"XAF";
        case TRLCurrencyCodeXCD: return @"XCD";
        case TRLCurrencyCodeXOF: return @"XOF";
        case TRLCurrencyCodeXPF: return @"XPF";
        case TRLCurrencyCodeYER: return @"YER";
        case TRLCurrencyCodeZAR: return @"ZAR";
        case TRLCurrencyCodeZMW: return @"ZMW";
        case TRLCurrencyCodeZWL: return @"ZWL";
    }
}
