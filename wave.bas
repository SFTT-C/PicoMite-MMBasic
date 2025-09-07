CLS
Colour RGB(255,255,255),RGB(0,0,0)

W=MM.HRES : H=MM.VRES
CX=W\2 : CY=H\2

AMP=Int(H*0.4)
BASE=50    ' freq->cycles
FREQ=100
AMP = Q5(AMP)
If AMP<5 Then AMP=5
If AMP>H\2 Then AMP=H\2
FREQ=Q5(FREQ)
WAVE=0 : THK=1 : GRID=1
ANM=1  : SC=1  : DV=1
OF=0   : HUD=1 : FULL=1

CA=RGB(80,80,160)
CG=RGB(64,64,64)
BK=RGB(0,0,0)
C1=RGB(0,255,180)

Dim YP(W-1)
Dim GX(W-1),GY(H-1)
For I=0 To W-1 : YP(I)=-1 : Next

GoSub RECALC
GoSub FRAME

Do
DF=0 : DA=0 : DS=0
SW=0 : TK=0 : GG=0
RV=0 : PP=0 : QQ=0

K$=Inkey$
If K$<>"" Then
 Do
  Select Case K$
   Case "+": DF=DF+1
   Case "-": DF=DF-1
   Case " ": SW=1
   Case "A","a": DA=DA+1
   Case "Z","z": DA=DA-1
   Case "T","t": TK=1
   Case "G","g": GG=1
   Case "W","w": DS=DS+1
   Case "X","x": DS=DS-1
   Case "R","r": RV=1
   Case "P","p": PP=1
   Case "Q","q": QQ=1
  End Select
  K$=Inkey$
 Loop Until K$=""
EndIf
If QQ=1 Then Exit Do

If DF>0 Then DF=1
If DF<0 Then DF=-1
If DA>0 Then DA=1
If DA<0 Then DA=-1
If DS>0 Then DS=1
If DS<0 Then DS=-1

CH=0 

If DF<>0 Then
 FREQ=FREQ+DF*5
 If FREQ<1 Then FREQ=1
 If FREQ>5000 Then FREQ=5000
 GoSub RECALC
 CH=1
EndIf

If DA<>0 Then
 AMP=AMP+DA*5
 If AMP<5 Then AMP=5
 If AMP>H\2 Then AMP=H\2
 CH=1
EndIf

If DS<>0 Then
 SC=SC+DS
 If SC<0 Then SC=0
 If SC>10 Then SC=10
 CH=1
EndIf

If SW=1 Then WAVE=(WAVE+1) Mod 4 : CH=1
If TK=1 Then
 If THK=1 Then THK=3 Else THK=1
 CH=1
EndIf
If GG=1 Then GRID=1-GRID : FULL=1 : CH=1
If RV=1 Then DV=-DV : CH=1
If PP=1 Then ANM=1-ANM : CH=1

If FULL=1 Then
 GoSub FRAME
 For I=0 To W-1 : YP(I)=-1 : Next
 FULL=0 : CH=1
EndIf

If CH=1 Then HUD=1
If HUD=1 Then GoSub HUDTXT : HUD=0

If ANM=1 Then GoSub STEPTRACE

If ANM=1 Then Pause 8 Else Pause 2
Loop

CLS
Colour RGB(255,255,255),RGB(0,0,0)
Text 6,6,"Ended."
End

RECALC:
CYC=FREQ/BASE
If CYC<0.05 Then CYC=0.05
If CYC>200  Then CYC=200
ST=2*Pi*CYC/(W-1)
Return

FRAME:
CLS
For X=0 To W-1 : GX(X)=0 : Next
For Y=0 To H-1 : GY(Y)=0 : Next
If GRID=1 Then
 For X=0 To W-1 Step 20 : GX(X)=1 : Next
 For Y=0 To H-1 Step 20 : GY(Y)=1 : Next
 For X=0 To W-1 Step 20
  For Y=0 To H-1 Step 20
   Pixel X,Y,CG
  Next
 Next
EndIf
For X=0 To W-1 : Pixel X,CY,CA : Next
For Y=0 To H-1 : Pixel CX,Y,CA : Next
Return

HUDTXT:
S$="W:"+WN$(WAVE)
S$=S$+" F:"+Str$(FREQ)+"Hz"
S$=S$+" A:"+Str$(AMP)
S$=S$+" S:"+Str$(SC)
If DV=1 Then AR$=">" Else AR$="<"
If ANM=0 Then PS$=" Paused" Else PS$=""
HDR$=S$+" "+AR$+PS$
If Len(HDR$)<40 Then
 HDR$=HDR$+Space$(40-Len(HDR$))
EndIf
Text 6,6,HDR$
Return

STEPTRACE:
PH=OF
For X=0 To W-1
 YO=YP(X)

 V=WV(WAVE,PH)
 YN=CY-Int(V*AMP)
 If YN<0 Then YN=0
 If YN>H-1 Then YN=H-1

 If YO=YN Then
  PH=PH+ST : GoTo NextX
 EndIf

 If YO>=0 Then
  If THK=1 Then
   Y=YO : GoSub ERASE1
  Else
   Y1=YO-1:If Y1<0 Then Y1=0
   Y2=YO+1:If Y2>H-1 Then Y2=H-1
   Y=Y1 : GoSub ERASE1
   Y=YO : GoSub ERASE1
   Y=Y2 : GoSub ERASE1
  EndIf
 EndIf

 If THK=1 Then
  Pixel X,YN,C1
 Else
  Y1=YN-1:If Y1<0 Then Y1=0
  Y2=YN+1:If Y2>H-1 Then Y2=H-1
  Pixel X,Y1,C1
  Pixel X,YN ,C1
  Pixel X,Y2,C1
 EndIf
 YP(X)=YN

 PH=PH+ST
NextX:
Next

OF=OF+DV*ST*SC
If OF>=2*Pi Then OF=OF-2*Pi
If OF<0 Then OF=OF+2*Pi
Return

ERASE1:
If Y=CY Or X=CX Then
 C=CA
ElseIf GRID=1 And GX(X)=1 And GY(Y)=1 Then
 C=CG
Else
 C=BK
EndIf
Pixel X,Y,C
Return

Function WN$(N)
 Select Case N
  Case 0: WN$="Sine"
  Case 1: WN$="Square"
  Case 2: WN$="Tri"
  Case 3: WN$="Saw"
  Case Else : WN$="? "
 End Select
End Function

Function WV(N,P)
 Select Case N
  Case 0
   V=Sin(P)
  Case 1
   If Sin(P)>=0 Then V=1 Else V=-1
  Case 2
   TT=P/(2*Pi) : TT=TT-Int(TT)
   If TT<0.25 Then
    V=4*TT
   ElseIf TT<0.75 Then
    V=2-4*TT
   Else
    V=-4+4*TT
   EndIf
  Case 3
   SS=P/(2*Pi) : SS=SS-Int(SS)
   V=2*SS-1
  Case Else
   V=0
 End Select
 WV=V
End Function

Function Q5(N)
 Q5 = ((N+2)\5)*5 ' round to nearest 5
End Function
