

For x = 0 To 319

  Line 0,160,x,160,1,RGB(red)
  Line 160,0,160,x,1,RGB(yellow)
  Line 0,0,x,x,1,RGB(green)
  Line 0,319,x,319-x,1,RGB(blue)
  Pause 3


Next x
