/*
	SQLSTUDIOtbl_Booking_Result_V2.h
	The interface definition of properties and methods for the SQLSTUDIOtbl_Booking_Result_V2 object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface SQLSTUDIOtbl_Booking_Result_V2 : SoapObject
{
	NSString* _Ad_URL;
	NSDecimalNumber* _Bond_Amount;
	int _Booking_ID;
	NSDecimalNumber* _Booking_Lat;
	NSDecimalNumber* _Booking_Long;
	int _Booking_Status;
	NSString* _Charge;
	int _Crime_Type;
	NSString* _Crime_Type_Image;
	NSDate* _Date_Of_Birth;
	NSDate* _Date_Of_Offense;
	NSString* _First_Name;
	BOOL _Is_Ad;
	NSString* _Last_Name;
	int _Market_ID;
	int _Sex;
	NSString* _Story;
	int _Views;
	NSString* _ssImage_Booking_Image_1;
	NSString* _ssImage_Booking_Image_2;
	
}
		
	@property (retain, nonatomic) NSString* Ad_URL;
	@property (retain, nonatomic) NSDecimalNumber* Bond_Amount;
	@property int Booking_ID;
	@property (retain, nonatomic) NSDecimalNumber* Booking_Lat;
	@property (retain, nonatomic) NSDecimalNumber* Booking_Long;
	@property int Booking_Status;
	@property (retain, nonatomic) NSString* Charge;
	@property int Crime_Type;
	@property (retain, nonatomic) NSString* Crime_Type_Image;
	@property (retain, nonatomic) NSDate* Date_Of_Birth;
	@property (retain, nonatomic) NSDate* Date_Of_Offense;
	@property (retain, nonatomic) NSString* First_Name;
	@property BOOL Is_Ad;
	@property (retain, nonatomic) NSString* Last_Name;
	@property int Market_ID;
	@property int Sex;
	@property (retain, nonatomic) NSString* Story;
	@property int Views;
	@property (retain, nonatomic) NSString* ssImage_Booking_Image_1;
	@property (retain, nonatomic) NSString* ssImage_Booking_Image_2;

	+ (SQLSTUDIOtbl_Booking_Result_V2*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
