//
//  ViewController.m
//  MP1_Mobile_sensor
//
//  Created by Yifang Zhang on 9/3/16.
//  Copyright © 2016 Yifang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init the dictionaries
    self.collectAcc = [[NSMutableArray alloc] init];
    [self.collectAcc addObject:@"timestamp,Acc_x,Acc_y,Acc_z\n"];
    self.collectGyro = [[NSMutableArray alloc] init];
    [self.collectGyro addObject:@"timestamp,Gyro_x,Gyro_y,Gyro_z\n"];
    self.collectMag = [[NSMutableArray alloc] init];
    [self.collectMag addObject:@"timestamp,Mag_x,Mag_y,Mag_z\n"];
    
    // init the motion manager
    self.motionManager = [[CMMotionManager alloc] init];
    
    
    self.acc_x.text = @"0";
    self.acc_y.text = @"0";
    self.acc_z.text = @"0";
    self.gyro_x.text = @"0";
    self.gyro_y.text = @"0";
    self.gyro_z.text = @"0";
    self.mag_x.text = @"0";
    self.mag_y.text = @"0";
    self.mag_z.text = @"0";
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.motionManager.accelerometerUpdateInterval = 0.01;
    self.motionManager.gyroUpdateInterval = 0.01;
    self.motionManager.magnetometerUpdateInterval = 0.01;
    
    // set the time to the correct format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy_HH-mm-ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.timestamp.text = [dateFormatter stringFromDate:[NSDate date]];

    // init with flag as false
    self.flag = false;
    
    // init the temp file of csv
    self.tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", self.timestamp.text]];
    NSLog(self.tempFilePath);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)switcher:(id)sender {
    if(self.flag == false){
        self.flag = true;
        //[self.motionManager startAccelerometerUpdates];
        [
        self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
            withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error)
        {
            [self outputAccelertionData:accelerometerData.acceleration];
            if(error){
                NSLog(@"%@", error);
            }
        }
        ];
        [
         self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]withHandler:^(CMGyroData *gyroData, NSError *error) {
             [self outputGyroData:gyroData.rotationRate];
             if(error){
                 NSLog(@"%@", error);
             }
         }
         
         ];
        
        [
         self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
             [self outputMagData:magnetometerData.magneticField];
             if(error){
                 NSLog(@"%@", error);
             }
         }
         
         ];
    }
    else{
        [self.motionManager stopAccelerometerUpdates];
        [self.motionManager stopGyroUpdates];
        [self.motionManager stopMagnetometerUpdates];
        self.flag = false;
        NSLog(@"%lu", (unsigned long)[self.collectAcc count]);
    }

}

- (IBAction)sendMail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        // device is configured to send mail
    
        NSString * writeString = @"";
        for (NSString * acc in self.collectAcc) {
            writeString = [NSString stringWithFormat:@"%@%@", writeString, acc];
        }
        for (NSString * gyro in self.collectGyro) {
            writeString = [NSString stringWithFormat:@"%@%@", writeString, gyro];
        }
        for (NSString * mag in self.collectMag) {
            writeString = [NSString stringWithFormat:@"%@%@", writeString, mag];
        }
        NSData* writeData = [writeString dataUsingEncoding:NSUTF8StringEncoding];
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setMessageBody:@"Here is some main text in the email!" isHTML:NO];
        [mailer setToRecipients:@[@"yifangzhang2009@gmail.com", @"aaronmann613348@gmail.com"]];
        [mailer setSubject:@"CSV File"];
        [mailer addAttachmentData:writeData
                         mimeType:@"text/csv"
                         fileName:@"FileName.csv"];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The Mail is not Avaliable"
                                                        message:@"You need open up the Mail app and set up account in order to use the mail sending functionality."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}


-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    self.acc_x.text = [NSString stringWithFormat:@"%f", acceleration.x];
    self.acc_y.text = [NSString stringWithFormat:@"%f", acceleration.y];
    self.acc_z.text = [NSString stringWithFormat:@"%f", acceleration.z];
    
    // set the time to the correct format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy_HH-mm-ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.timestamp.text = [dateFormatter stringFromDate:[NSDate date]];
    [self.collectAcc addObject:[NSString stringWithFormat:@"%@,%@,%@,%@\n", self.timestamp.text, self.acc_x.text, self.acc_y.text, self.acc_z.text]];
}

-(void)outputGyroData:(CMRotationRate)rotationRate
{
    self.gyro_x.text = [NSString stringWithFormat:@"%f", rotationRate.x];
    self.gyro_y.text = [NSString stringWithFormat:@"%f", rotationRate.y];
    self.gyro_z.text = [NSString stringWithFormat:@"%f", rotationRate.z];
    
    // set the time to the correct format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy_HH-mm-ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.timestamp.text = [dateFormatter stringFromDate:[NSDate date]];
    [self.collectGyro addObject:[NSString stringWithFormat:@"%@,%@,%@,%@\n", self.timestamp.text, self.gyro_x.text, self.gyro_y.text, self.gyro_z.text]];
}

-(void)outputMagData:(CMMagneticField) magneticField{
    self.mag_x.text = [NSString stringWithFormat:@"%f", magneticField.x];
    self.mag_y.text = [NSString stringWithFormat:@"%f", magneticField.y];
    self.mag_z.text = [NSString stringWithFormat:@"%f", magneticField.z];
    
    // set the time to the correct format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy_HH-mm-ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.timestamp.text = [dateFormatter stringFromDate:[NSDate date]];
    [self.collectMag addObject:[NSString stringWithFormat:@"%@,%@,%@,%@\n", self.timestamp.text, self.mag_x.text, self.mag_y.text, self.mag_z.text]];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
