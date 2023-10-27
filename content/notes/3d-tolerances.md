---
title: 3d printer tolerances
type: post
date: 2023-03-08
tags: 3d-printing
---

# How to print parts that fit together

## 1. Calibrate the e-step per mm setting

1. Heat up your nozzle and make sure filament is flowing freely
2. Measure out 120mm of filament and mark it
3. Extrude 100mm of filament
4. Calculate the E-steps with the following:
```
Requested extrude amount/Measured extrude amount * Current E-steps/mm = New E-Step value
```

Remember to re-do the test to make sure it's now doing what you expect it to be doing


### Why you shouldn't calibrate flow rate

Adjusting flow rate can make the outside measurements more accurate BUT it also adjusts every other dimension, increasing things like under-extrusion on top layers

Also remember that the wall of a 3d print isn't flat: it's rows of little bumps and divots

Instead, adjust the horizontal expansion in your slicer--
(aka dimensional adjustment, XY adjustment)

tweak by the mm measurement you're off (eg. -1.5mm if you're 3mm big all around)

## Calibrate tolerance & dimensional accuracy

Adjust your prints: print some tolerance tests to judge how close you can expect to get

Also be sure you're using the same material the model was originally designed for--different materials print differently

## Increase the resolution on your models

aka MORE POLYGONS

## Try a different material

Different PLAs are different; a higher quality filament might be better (you're testing a specific combination of printer+settings+materials)

## Re-scale the model

Add or remove material, re-size pieces (Teaching Tech recommends .4mm additional clearance for nuts and bolts, 2% for fitment resizing)

## Use a lower layer height & higher line width

Try .16mm layer height -- you can usually go anywhere between 25%-75% of the nozzle diameter

.5mm line width works better--100-120% of nozzle diameter

Tweaking these also affects speed & strength of the print

## Lower the printing temperature

Higher temperatures cause sagging, stringing, blobbing

## Change the slicing tolerance setting to "inclusive" 

an experimental setting in Cura that slices at the outermost part

## Print test parts for the kind of fitment you're looking for

For sliding tolerances, try a two way screw or an iris box; for snap parts, boxes are usually a good starting place




