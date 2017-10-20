//
//  TodayViewController.m
//  Tartan Today
//
//  Created by Ta, Viet | Vito | GHRD on 10/20/17.
//  Copyright © 2017 Rakuten. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "FetchItemURLController.h"

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _speechRecognizer = SFSpeechRecognizer.new;
    _recognitionRequest = SFSpeechAudioBufferRecognitionRequest.new;
    _audioEngine = AVAudioEngine.new;
    [_inputTextField addTarget:self
                        action:@selector(editingChanged:)
              forControlEvents:UIControlEventEditingChanged];
    _searchButton.enabled = [self checkSearchButtonEnable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editingChanged:(id)sender
{
    _searchButton.enabled = [self checkSearchButtonEnable];
}

- (BOOL)checkSearchButtonEnable
{
    return self.inputTextField.text.length > 0;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
}

- (IBAction)tapOnMicrophone:(id)sender {
    NSLog(@"hello mic");

    NSURL *speechURL = [[NSURL alloc] initWithString:@"tartanapp://speech-search"];
    if (speechURL) {
        [self.extensionContext openURL:speechURL completionHandler:^(BOOL success) {
            if (!success)
                NSLog(@"Failed to open URL %@", speechURL);
        }];
    }
}

- (IBAction)tapOnCamera:(id)sender {
    NSLog(@"hello camera");

    NSURL *cameraURL = [[NSURL alloc] initWithString:@"tartanapp://camera-search"];
    if (cameraURL) {
        [self.extensionContext openURL:cameraURL completionHandler:^(BOOL success) {

        }];
    }
}

- (IBAction)tapOnPhoto:(id)sender {
}

- (IBAction)tapOnSearch:(id)sender {
    if (self.inputTextField.text.length) {

    }
}


- (void)_record
{
    if (_audioEngine.isRunning)
    {
        [_audioEngine stop];
        [_recognitionRequest endAudio];
        [_audioEngine.inputNode removeTapOnBus:0];
        self.navigationItem.rightBarButtonItem.title = @"Record";
    }
    else
    {
        [self _startListening];
        self.navigationItem.rightBarButtonItem.title = @"Stop";
    }
}

- (void)_startListening
{
    AVAudioInputNode *inputNode = _audioEngine.inputNode;
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [_recognitionRequest appendAudioPCMBuffer:buffer];
    }];

    [_audioEngine prepare];
    NSError *error;
    BOOL started = [_audioEngine startAndReturnError:&error];
    if (started)
    {
        NSLog(@"Say something, I'm listening");
    }
    else
    {
        NSLog(@"Error %@", error);
        return;
    }

    _recognitionTask = [_speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {

        if (result)
        {
            NSLog(@"Best transcription %@", result.bestTranscription.formattedString);
        }
        else if (error)
        {
            NSLog(@"Error %@", error);
        }
    }];
}

@end
