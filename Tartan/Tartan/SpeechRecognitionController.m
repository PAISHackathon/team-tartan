//
//  SpeechRecognitionController.m
//  Tartan
//
//  Created by Smith, Donnie on 2017/10/20.
//  Copyright © 2017 Rakuten. All rights reserved.
//

#import "SpeechRecognitionController.h"
#import <Speech/Speech.h>

@interface SpeechRecognitionController()
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@end

@implementation SpeechRecognitionController

- (instancetype)initSpeechRecognition
{
    if (self = [super init])
    {
        _speechRecognizer = SFSpeechRecognizer.new;
        _recognitionRequest = SFSpeechAudioBufferRecognitionRequest.new;
        _audioEngine = AVAudioEngine.new;
    }
    return self;
}

- (void)recordWithCompletionHandler:(void (^)(NSString *, NSError *))completionHandler
{
    [self _stopListening];
    [self _startListeningWithCompletionHandler:completionHandler];
}

- (void)_stopListening
{
    if (_audioEngine.isRunning)
    {
        [_audioEngine stop];
        [_recognitionRequest endAudio];
        [_audioEngine.inputNode removeTapOnBus:0];
    }
}

- (void)_startListeningWithCompletionHandler:(void (^)(NSString *, NSError *))completionHandler
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
        
        if (result && _recognitionTask.state <= SFSpeechRecognitionTaskStateFinishing)
        {
            NSString *speechString = result.bestTranscription.formattedString;
            NSLog(@"Best transcription %@", speechString);
            
            if (speechString.length)
            {
                [self _stopListening];
                [_recognitionTask cancel];
                completionHandler(speechString, error);
            }
        }
        else if (error)
        {
            NSLog(@"Error %@", error);
        }
    }];
}

@end
