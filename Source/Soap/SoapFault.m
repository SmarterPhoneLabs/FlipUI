//
//  SoapFault.m
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

#import "SoapFault.h"
#import "Soap.h"

@implementation SoapFault

@synthesize faultCode, faultString, faultActor, detail, hasFault;

+ (SoapFault*) faultWithData: (NSMutableData*) data {
	NSError* error;
	CXMLDocument* doc = [[CXMLDocument alloc] initWithData: data options: 0 error: &error];
	if(doc == nil) {
		return [[[SoapFault alloc] init] autorelease];
	}
	return [SoapFault faultWithXMLDocument: doc];
}

+ (SoapFault*) faultWithXMLDocument: (CXMLDocument*) document {
	return [SoapFault faultWithXMLElement: [Soap getNode: [document rootElement] withName: @"Fault"]];
}

+ (SoapFault*) faultWithXMLElement: (CXMLNode*) element {
	SoapFault* fault = [[[SoapFault alloc] init] autorelease];
	fault.hasFault = NO;
	if(element == nil) {
		return fault;
	}

	fault.faultCode = [Soap getNodeValue: element withName: @"faultcode"];
	fault.faultString = [Soap getNodeValue: element withName: @"faultstring"];
	fault.faultActor = [Soap getNodeValue: element withName: @"faultactor"];
	fault.detail = [Soap getNodeValue: element withName: @"detail"];
	fault.hasFault = YES;
	return fault;
}

- (NSString*) description {
	if(self.hasFault) {
		return [NSString stringWithFormat: @"%@ %@\n%@", self.faultCode, self.faultString, self.detail];
	} else {
		return nil;
	}
}

- (void) dealloc {
	self.faultCode = nil;
	self.faultString = nil;
	self.faultActor = nil;
	self.detail = nil;
	[super dealloc];
}

@end
