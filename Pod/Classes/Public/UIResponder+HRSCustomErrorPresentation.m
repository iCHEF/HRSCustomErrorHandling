//
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//

#import "UIResponder+HRSCustomErrorPresentation.h"

#import "HRSErrorCoalescingQueue.h"


@implementation UIResponder (HRSCustomErrorPresentation)

- (void)presentError:(NSError *)error completionHandler:(void (^)(BOOL didRecover))completionHandler
{
	error = [self willPresentError:error];
	
	if (error == nil) {
		return;
	}
	
	UIApplication *application = [UIApplication sharedApplication];
	BOOL responderDelegateUnavailable = ![application.delegate isKindOfClass:[UIResponder class]];
	
	if (application.delegate == self ||
		(application == self && responderDelegateUnavailable)) {
		// this is the default implementation of the app delegate or the
		// application itself, if its delegate does not inherit from UIResponder.
        [[HRSErrorCoalescingQueue defaultQueue] addError:error completionHandler:completionHandler];
		
	} else {
		UIResponder *nextResponder = ([self nextResponder] ?: [UIApplication sharedApplication]);
		[nextResponder presentError:error completionHandler:completionHandler];
	}
}

- (void)presentError:(NSError *)error onViewController:(UIViewController *)viewController completionHandler:(void (^)(BOOL didRecover))completionHandler
{
	error = [self willPresentError:error];
	
	if (error == nil) {
		return;
	}
	
	UIApplication *application = [UIApplication sharedApplication];
	BOOL responderDelegateUnavailable = ![application.delegate isKindOfClass:[UIResponder class]];
	
	if (application.delegate == self ||
		(application == self && responderDelegateUnavailable)) {
		// this is the default implementation of the app delegate or the
		// application itself, if its delegate does not inherit from UIResponder.
		if (viewController.isViewLoaded && viewController.view.window) {
			// if the view controller's view is visible, present the error,
			// otherwise suppress the error!
            [[HRSErrorCoalescingQueue defaultQueue] addError:error completionHandler:completionHandler];
		} else {
			if (completionHandler != NULL) {
				// make sure the completion handler is always called
				// asynchronously to prevent errors.
				dispatch_async(dispatch_get_main_queue(), ^{
					completionHandler(NO);
				});
			}
		}
		
	} else {
		UIResponder *nextResponder = ([self nextResponder] ?: [UIApplication sharedApplication]);
		[nextResponder presentError:error onViewController:viewController completionHandler:completionHandler];
	}
}

- (NSError *)willPresentError:(NSError *)error
{
	return error;
}

@end
