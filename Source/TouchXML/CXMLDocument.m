//
//  CXHTMLDocument.m
//  TouchCode
//
//  Created by Jonathan Wight on 03/07/08.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY TOXICSOFTWARE.COM ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL TOXICSOFTWARE.COM OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

// This is an experiment to see if we can utilize the HTMLParser functionality
// of libXML to serve as a XHTML parser, I question if this is a good idea or not
// need to test some of the following 
// [-] How are xml namespaces handled
// [-] Can we support DTD
// [-] 

#import "CXMLDocument.h"

#include <libxml/parser.h>
#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>

#import "CXMLNode_PrivateExtensions.h"
#import "CXMLElement.h"

@implementation CXMLDocument

static void htmlparser_error(void *ctx, const char *msg, ...)
{
	va_list args;
	va_start(args, msg);
	va_end(args);
}

static void htmlparser_warning(void *ctx, const char *msg, ...)
{
	va_list args;
	va_start(args, msg);
	va_end(args);
}

- (id)initWithXMLString:(NSString *)inString options:(NSUInteger)inOptions error:(NSError **)outError
{
if ((self = [super init]) != NULL)
	{
	if (outError)
		*outError = NULL;
	
	xmlDocPtr theDoc;
	if ( inOptions & CXMLDocumentTidyHTML )
		{
		const char *htmlString = (const char*) [inString UTF8String];
		int length = xmlStrlen( (const xmlChar*)htmlString );
		htmlParserCtxtPtr ctx = htmlCreateMemoryParserCtxt(htmlString, length);

		if (! ctx ) {
			return 0;
		}	
		
		ctx->vctxt.error = htmlparser_error;
		ctx->vctxt.warning = htmlparser_warning;
		if (ctx->sax != NULL)
			{
			ctx->sax->error = htmlparser_error;
			ctx->sax->warning = htmlparser_warning;
			}
		htmlParseDocument(ctx);
		theDoc = ctx->myDoc;
		htmlFreeParserCtxt(ctx);
		}
	else
		{
		theDoc = xmlParseDoc((xmlChar *)[inString UTF8String]);
		}


	if (theDoc != NULL)
		{
		_node = (xmlNodePtr)theDoc;
		NSAssert(_node->_private == NULL, @"TODO");
		_node->_private = self; // Note. NOT retained (TODO think more about _private usage)
		}
	else
		{
		if (outError)
			*outError = [NSError errorWithDomain:@"CXMLErrorDomain" code:1 userInfo:NULL];
		self = NULL;
		}
	}
return(self);
}

- (id)initWithContentsOfURL:(NSURL *)inURL options:(NSUInteger)inOptions error:(NSError **)outError
{
if (outError)
	*outError = NULL;

NSData *theData = [NSData dataWithContentsOfURL:inURL options:NSUncachedRead error:outError];
if (theData)
	{
	self = [self initWithData:theData options:inOptions error:outError];
	}
else
	{
	
	self = NULL;
	}
	
return(self);
}

- (id)initWithData:(NSData *)inData options:(NSUInteger)inOptions error:(NSError **)outError
{
if ((self = [super init]) != NULL)
	{
	xmlDocPtr theDoc = NULL;

	if (inData && inData.length > 0)
		{
		theDoc = xmlParseMemory([inData bytes], [inData length]);
		}
	
	if (theDoc != NULL)
		{
		_node = (xmlNodePtr)theDoc;
		_node->_private = self; // Note. NOT retained (TODO think more about _private usage)
		}
	else
		{
		if (outError)
			*outError = [NSError errorWithDomain:@"CXMLErrorDomain" code:1 userInfo:NULL];
		self = NULL;
		}
	}
return(self);
}

- (void)dealloc
{
xmlFreeDoc((xmlDocPtr)_node);
_node = NULL;
//

[nodePool release];
nodePool = NULL;
//
[super dealloc];
}

//- (NSString *)characterEncoding;
//- (NSString *)version;
//- (BOOL)isStandalone;
//- (CXMLDocumentContentKind)documentContentKind;
//- (NSString *)MIMEType;
//- (CXMLDTD *)DTD;

- (CXMLElement *)rootElement
{
xmlNodePtr theLibXMLNode = xmlDocGetRootElement((xmlDocPtr)_node);
	
return([CXMLNode nodeWithLibXMLNode:theLibXMLNode]);
}

//- (NSData *)XMLData;
//- (NSData *)XMLDataWithOptions:(NSUInteger)options;

//- (id)objectByApplyingXSLT:(NSData *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTString:(NSString *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTAtURL:(NSURL *)xsltURL arguments:(NSDictionary *)argument error:(NSError **)error;
- (id)XMLStringWithOptions:(NSUInteger)options
{
id root = [self rootElement];
NSMutableString* xmlString = [NSMutableString string];
[root _XMLStringWithOptions:options appendingToString:xmlString];
return xmlString;
}

- (NSString *)description
{
	NSAssert(_node != NULL, @"TODO");

	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p [%p]> ", NSStringFromClass([self class]), self, self->_node];
	xmlChar *xmlbuff;
	int buffersize;

	xmlDocDumpFormatMemory((xmlDocPtr)(self->_node), &xmlbuff, &buffersize, 1);
	NSString *dump = [[[NSString alloc] initWithBytes:xmlbuff length:buffersize encoding:NSUTF8StringEncoding] autorelease];
	xmlFree(xmlbuff);
							   
	[result appendString:dump];
	return result;
}

@end
