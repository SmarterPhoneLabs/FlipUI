/*
	SQLSTUDIOtbl_Crime_Type_Result.h
	The interface definition of properties and methods for the SQLSTUDIOtbl_Crime_Type_Result object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface SQLSTUDIOtbl_Crime_Type_Result : SoapObject
{
	int _Crime_Type_ID;
	NSString* _Crime_Type_Name;
	NSString* _ssImage_Crime_Type_Image;
	
}
		
	@property int Crime_Type_ID;
	@property (retain, nonatomic) NSString* Crime_Type_Name;
	@property (retain, nonatomic) NSString* ssImage_Crime_Type_Image;

	+ (SQLSTUDIOtbl_Crime_Type_Result*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end