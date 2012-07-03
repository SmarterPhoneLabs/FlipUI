//
//  SoapService.m
//
//  Created by Jason Kichline
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

#import "SoapService.h"

@implementation SoapService

@synthesize serviceUrl = _serviceUrl;
@synthesize namespace = _namespace;
@synthesize logging = _logging;
@synthesize headers = _headers;
@synthesize defaultHandler = _defaultHandler;
@synthesize username = _username;
@synthesize password = _password;

- (id) init {
	if(self = [super init]) {
		self.serviceUrl = nil;
		self.namespace = nil;
		self.logging = NO;
		self.headers = nil;
		self.defaultHandler = nil;
		self.username = nil;
		self.password = nil;
	}
	return self;
}

- (id) initWithUrl: (NSString*) url {
	if(self = [self init]) {
		self.serviceUrl = url;
	}
	return self;
}

- (id) initWithUsername: (NSString*) username andPassword: (NSString*) password {
	if(self = [self init]) {
		self.username = username;
		self.password = password;
	}
	return self;
}

-(void)dealloc {
	[_serviceUrl release];
	[_namespace release];
	[_username release];
	[_password release];
	[_headers release];
	[_defaultHandler release];
	[super dealloc];
}

@end