#import <TVSystemMenuUI/TVSMModuleContentViewControllerDelegate.h>
#import <TVSystemMenuUI/TVSMModuleContentViewController.h>
#import <TVSystemMenuUI/TVSMActionModule.h>
#import <TVSystemMenuUI/TVSMButtonViewController.h>
#import <objc/runtime.h>

@import ReplayKit;
@import UIKit;
@import AVFoundation;
@import AudioToolbox;

// Sound files :P
NSString *recordingStarted = [[NSBundle bundleWithPath:@"/Library/TVSystemMenuModules/ScreenRecordModule.bundle/"] pathForResource:@"recordingStarted" ofType:@"caf"];
NSString *recordingStopped = [[NSBundle bundleWithPath:@"/Library/TVSystemMenuModules/ScreenRecordModule.bundle/"] pathForResource:@"recordingStopped" ofType:@"caf"];


// screen recording file path
NSString *videoPath;

// setting this up allows us to call the private methods if need be 
@interface RPScreenRecorder (Private)
@property (nonatomic,retain) UIWindow * windowToRecord;  
@property (assign,nonatomic) BOOL systemRecording;  
-(void)setWindowToRecord:(UIWindow *)windowToRecord;
-(void)startSystemRecordingWithMicrophoneEnabled:(BOOL)arg1 handler:(/*^block*/id)arg2;
-(void)stopSystemRecording:(/*^block*/id)arg1;
-(NSURL *)broadcastURL;
@end


// show a bulletin when done!
@interface NSDistributedNotificationCenter : NSNotificationCenter
+(id)defaultCenter;
-(void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4;
-(void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3;
@end

//14+ code (thanks nitoTV)
@interface TVSMButtonViewController (science)
@property (assign,nonatomic) BOOL toggledOn API_AVAILABLE(tvos(14.0));
@property (nonatomic,copy) UIColor *symbolTintColor API_AVAILABLE(tvos(14.0));
@end

// Control Center manager
@interface TVSMSystemMenuManager : NSObject
-(void)dismissSystemMenu;
@end

// Our control center module!
@interface ScreenRecordModule : TVSMActionModule <RPScreenRecorderDelegate> {
	// ivars
    NSString *packageFile;
    TVSMButtonViewController *buttonController;
    UIImage *theImage;
	AVAudioPlayer *player;
	AVAudioPlayer *player2;
	NSMutableDictionary *dict;
	NSString *notificationImageFile;
	UIImage *notificationImage; 
	NSData *imageData;
    RPScreenRecorder *_screenRecorder;
    UIViewController<TVSMModuleContentViewController> *_recordingContentViewController;
    UIColor *defaultColor;
}
@property (retain, nonatomic) RPScreenRecorder *screenRecorder;
@property (retain, nonatomic) UIViewController<TVSMModuleContentViewController> *recordingContentViewController;
@property (retain, nonatomic) UIAlertController *recordingDoneAlertController;
+(long long)buttonStyle;
-(id)contentViewController;
-(void)handleAction;
-(void)dismissControlCenterAfterRecording;
-(BOOL)dismissAfterAction;
-(BOOL)darkMode;
-(void)setupImageBasedOnToggleStatus;
-(void)playRecordingStarted;
-(void)playRecordingStopped;
-(void)showAlertToUser;
-(void)startRecording;
-(void)stopRecording;
-(void)airdropVideo;
@end
