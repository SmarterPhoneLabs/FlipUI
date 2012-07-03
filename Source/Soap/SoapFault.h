//
//  SoapFault.h
//
//  Created by Jason Kichline on 12/14/10.
//  Copyright 2010 Jason Kichline
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "TouchXML.h"

@interface SoapFault : NSObject {
	NSString* faultCode;
	NSString* faultString;
	NSString* faultActor;
	NSString* detail;
	BOOL hasFault;
}

@property (retain, nonatomic) NSString* faultCode;
@property (retain, nonatomic) NSString* faultString;
@property (retain, nonatomic) NSString* faultActor;
@property (retain, nonatomic) NSString* detail;
@property BOOL hasFault;

+ (SoapFault*) faultWithData: (NSMutableData*) data;
+ (SoapFault*) faultWithXMLDocument: (CXMLDocument*) document;
+ (SoapFault*) faultWithXMLElement: (CXMLNode*) element;

@end
