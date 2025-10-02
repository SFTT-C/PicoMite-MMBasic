Randomize Timer
For p = 0 To 5000
r=Rnd*255:g=Rnd*255:b=Rnd*255
Pixel Rnd*319,Rnd*319,RGB(r,g,b)
Color RGB(Rnd*255,Rnd*255,Rnd*255)
Print @(160,0) p;
Next p
'For bo = 0 To 500
'Box Rnd*319,Rnd*319,Rnd*319,Rnd*319
'Next bo
