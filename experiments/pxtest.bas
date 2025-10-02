'drawing lines using pixel command


For i = 0 To 319
Pixel 160,i,RGB(red) 'mid top - btm
Pixel i,160,RGB(red) 'mid l - mid r
Pixel 0,i,RGB(red) 'l top - l btm
Pixel 319,319-i,RGB(red) 'r btm - r top
Pixel 319-i,0,RGB(red) ' r top - l top
Pixel i,319-i,RGB(red) 'l btm - r top
Pixel i,i,RGB(red) 'l top - r bm
Pixel i,319,RGB(red) 'l btm - r btm
Pause 7
Next i
Do
Loop Until Inkey$ <> ""
