//
//  MCNewCustomLayeredView.m
//  MCCore
//
//  Created by Vinícius Rodrigues on 24/01/2014.
//  Copyright (c) 2014 MyAppControls. All rights reserved.
//

#import "MCNewCustomLayeredView.h"
#import "MCNewCustomLayeredView+MCCustomLayeredViewSubclass.h"

@interface MCNewCustomLayeredView()

@end

@implementation MCNewCustomLayeredView
{
    // store selected itens.
    // if items are set selected when the view is not drawn already (viewDidLoad)
    // then the items stored in this array can be used to select them
    // when the drawing is ready.
    NSMutableArray *selectedItems;
    
    BOOL viewDidDraw;
}

#pragma mark Initialization Methods

- (void)internalSetUp
{
    self.containerLayer = [MCNewCustomLayer layer];
    self.containerLayer.frame = self.bounds;
    self.containerLayer.opaque = YES;
    
    [self.layer addSublayer:self.containerLayer];
    self.containerLayer.sublayers = nil;
    
    viewDidDraw = NO;
}

- (void)setUp {
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalSetUp];
        [self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalSetUp];
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults
{
    self.animationDuration  = 1;
    self.animationEnabled   = YES;
    self.animatesBegining   = YES;
    self.backgroundColor    = [UIColor clearColor];
    
    _firstDraw              = YES;
}

#pragma mark Layer Management Methods

- (Class)classForSublayers {
    return [MCNewCustomLayer class];
}

- (MCNewCustomLayer*)itemForIndex:(NSInteger)index withReuseItem:(MCNewCustomLayer*)reuseItem
{
    if (reuseItem == nil) {
        reuseItem = [[[self classForSublayers] alloc] init];
    }
    
    reuseItem.animationDuration = self.animationDuration;
    reuseItem.animationEnabled  = self.animationEnabled;
    reuseItem.imageBoundsStyle  = self.imageBoundsStyle;
    
    return reuseItem;
}

- (id)identifierForItemAtIndex:(NSInteger)index {
    return [NSNumber numberWithInteger:index];
}

- (void)deselectAllItems
{
    for (MCNewCustomLayer *layer in [self getAllItems]) {
        layer.selectionStatus = MCNewCustomLayerSelectionStatusNotSelected;
    }
}

- (void)selectItemAtIndex:(NSUInteger)index
{
    if (!viewDidDraw) {
        if (selectedItems == nil) {
            selectedItems = [[NSMutableArray alloc] init];
        }
        [selectedItems addObject:[NSNumber numberWithInt:(unsigned)index]];
    }
    else {
        MCNewCustomLayer *selectedLayer = [self getItemAtIndex:index];
        
        if (!self.allowsMultipleSelection) {
            for (MCNewCustomLayer *layer in self.containerLayer.sublayers) {
                if (![layer isEqual:selectedLayer]) {
                    layer.selectionStatus = MCNewCustomLayerSelectionStatusNotSelected;
                }
            }
        }
        
        selectedLayer.selectionStatus = MCNewCustomLayerSelectionStatusSelected;
    }
}

- (void)deselectItemAtIndex:(NSUInteger)index
{
    MCNewCustomLayer *selectedLayer = [self getItemAtIndex:index];
    selectedLayer.selectionStatus = MCNewCustomLayerSelectionStatusNotSelected;
}

- (MCNewCustomLayer*)newLayerAtIndex:(NSInteger)index
{
    MCNewCustomLayer *newLayer = [[[self classForSublayers] alloc] init];
    if (!self.animatesBegining && self.firstDraw) {
        newLayer.isAllowedToAnimate = NO;
    }
    
    newLayer = [self itemForIndex:index withReuseItem:newLayer];
    newLayer.frame = self.bounds;
    newLayer.identifier = [self identifierForItemAtIndex:index];
    
    return newLayer;
}

- (void)addSublayers
{
    self.containerLayer.sublayers = nil;
    
    NSInteger numberOfItems = [self dataSourceNumberOfItemsInView:self];
    
    NSMutableArray *sublayers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < numberOfItems; i++)
    {
        BOOL hasCopy = NO;
        
        for (int j = 0; j < _layerCopies.count; j++)
        {
            MCNewCustomLayer *reuselayer = [_layerCopies objectAtIndex:j];
            
            if ([reuselayer.identifier isEqual:[self identifierForItemAtIndex:i]]) {
                MCNewCustomLayer *newLayer = [self itemForIndex:i withReuseItem:reuselayer];
                [sublayers addObject:newLayer];
                hasCopy = YES;
                [_layerCopies removeObject:reuselayer];
                break;
            }
        }
    
        if (!hasCopy)
        {
            [sublayers addObject:[self newLayerAtIndex:i]];
        }
    }
    
    for (int i = 0; i < sublayers.count; i++) {
        MCNewCustomLayer *layer = [sublayers objectAtIndex:i];
        [self addItem:layer];
        [layer setNeedsDisplay];
    }
    
    [sublayers removeAllObjects];
    sublayers = nil;
    [_layerCopies removeAllObjects];
    _layerCopies = nil;
}

- (NSArray*)getAllItems {
    return self.containerLayer.sublayers;
}

- (MCNewCustomLayer*)getItemAtIndex:(NSInteger)index {
    return [self.containerLayer.sublayers objectAtIndex:index];
}

#pragma mark Drawing Methods

- (void)willDrawSublayers {
    
}

- (void)didDrawSublayers {
    
}

- (void)allowAnimations {
    for (MCNewCustomLayer *layer in [self getAllItems]) {
        layer.isAllowedToAnimate = YES;
    }
}

- (void)disallowAnimations {
    for (MCNewCustomLayer *layer in [self getAllItems]) {
        layer.isAllowedToAnimate = NO;
    }
}

- (void)drawRect:(CGRect)rect
{
    viewDidDraw = NO;
    
    [self willDrawSublayers];
    [self addSublayers];
    [self didDrawSublayers];
    
    viewDidDraw = YES;
    
    if (selectedItems)
    {
        if (self.allowsMultipleSelection)
        {
            for (int i = 0; i < [self getAllItems].count; i++)
            {
                MCNewCustomLayer *layer = [self getItemAtIndex:i];
                for (int j = 0; j < selectedItems.count; j++)
                {
                    if (i == j) {
                        layer.selectionStatus = MCNewCustomLayerSelectionStatusSelected;
                    }
                }
            }
        }
        else {
            MCNewCustomLayer *layer = [self getItemAtIndex:[[selectedItems lastObject] intValue]];
            layer.selectionStatus = MCNewCustomLayerSelectionStatusSelected;
        }
    }
    selectedItems = nil;
    
    _firstDraw = NO;
}

#pragma mark Editing Methods

- (void)reloadData
{
    [self deselectAllItems];
    _layerCopies = [[NSMutableArray alloc] initWithArray:[self getAllItems]];
    viewDidDraw = NO;
    [self setNeedsDisplay];
}

- (void)animate
{
    [self deselectAllItems];
    _layerCopies = nil;
    viewDidDraw = NO;
    [self setNeedsDisplay];
}

//
- (void)addItem:(MCNewCustomLayer*)layer
{
    layer.parentLayeredView = self;
    [self.containerLayer addSublayer:layer];
}

- (void)removeItem:(MCNewCustomLayer*)layerToBeRemoved {
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[self getAllItems]];
    self.containerLayer.sublayers = nil;
    
    for (MCNewCustomLayer *layer in items) {
        if ([layer isEqual:layerToBeRemoved]) {
            [items removeObject:layer];
            [layer removeFromSuperlayer];
            layer.parentLayeredView = nil;
            break;
        }
    }
    
    for (MCNewCustomLayer *layer in items) {
        [self addItem:layer];
    }
}

#pragma mark Touch Management Methods

- (void)customLayeredView:(MCNewCustomLayeredView*)customLayeredView
  didTouchMainPathOnLayer:(MCNewCustomLayer*)layer {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self findSelectedLayer:[touch locationInView:self]];
}

- (void)findSelectedLayer:(CGPoint)point
{
    NSArray *layers = [self getAllItems];
    
    [layers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[MCNewCustomLayer class]]) {
            MCNewCustomLayer *layer = (MCNewCustomLayer *)obj;
            
            CGPathRef path = layer.mainPath;
            CGAffineTransform transform = CGAffineTransformIdentity;
            
            if (CGPathContainsPoint(path, &transform, point, 0)) {
                [self customLayeredView:self didTouchMainPathOnLayer:layer];
            }
        }
    }];
}

#pragma mark Data Source Methods

- (NSInteger)dataSourceNumberOfItemsInView:(MCNewCustomLayeredView*)view {
    return 0;
}

@end
