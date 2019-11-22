#import <Foundation/Foundation.h>
#import "DSObject.h"

/**
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen
 * Do not edit the class manually.
 */

#import "DSNameValue.h"


@protocol DSLoginAccount
@end

@interface DSLoginAccount : DSObject

/* The name associated with the account. [optional]
 */
@property(nonatomic) NSString* name;
/* The account ID associated with the envelope. [optional]
 */
@property(nonatomic) NSString* accountId;
/* The GUID associated with the account ID. [optional]
 */
@property(nonatomic) NSString* accountIdGuid;
/* The URL that should be used for successive calls to this account. It includes the protocal (https), the DocuSign server where the account is located, and the account number. Use this Url to make API calls against this account. Many of the API calls provide Uri's that are relative to this baseUrl. [optional]
 */
@property(nonatomic) NSString* baseUrl;
/* This value is true if this is the default account for the user, otherwise false is returned. [optional]
 */
@property(nonatomic) NSString* isDefault;
/* The name of this user as defined by the account. [optional]
 */
@property(nonatomic) NSString* userName;
/*  [optional]
 */
@property(nonatomic) NSString* userId;
/*  [optional]
 */
@property(nonatomic) NSString* email;
/* An optional descirption of the site that hosts the account. [optional]
 */
@property(nonatomic) NSString* siteDescription;
/* A list of settings on the acccount that indicate what features are available. [optional]
 */
@property(nonatomic) NSArray<DSNameValue>* loginAccountSettings;
/* A list of user-level settings that indicate what user-specific features are available. [optional]
 */
@property(nonatomic) NSArray<DSNameValue>* loginUserSettings;

@end
