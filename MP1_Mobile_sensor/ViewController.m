//
//  ViewController.m
//  MP1_Mobile_sensor
//
//  Created by Yifang Zhang on 9/3/16.
//  Copyright © 2016 Yifang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init the dictionaries
    self.collectAcc = [[NSMutableArray alloc] init];
    self.collectGyro = [[NSMutableArray alloc] init];
    self.collectMag = [[NSMutableArray alloc] init];
    
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
    
    self.motionManager.accelerometerUpdateInterval = 0.1;
    self.motionManager.gyroUpdateInterval = 0.1;
    self.motionManager.magnetometerUpdateInterval = 0.1;
    
    // set the time to the correct format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy_HH-mm-ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.timestamp.text = [dateFormatter stringFromDate:[NSDate date]];

    // init with flag as false
    self.flag = false;
    
    // init the temp file of csv
    self.tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", self.timestamp.text]];
    
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
    }

}

- (IBAction)sendMail:(id)sender {
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    self.acc_x.text = [NSString stringWithFormat:@"%f", acceleration.x];
    self.acc_y.text = [NSString stringWithFormat:@"%f", acceleration.y];
    self.acc_z.text = [NSString stringWithFormat:@"%f", acceleration.z];
    
    // set the time to the correct format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy_HH-mm-ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.timestamp.text = [dateFormatter stringFromDate:[NSDate date]];
}

-(void)outputGyroData:(CMRotationRate)rotationRate
{
    self.gyro_x.text = [NSString stringWithFormat:@"%f", rotationRate.x];
    self.gyro_y.text = [NSString stringWithFormat:@"%f", rotationRate.y];
    self.gyro_z.text = [NSString stringWithFormat:@"%f", rotationRate.z];
    
    // set the time to the correct format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy_HH-mm-ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.timestamp.text = [dateFormatter stringFromDate:[NSDate date]];
    
}

-(void)outputMagData:(CMMagneticField) magneticField{
    self.mag_x.text = [NSString stringWithFormat:@"%f", magneticField.x];
    self.mag_y.text = [NSString stringWithFormat:@"%f", magneticField.y];
    self.mag_z.text = [NSString stringWithFormat:@"%f", magneticField.z];
    
    // set the time to the correct format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy_HH-mm-ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    self.timestamp.text = [dateFormatter stringFromDate:[NSDate date]];
}

@end
