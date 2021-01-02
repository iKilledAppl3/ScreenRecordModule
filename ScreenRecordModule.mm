#import "ScreenRecordModule.h"
// the actaul module part!
@implementation ScreenRecordModule

+(long long)buttonStyle {
    return 1;
}

-(id)contentViewController {
    
    buttonController = (TVSMButtonViewController*)[super contentViewController];
    [buttonController setStyle:1];
    [self setupImageBasedOnToggleStatus];
    return buttonController;
    
}

-(void)handleAction {
    // setup the recorder using its sharedRecorder instance
    self.screenRecorder = [RPScreenRecorder sharedRecorder];
    // check to see if it's recording or not!
    // if it isn't start recording!
    if (!self.screenRecorder.isRecording) {
    [self startRecording];
    [self performSelector:@selector(playRecordingStarted) withObject:nil afterDelay:0.5];
     if (@available(tvOS 14.0, *)) {
            [buttonController setSymbolTintColor:[UIColor redColor]];
            [buttonController setToggledOn:true];
        } 
}

    if (self.screenRecorder.isRecording) {
        // if the screen recorder is recording stop it and save it to the camera roll! by default Apple does this!
        [self playRecordingStopped];
        [self stopRecording];
        [self showAlertToUser];
        
    }

}


-(void)setupImageBasedOnToggleStatus {

    packageFile = [[self bundle] pathForResource:@"Record" ofType:@"png"];
    theImage = [[UIImage imageWithContentsOfFile:packageFile] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [buttonController setImage:theImage];
    if([[RPScreenRecorder sharedRecorder] isRecording]) {
        if (@available(tvOS 14.0, *)) {
            [buttonController setSymbolTintColor:[UIColor redColor]];
            [buttonController setToggledOn:true];
        }
    } else {
        if (@available(tvOS 14.0, *)) {
            [buttonController setSymbolTintColor:nil];
            [buttonController setToggledOn:false];
        }
    }
}



-(void)startRecording {
    // Starts recording with the microphone enabled (by default this must be enabled in order for us to get audio from the Apple TV.)
 [self.screenRecorder startSystemRecordingWithMicrophoneEnabled:YES handler:nil];

  /*record the screen by setting the UIWindow to record the contentView of the TVSMModuleContentViewController. 
    This is how Apple does it with their private one found in internal installs! */
    [self.screenRecorder setWindowToRecord:self.recordingContentViewController.view.window];

    // dismiss the cc after 3 seconds have past.
    [self performSelector:@selector(dismissControlCenterAfterRecording) withObject:nil afterDelay:3.0];
}

-(void)stopRecording {
[self.screenRecorder stopSystemRecording:(/*^block*/id)nil];

     // dismiss the cc after 1 second has past.
    [self dismissControlCenterAfterRecording];

     if (@available(tvOS 14.0, *)) {
        [buttonController setSymbolTintColor:defaultColor];
        [buttonController setToggledOn:false];
    }

}


//easier to track light/dark mode (thanks nitoTV)
-(BOOL)darkMode {
    return (buttonController.view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
}


-(void)airdropVideo {
// screen recordings save to this directory by default.	
videoPath = [NSString stringWithFormat:@"/var/mobile/Media/DCIM/100APPLE/"];

// here we are initializing Breezy and getting ready to AirDrop the screen recording(s)
NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"airdropper://%@", videoPath]];
UIApplication *application = [UIApplication sharedApplication];
[application openURL:url options:@{} completionHandler:nil];

}


-(void)playRecordingStarted {
 if (!player) {
       player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordingStarted] error:nil];
        player.volume = 1.0;
        [player prepareToPlay];
        [player play];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
     }

}


-(void)playRecordingStopped {
 if (!player2) {
       player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordingStopped] error:nil];
        player2.volume = 1.0;
        [player2 prepareToPlay];
        [player2 play];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
     }
}


-(void)showAlertToUser {
    // thanks nitoTV!
    // let user know recording has finished!
    dict = [NSMutableDictionary new]; 
    dict[@"message"] = @"AirDrop Package Inbound";
    dict[@"title"] = @"Screen Recording Done!";
    dict[@"timeout"] = @3;
    notificationImageFile =[[self bundle] pathForResource:@"RecordNotif" ofType:@"png"];
    notificationImage = [UIImage imageWithContentsOfFile:notificationImageFile];
    imageData = UIImagePNGRepresentation(notificationImage);
        if (imageData) {
        dict[@"imageData"] = imageData;
}


[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.nito.bulletinh4x/displayBulletin" object:nil userInfo:dict];
        
    //prepare the video for airdrop   
    [self airdropVideo];

}

// dismisses the control center when we want it to 
-(void)dismissControlCenterAfterRecording {
    id controlCenter = [NSClassFromString(@"TVSMSystemMenuManager") sharedInstance];
    [controlCenter dismissSystemMenu];

}

// I'm returning no on this because i want the control center open for at least 3 seconds before it closes.
-(BOOL)dismissAfterAction {
    return NO;
}

@end
