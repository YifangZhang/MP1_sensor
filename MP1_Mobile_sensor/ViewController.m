//
//  ViewController.m
//  MP1_Mobile_sensor
//
//  Created by Yifang Zhang on 9/3/16.
//  Copyright © 2016 Yifang. All rights reserved.
//

#import "ViewController.h"
//What up
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    
    self.flag = false;
    
    
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

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    self.acc_x.text = [NSString stringWithFormat:@"%f", acceleration.x];
    self.acc_y.text = [NSString stringWithFormat:@"%f", acceleration.y];
    self.acc_z.text = [NSString stringWithFormat:@"%f", acceleration.z];
}

-(void)outputGyroData:(CMRotationRate)rotationRate
{
    self.gyro_x.text = [NSString stringWithFormat:@"%f", rotationRate.x];
    self.gyro_y.text = [NSString stringWithFormat:@"%f", rotationRate.y];
    self.gyro_z.text = [NSString stringWithFormat:@"%f", rotationRate.z];
    
}

-(void)outputMagData:(CMMagneticField) magneticField{
    self.mag_x.text = [NSString stringWithFormat:@"%f", magneticField.x];
    self.mag_y.text = [NSString stringWithFormat:@"%f", magneticField.y];
    self.mag_z.text = [NSString stringWithFormat:@"%f", magneticField.z];
    
}

@end
