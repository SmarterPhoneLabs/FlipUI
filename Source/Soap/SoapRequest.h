//
//  SoapRequest.h
//
//  Created by Jason Kichline on 9/21/09.
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

#import "SoapHandler.h"
#import "SoapService.h"

@interface SoapRequest : NSObject {
	NSURL* url;
	NSString* soapAction;
	NSString* username;
	NSString* password;
	id postData;
	NSMutableData* receivedData;
	NSURLConnection* conn;
	SoapHandler* handler;
	id deserializeTo;
	SEL action;
	BOOL logging;
	id<SoapDelegate> defaultHandler;
}

@property (retain, nonatomic) NSURL* url;
@property (retain, nonatomic) NSString* soapAction;
@property (retain, nonatomic) NSString* username;
@property (retain, nonatomic) NSString* password;
@property (retain, nonatomic) id postData;
@property (retain, nonatomic) NSMutableData* receivedData;
@property (retain, nonatomic) SoapHandler* handler;
@property (retain, nonatomic) id deserializeTo;
@property SEL action;
@property BOOL logging;
@property (retain, nonatomic) id<SoapDelegate> defaultHandler;

+ (SoapRequest*) create: (SoapHandler*) handler urlString: (NSString*) urlString soapAction: (NSString*) soapAction postData: (NSString*) postData deserializeTo: (id) deserializeTo;
+ (SoapRequest*) create: (SoapHandler*) handler action: (SEL) action urlString: (NSString*) urlString soapAction: (NSString*) soapAction postData: (NSString*) postData deserializeTo: (id) deserializeTo;
+ (SoapRequest*) create: (SoapHandler*) handler action: (SEL) action service: (SoapService*) service soapAction: (NSString*) soapAction postData: (NSString*) postData deserializeTo: (id) deserializeTo;

- (BOOL)cancel;
- (void)send;
- (void)handleError:(NSError*)error;
- (void)handleFault:(SoapFault*)fault;

@end