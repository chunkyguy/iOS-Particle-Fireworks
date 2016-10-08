//
//  TWFViewController.m
//  Fireworks-iOS
//
//  Created by Victoria Lechnowitsch on 11.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TWFViewController.h"
#import "UIView+AutoLayout.h"

@implementation TWFViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIColor *backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = backgroundColor;

    backView = [[UIView alloc] init];
    backView.backgroundColor = backgroundColor;
    [self.view addSubview:backView];
    [self.view constraintSubview:backView];


    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(tapGesture:)]; 
    [self.view addGestureRecognizer:tapGesture];

    [self addParticles];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addParticlesWithPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds))];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    backView.layer.frame = self.view.frame;
}

- (void)addParticles
{
    //Create the root layer
    CALayer *rootLayer = [CALayer layer];
    rootLayer.bounds = self.view.bounds; //CGRectMake(0, 0, 640, 480);
    rootLayer.backgroundColor = [UIColor blackColor].CGColor;

    mortor = [CAEmitterLayer layer];

    //Set the view's layer to the base layer
    [rootLayer addSublayer:mortor];
    [backView.layer addSublayer:rootLayer];
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture
{
    [self addParticlesWithPoint:[gesture locationInView:backView]];
}

- (void)addParticlesWithPoint:(CGPoint)point
{
    CGPoint originalPoint = CGPointMake(CGRectGetMaxX(backView.bounds),
                                        CGRectGetMaxY(backView.bounds));
    
    CGPoint newOriginPoint = CGPointMake(originalPoint.x - originalPoint.x/2,
                                         originalPoint.y - originalPoint.y/2);
    
    CGPoint position = CGPointMake(newOriginPoint.x + point.x,
                                   newOriginPoint.y + point.y);
    
    UIImage *image = [UIImage imageNamed:@"tspark.png"];
    
	
	mortor.emitterPosition = position;
	mortor.renderMode = kCAEmitterLayerBackToFront;
	
	//Invisible particle representing the rocket before the explosion
	CAEmitterCell *rocket = [CAEmitterCell emitterCell];
	rocket.emissionLongitude = M_PI / 2;
	rocket.emissionLatitude = 0;
	rocket.lifetime = 1.6;
	rocket.birthRate = 1;
	rocket.velocity = 40;
	rocket.velocityRange = 100;
	rocket.yAcceleration = -250;
	rocket.emissionRange = M_PI / 4;
	rocket.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
	rocket.redRange = 0.5;
	rocket.greenRange = 0.5;
	rocket.blueRange = 0.5;
	
	//Name the cell so that it can be animated later using keypath
	[rocket setName:@"rocket"];
	
	//Flare particles emitted from the rocket as it flys
	CAEmitterCell *flare = [CAEmitterCell emitterCell];
	flare.contents = (id)image.CGImage;
	flare.emissionLongitude = (4 * M_PI) / 2;
	flare.scale = 0.4;
	flare.velocity = 100;
	flare.birthRate = 45;
	flare.lifetime = 1.5;
	flare.yAcceleration = -350;
	flare.emissionRange = M_PI / 7;
	flare.alphaSpeed = -0.7;
	flare.scaleSpeed = -0.1;
	flare.scaleRange = 0.1;
	flare.beginTime = 0.01;
	flare.duration = 0.7;
	
	//The particles that make up the explosion
	CAEmitterCell *firework = [CAEmitterCell emitterCell];
	firework.contents = (id)image.CGImage;
	firework.birthRate = 9999;
	firework.scale = 0.6;
	firework.velocity = 130;
	firework.lifetime = 2;
	firework.alphaSpeed = -0.2;
	firework.yAcceleration = -80;
	firework.beginTime = 1.5;
	firework.duration = 0.1;
	firework.emissionRange = 2 * M_PI;
	firework.scaleSpeed = -0.1;
	firework.spin = 2;
	
	//Name the cell so that it can be animated later using keypath
	[firework setName:@"firework"];
	
	//preSpark is an invisible particle used to later emit the spark
	CAEmitterCell *preSpark = [CAEmitterCell emitterCell];
	preSpark.birthRate = 80;
	preSpark.velocity = firework.velocity * 0.70;
	preSpark.lifetime = 1.7;
	preSpark.yAcceleration = firework.yAcceleration * 0.85;
	preSpark.beginTime = firework.beginTime - 0.2;
	preSpark.emissionRange = firework.emissionRange;
	preSpark.greenSpeed = 100;
	preSpark.blueSpeed = 100;
	preSpark.redSpeed = 100;
	
	//Name the cell so that it can be animated later using keypath
	[preSpark setName:@"preSpark"];
	
	//The 'sparkle' at the end of a firework
	CAEmitterCell *spark = [CAEmitterCell emitterCell];
	spark.contents = (id)image.CGImage;
	spark.lifetime = 0.05;
	spark.yAcceleration = -250;
	spark.beginTime = 0.8;
	spark.scale = 0.4;
	spark.birthRate = 10;
	
	preSpark.emitterCells = [NSArray arrayWithObjects:spark, nil];
	rocket.emitterCells = [NSArray arrayWithObjects:flare, firework, preSpark, nil];
	mortor.emitterCells = [NSArray arrayWithObjects:rocket, nil];

	[backView setNeedsDisplay];
}

@end
