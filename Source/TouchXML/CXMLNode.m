//
//  CXMLNode.m
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

#import "CXMLNode.h"

#import "CXMLNode_PrivateExtensions.h"
#import "CXMLDocument.h"
#import "CXMLElement.h"

#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>

@implementation CXMLNode

- (void)dealloc
{
if (_node)
	{
	if (_node->_private == self)
		_node->_private = NULL;
	_node = NULL;
	}
//
[super dealloc];
}

- (CXMLNodeKind)kind
{
NSAssert(_node != NULL, @"TODO");
return((CXMLNodeKind)_node->type); // TODO this isn't 100% accurate!
}

- (NSString *)name
{
NSAssert(_node != NULL, @"TODO");
// TODO use xmlCheckUTF8 to check name
if (_node->name == NULL)
	return(NULL);
else
	return([NSString stringWithUTF8String:(const char *)_node->name]);
}

- (NSString *)stringValue
{
NSAssert(_node != NULL, @"TODO");
xmlChar *theXMLString;
if ( _node->type == CXMLTextKind ) 
	theXMLString = _node->content;
else
	theXMLString = xmlNodeListGetString(_node->doc, _node->children, YES);

NSString *theStringValue = NULL;
if (theXMLString != NULL)
	{
	theStringValue = [NSString stringWithUTF8String:(const char *)theXMLString];
	if ( _node->type != CXMLTextKind )
		xmlFree(theXMLString);
	}

return(theStringValue);
}

- (NSUInteger)index
{
NSAssert(_node != NULL, @"TODO");

xmlNodePtr theCurrentNode = _node->prev;
NSUInteger N;
for (N = 0; theCurrentNode != NULL; ++N, theCurrentNode = theCurrentNode->prev)
	;
return(N);
}

- (NSUInteger)level
{
NSAssert(_node != NULL, @"TODO");

xmlNodePtr theCurrentNode = _node->parent;
NSUInteger N;
for (N = 0; theCurrentNode != NULL; ++N, theCurrentNode = theCurrentNode->parent)
	;
return(N);
}

- (CXMLDocument *)rootDocument
{
NSAssert(_node != NULL, @"TODO");

return(_node->doc->_private);
}

- (CXMLNode *)parent
{
NSAssert(_node != NULL, @"TODO");

if (_node->parent == NULL)
	return(NULL);
else
	return (_node->parent->_private);
}

- (NSUInteger)childCount
{
NSAssert(_node != NULL, @"TODO");

xmlNodePtr theCurrentNode = _node->children;
NSUInteger N;
for (N = 0; theCurrentNode != NULL; ++N, theCurrentNode = theCurrentNode->next)
	;
return(N);
}

- (NSArray *)children
{
NSAssert(_node != NULL, @"TODO");

NSMutableArray *theChildren = [NSMutableArray array];
xmlNodePtr theCurrentNode = _node->children;
while (theCurrentNode != NULL)
	{
	CXMLNode *theNode = [CXMLNode nodeWithLibXMLNode:theCurrentNode];
	[theChildren addObject:theNode];
	theCurrentNode = theCurrentNode->next;
	}
return(theChildren);      
}

- (CXMLNode *)childAtIndex:(NSUInteger)index
{
NSAssert(_node != NULL, @"TODO");

xmlNodePtr theCurrentNode = _node->children;
NSUInteger N;
for (N = 0; theCurrentNode != NULL && N != index; ++N, theCurrentNode = theCurrentNode->next)
	;
if (theCurrentNode)
	return([CXMLNode nodeWithLibXMLNode:theCurrentNode]);
return(NULL);
}

- (CXMLNode *)previousSibling
{
NSAssert(_node != NULL, @"TODO");

if (_node->prev == NULL)
	return(NULL);
else
	return([CXMLNode nodeWithLibXMLNode:_node->prev]);
}

- (CXMLNode *)nextSibling
{
NSAssert(_node != NULL, @"TODO");

if (_node->next == NULL)
	return(NULL);
else
	return([CXMLNode nodeWithLibXMLNode:_node->next]);
}

//- (CXMLNode *)previousNode;
//- (CXMLNode *)nextNode;
//- (NSString *)XPath;
//- (NSString *)localName;
//- (NSString *)prefix;
//- (NSString *)URI;
//+ (NSString *)localNameForName:(NSString *)name;
//+ (NSString *)prefixForName:(NSString *)name;
//+ (CXMLNode *)predefinedNamespaceForPrefix:(NSString *)name;

- (NSString *)description
{
NSAssert(_node != NULL, @"TODO");

	return([NSString stringWithFormat:@"<%@ %p [%p] %@ %@>", NSStringFromClass([self class]), self, self->_node, [self name], [self XMLStringWithOptions:0]]);
}

- (NSString *)XMLString
{
return [self XMLStringWithOptions:0];
}


- (NSString*)_XMLStringWithOptions:(NSUInteger)options appendingToString:(NSMutableString*)str
{
id value;
switch([self kind])
	{
	case CXMLAttributeKind:
		value = [NSMutableString stringWithString:[self stringValue]];
		[value replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:0 range:NSMakeRange(0, [value length])];
		[str appendFormat:@" %@=\"%@\"", [self name], value];
		break;
	case CXMLTextKind:
		[str appendString:[self stringValue]];
		break;
	case XML_COMMENT_NODE:
	case XML_CDATA_SECTION_NODE:
		// TODO: NSXML does not have XML_CDATA_SECTION_NODE correspondent.
		break;
	default:
		NSAssert1(NO, @"TODO not implemented type (%d).",  [self kind]);
	}
return str;
}

- (NSString *)XMLStringWithOptions:(NSUInteger)options
{
return [self _XMLStringWithOptions:options appendingToString:[NSMutableString string]];
}
//- (NSString *)canonicalXMLStringPreservingComments:(BOOL)comments;

- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error
{
NSAssert(_node != NULL, @"TODO");

NSArray *theResult = NULL;

CXMLNode *theRootDocument = [self rootDocument];
xmlXPathContextPtr theXPathContext = xmlXPathNewContext((xmlDocPtr)theRootDocument->_node);
theXPathContext->node = _node;

// TODO considering putting xmlChar <-> UTF8 into a NSString category
xmlXPathObjectPtr theXPathObject = xmlXPathEvalExpression((const xmlChar *)[xpath UTF8String], theXPathContext);
if (xmlXPathNodeSetIsEmpty(theXPathObject->nodesetval))
	theResult = [NSArray array]; // TODO better to return NULL?
else
	{
	NSMutableArray *theArray = [NSMutableArray array];
	int N;
	for (N = 0; N < theXPathObject->nodesetval->nodeNr; N++)
		{
		xmlNodePtr theNode = theXPathObject->nodesetval->nodeTab[N];
		[theArray addObject:[CXMLNode nodeWithLibXMLNode:theNode]];
		}
		
	theResult = theArray;
	}

xmlXPathFreeObject(theXPathObject);
xmlXPathFreeContext(theXPathContext);
return(theResult);
}

//- (NSArray *)objectsForXQuery:(NSString *)xquery constants:(NSDictionary *)constants error:(NSError **)error;
//- (NSArray *)objectsForXQuery:(NSString *)xquery error:(NSError **)error;


@end
