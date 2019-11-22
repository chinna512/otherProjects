#import <Foundation/Foundation.h>
#import "ISO8601.h"
#import "AFHTTPRequestOperationManager.h"
#import "DSJSONResponseSerializer.h"
#import "DSJSONRequestSerializer.h"
#import "DSQueryParamCollection.h"
#import "DSConfiguration.h"

/**
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen
 * Do not edit the class manually.
 */

#import "DSServiceInformation.h"
#import "DSServiceVersion.h"
#import "DSErrorDetails.h"
#import "DSResourceInformation.h"
#import "DSNameValue.h"
#import "DSAccountInformation.h"
#import "DSCustomFields.h"
#import "DSTextCustomField.h"
#import "DSListCustomField.h"
#import "DSFileTypeList.h"
#import "DSFileType.h"
#import "DSEnvelopesInformation.h"
#import "DSEnvelope.h"
#import "DSNotification.h"
#import "DSReminders.h"
#import "DSExpirations.h"
#import "DSEmailSettings.h"
#import "DSBccEmailAddress.h"
#import "DSLockInformation.h"
#import "DSUserInfo.h"
#import "DSEnvelopeTransactionStatus.h"
#import "DSEnvelopeDefinition.h"
#import "DSDocument.h"
#import "DSMatchBox.h"
#import "DSRecipients.h"
#import "DSSigner.h"
#import "DSRecipientSignatureInformation.h"
#import "DSTabs.h"
#import "DSSignHere.h"
#import "DSMergeField.h"
#import "DSInitialHere.h"
#import "DSSignerAttachment.h"
#import "DSApprove.h"
#import "DSDecline.h"
#import "DSFullName.h"
#import "DSDateSigned.h"
#import "DSEnvelopeId.h"
#import "DSCompany.h"
#import "DSTitle.h"
#import "DSText.h"
#import "Number.h"
#import "DSSsn.h"
#import "Date.h"
#import "DSZip.h"
#import "DSEmail.h"
#import "DSNote.h"
#import "DSCheckbox.h"
#import "DSRadioGroup.h"
#import "DSRadio.h"
#import "DSList.h"
#import "DSListItem.h"
#import "DSFirstName.h"
#import "DSLastName.h"
#import "DSEmailAddress.h"
#import "DSFormulaTab.h"
#import "DSOfflineAttributes.h"
#import "DSSocialAuthentication.h"
#import "DSRecipientPhoneAuthentication.h"
#import "DSRecipientSAMLAuthentication.h"
#import "DSSamlAssertionAttribute.h"
#import "DSRecipientSMSAuthentication.h"
#import "DSIdCheckInformationInput.h"
#import "DSAddressInformationInput.h"
#import "DSAddressInformation.h"
#import "DSDobInformationInput.h"
#import "DSSsn4InformationInput.h"
#import "DSSsn9InformationInput.h"
#import "DSAttachment.h"
#import "DSRecipientEmailNotification.h"
#import "DSAuthenticationStatus.h"
#import "DSEventResult.h"
#import "DSAgent.h"
#import "DSEditor.h"
#import "DSIntermediary.h"
#import "DSCarbonCopy.h"
#import "DSCertifiedDelivery.h"
#import "DSInPersonSigner.h"
#import "DSEventNotification.h"
#import "DSEnvelopeEvent.h"
#import "DSRecipientEvent.h"
#import "DSTemplateRole.h"
#import "DSCompositeTemplate.h"
#import "DSServerTemplate.h"
#import "DSInlineTemplate.h"
#import "DSEnvelopeSummary.h"
#import "DSEnvelopeIdsRequest.h"
#import "DSEnvelopeUpdateSummary.h"
#import "DSBulkEnvelopeStatus.h"
#import "DSBulkEnvelope.h"
#import "DSReturnUrlRequest.h"
#import "DSViewUrl.h"
#import "DSCorrectViewRequest.h"
#import "DSRecipientViewRequest.h"
#import "DSViewLinkRequest.h"
#import "DSEnvelopeAuditEventResponse.h"
#import "DSEnvelopeAuditEvent.h"
#import "DSCustomFieldsEnvelope.h"
#import "DSLockRequest.h"
#import "DSTemplateInformation.h"
#import "DSTemplateSummary.h"
#import "DSTemplateMatch.h"
#import "DSDocumentTemplateList.h"
#import "DSDocumentTemplate.h"
#import "DSEnvelopeDocumentsResult.h"
#import "DSEnvelopeDocument.h"
#import "DSSignatureType.h"
#import "DSDocumentFieldsInformation.h"
#import "DSRecipientsUpdateSummary.h"
#import "DSRecipientUpdateResponse.h"
#import "DSFoldersResponse.h"
#import "DSFolder.h"
#import "DSFilter.h"
#import "DSFolderItemsResponse.h"
#import "DSFolderItem.h"
#import "DSCustomFieldV2.h"
#import "DSFoldersRequest.h"
#import "DSFolderItemResponse.h"
#import "DSFolderItemV2.h"
#import "DSAccountSettingsInformation.h"
#import "DSAccountSharedAccess.h"
#import "DSMemberSharedItems.h"
#import "DSSharedItem.h"
#import "DSEnvelopeTemplate.h"
#import "DSEnvelopeTemplateDefinition.h"
#import "DSEnvelopeTemplateResults.h"
#import "DSEnvelopeTemplateResult.h"
#import "DSTemplateUpdateSummary.h"
#import "DSTemplateCustomFields.h"
#import "DSTemplateNotificationRequest.h"
#import "DSTemplateDocumentsResult.h"
#import "DSPageRequest.h"
#import "DSTemplateRecipients.h"
#import "DSTemplateTabs.h"
#import "DSGroupInformation.h"
#import "DSGroup.h"
#import "DSUserSettingsInformation.h"
#import "DSSignerEmailNotifications.h"
#import "DSSenderEmailNotifications.h"
#import "DSConsoleViewRequest.h"
#import "DSTabMetadataList.h"
#import "DSTabMetadata.h"
#import "DSApiRequestLogsResult.h"
#import "DSApiRequestLog.h"
#import "DSDiagnosticsSettingsInformation.h"
#import "DSLoginInformation.h"
#import "DSLoginAccount.h"


@class DSConfiguration;

/**
 * A key for `NSError` user info dictionaries.
 *
 * The corresponding value is the parsed response body for an HTTP error.
 */
extern NSString *const DSResponseObjectErrorKey;

/**
 * Log debug message macro
 */
#define DSDebugLog(format, ...) [DSApiClient debugLog:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] message: format, ##__VA_ARGS__];

@interface DSApiClient : AFHTTPRequestOperationManager

@property(nonatomic, assign) NSURLRequestCachePolicy cachePolicy;
@property(nonatomic, assign) NSTimeInterval timeoutInterval;
@property(nonatomic, readonly) NSOperationQueue* queue;

/// In order to ensure the HTTPResponseHeaders are correct, it is recommended to initialize one DSApiClient instance per thread.
@property(nonatomic, readonly) NSDictionary* HTTPResponseHeaders;

/**
 * Clears Cache
 */
+(void)clearCache;

/**
 * Turns on cache
 *
 * @param enabled If the cached is enable, must be `YES` or `NO`
 */
+(void)setCacheEnabled:(BOOL) enabled;

/**
 * Gets the request queue size
 *
 * @return The size of `queuedRequests` static variable.
 */
+(unsigned long)requestQueueSize;

/**
 * Sets the client unreachable
 *
 * @param state off line state, must be `YES` or `NO`
 */
+(void) setOfflineState:(BOOL) state;

/**
 * Gets the client reachability
 *
 * @return The client reachability.
 */
+(AFNetworkReachabilityStatus) getReachabilityStatus;

/**
 * Gets the next request id
 *
 * @return The next executed request id.
 */
+(NSNumber*) nextRequestId;

/**
 * Generates request id and add it to the queue
 *
 * @return The next executed request id.
 */
+(NSNumber*) queueRequest;

/**
 * Removes request id from the queue
 *
 * @param requestId The request which will be removed.
 */
+(void) cancelRequest:(NSNumber*)requestId;

/**
 * Gets URL encoded NSString
 *
 * @param unescaped The string which will be escaped.
 *
 * @return The escaped string.
 */
+(NSString*) escape:(id)unescaped;

/**
 * Customizes the behavior when the reachability changed
 *
 * @param changeBlock The block will be executed when the reachability changed.
 */
+(void) setReachabilityChangeBlock:(void(^)(int))changeBlock;

/**
 * Sets the api client reachability strategy
 */
- (void)configureCacheReachibility;

/**
 * Detects Accept header from accepts NSArray
 *
 * @param accepts NSArray of header
 *
 * @return The Accept header
 */
+(NSString *) selectHeaderAccept:(NSArray *)accepts;

/**
 * Detects Content-Type header from contentTypes NSArray
 *
 * @param contentTypes NSArray of header
 *
 * @return The Content-Type header
 */
+(NSString *) selectHeaderContentType:(NSArray *)contentTypes;

/**
 * Sets header for request
 *
 * @param value The header value
 * @param forKey The header key
 */
-(void)setHeaderValue:(NSString*) value
               forKey:(NSString*) forKey;

/**
 * Updates header parameters and query parameters for authentication
 *
 * @param headers The header parameter will be udpated, passed by pointer to pointer.
 * @param querys The query parameters will be updated, passed by pointer to pointer.
 * @param authSettings The authentication names NSArray.
 */
- (void) updateHeaderParams:(NSDictionary **)headers
                queryParams:(NSDictionary **)querys
           WithAuthSettings:(NSArray *)authSettings;

/**
 * Deserializes the given data to Objective-C object.
 *
 * @param data The data will be deserialized.
 * @param class The type of objective-c object.
 */
- (id) deserialize:(id) data class:(NSString *) class;

/**
 * Logs request and response
 *
 * @param operation AFHTTPRequestOperation for the HTTP request.
 * @param request   The HTTP request.
 * @param error     The error of the HTTP request.
 */
- (void)logResponse:(AFHTTPRequestOperation *)operation
         forRequest:(NSURLRequest *)request
              error:(NSError *)error;

/**
 * Performs request
 *
 * @param path Request url.
 * @param method Request method.
 * @param pathParams Request path parameters.
 * @param queryParams Request query parameters.
 * @param body Request body.
 * @param headerParams Request header parameters.
 * @param authSettings Request authentication names.
 * @param requestContentType Request content-type.
 * @param responseContentType Response content-type.
 * @param completionBlock The block will be executed when the request completed.
 *
 * @return The request id.
 */
-(NSNumber*) requestWithPath:(NSString*) path
                      method:(NSString*) method
                  pathParams:(NSDictionary *) pathParams
                 queryParams:(NSDictionary*) queryParams
                  formParams:(NSDictionary *) formParams
                       files:(NSDictionary *) files
                        body:(id) body
                headerParams:(NSDictionary*) headerParams
                authSettings:(NSArray *) authSettings
          requestContentType:(NSString*) requestContentType
         responseContentType:(NSString*) responseContentType
                responseType:(NSString *) responseType
             completionBlock:(void (^)(id, NSError *))completionBlock;

/**
 * Sanitize object for request
 *
 * @param object The query/path/header/form/body param to be sanitized.
 */
- (id) sanitizeForSerialization:(id) object;

/**
 * Custom security policy
 *
 * @return AFSecurityPolicy
 */
- (AFSecurityPolicy *) customSecurityPolicy;

/**
 * Convert parameter to NSString
 */
- (NSString *) parameterToString: (id) param;

/**
 * Log debug message
 */
+(void)debugLog:(NSString *)method message:(NSString *)format, ...;

@end
