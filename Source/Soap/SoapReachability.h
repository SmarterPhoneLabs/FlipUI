//
//  SoapReachability.h
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

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface SoapReachability : NSObject {

}

// Determines if we are connected to the network
+ (BOOL) connectedToNetwork;

// Gets the local IP address
+ (NSString*) localIPAddress;

// Gets an IP address for a host
+ (NSString*) getIPAddressForHost: (NSString*) theHost;

// Determines if a host is available
+ (BOOL) hostAvailable: (NSString*) theHost;

// Gets an address from the string
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *) address;

@end
