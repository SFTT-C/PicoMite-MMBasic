CLS

cR = RGB(255,0,0)
cO = RGB(255,165,0)
cY = RGB(255,255,0)
cG = RGB(0,255,0)
cB = RGB(0,0,255)
cI = RGB(75,0,130)
cV = RGB(238,130,238)
cW = RGB(255,255,255)

Line 160,140,140,180,1,cW
Line 160,140,180,180,1,cW
Line 180,180,140,180,1,cW

For wl = 0 To 160
Line 0,160,wl,160,3,cW
Pause 5
Next wl

For cl = 160 To 319
y0=160+(cl-160)*(30-160)/159
y1=160+(cl-160)*(38-160)/159
y2=160+(cl-160)*(46-160)/159
y3=160+(cl-160)*(54-160)/159
y4=160+(cl-160)*(62-160)/159
y5=160+(cl-160)*(70-160)/159
y6=160+(cl-160)*(78-160)/159
Line 160,160,cl,Int(y0+0.5),4,cR
Line 160,160,cl,Int(y1+0.5),4,cO
Line 160,160,cl,Int(y2+0.5),4,cY
Line 160,160,cl,Int(y3+0.5),4,cG
Line 160,160,cl,Int(y4+0.5),4,cB
Line 160,160,cl,Int(y5+0.5),4,cI
Line 160,160,cl,Int(y6+0.5),4,cV
Next cl
Print @(0,300) "Press any key to exit."

Do
Loop Until Inkey$ <> ""
