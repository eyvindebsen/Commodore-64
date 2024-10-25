0 xs=40:ys=26:dimm(ys,xs),xd(3),yd(3)
1 gosub 8000:rem remember to correct line 3, 1286 before release!
2 rem mazegame v4 by eyvind ebsen 2024;uses a rel db of 1200+ ready mazes
3 dim da(128):lr=125:tc=1239:dv=9:hr=210:dim hr(hr)
5 a$="mazes":gosub7160:if fe=0 then print"no maze-db found":inputa$:goto8:rem check db
6 ds=1:print"maze-db are available on disk!{return}use it for faster mazes{return}(y/n)?"
7 input a$:if a$="n"thends=0
8 gosub 7920
9 dv=8:gosub9100:rem check hiscore
10 print "{clear}":js=56320:gosub7700:gosub4100
12 x=0:y=0:i=0:j=0:lv=0:sc=0::ml=100:mc=0:rem Counters
15 w=4:rem Wall
18 s=5:rem Space
40 sx=1:sy=1:rem Start position
45 ox=1:oy=1:rem Old position
50 cx=1:cy=1:rem Crurrent position
55 nx=1:ny=1:rem New position
57 dp=rnd(-ti):rem init random    
60 dp=0:rem Movement vector pointer
1000 goto 1285
1010 rem Init arrays
1020 for y=0 to ys:for x=0 to xs
1025 m(y,x)=4
1030 next x:next y
1035 xd(0)=0:yd(0)=-1:xd(1)=1:yd(1)=0:xd(2)=0:yd(2)=1:xd(3)=-1:yd(3)=0
1040 return
1050 rem Print maze
1060 for y=1 to ys-1:for x=1 to xs-1
1065 if m(y,x)=4 then print "{reverse on} {reverse off}";
1068 if m(y,x)<>5 then goto1080
1069 rem if nd=1 then goto 1072:rem no diamonds, creating mazes
1070 if int(rnd(.)*(17+(lv*8)))=1then print "{cyan}Z{light blue}";:goto1080
1072 print" ";
1075 rem if m(y,x)<4 then print "#lol";
1080 next x:ify<ys-1 then print : rem dont print in last line
1082 next y
1085 rem print
1090 return
1100 rem Fetch new position 
1110 dp=int(rnd(1)*4)
1115 i=0
1120 nx=cx+xd(dp)*2:ny=cy+yd(dp)*2
1125 if nx<1 or nx>=xs or ny<1 or ny>=ys or (nx=sx and ny=sy) then goto 1135
1130 if m(ny,nx)=w then m(cy+yd(dp),cx+xd(dp))=s:cx=nx:cy=ny:m(cy,cx)=dp:return
1135 dp=dp+1:if dp>3 then dp=0
1140 i=i+1
1145 if i<4 then goto 1120
1150 return
1160 rem Create maze
1170 ox=cx:oy=cy
1175 gosub 1110
1180 if cx=sx then if cy=sy then return
1185 if ox<>cx or oy<>cy then goto 1170
1190 nx=cx-xd(m(cy,cx))*2:ny=cy-yd(m(cy,cx))*2
1195 m(cy,cx)=s:cx=nx:cy=ny
1200 goto 1170
1205 return
1215 rem Create gaps
1225 for i=0 to g
1230 x=int(rnd(1)*(xs-2))+1:y=int(rnd(1)*(ys-2))+1
1235 if m(y,x)=s then goto 1230
1240 if m(y-1,x)=w then if m(y+1,x)=w then if m(y,x-1)<>w then if m(y,x+1)<>w then goto 1255
1245 if m(y,x-1)=w then if m(y,x+1)=w then if m(y-1,x)<>w then if m(y+1,x)<>w then goto 1255
1250 goto 1230
1255 m(y,x)=s
1260 next i
1265 return
1275 rem Main routine ***
1285 gosub4000:if ml<5then goto 10:rem game beat-below remove dv=9 before release
1286 ifds=1thenmc=int(rnd(1)*tc):dv=9:gosub7200:dv=8:gosub 7130:goto1314
1287 gosub 1020
1290 cx=sx:cy=sy
1295 gosub 1170
1300 m(sy,sx)=5
1305 gosub 1225
1310 gosub 1060 
1314 gosub 7300:print"{home}Q";:rem print player, and open end
1315 forx=1to24:poke56295-x*40,13:next:rem poke color for lifebar
1316 if lv=0 then ml=100::mf=23:sc=0:rem set level 0 
1318 poke 2023,83:c=0:fl=0:lf=ml:tf=mf:px=0:py=0:ox=0:oy=0::rem setup
1319 gosub 3000:gosub 4930: rem show life and wait for joystick
1320 rem start game routine
1330 j=peek(js):rem get joy2
1335 oa=1024+px+py*40:poke oa,81:gosub4960:rem show flashng ply
1340 if j=127 then goto 1902 : rem no play
1350 if j=126 then if py>0 then py=py-1 : rem up
1360 if j=125 then if py<24 then py=py+1: rem down
1370 if j=123 then if px>0 then px=px-1 : rem left
1380 if j=119 then if px<39 then px=px+1 : rem right
1385 na=1024+px+py*40:np=peek(na)
1390 if np=32 then poke oa,32:ox=px:oy=py:goto 1900:rem free space
1393 if np=90 then poke oa,32:ox=px:oy=py:sc=sc+11:tf=tf+2:goto 1900:rem diamond
1396 if np=83 then poke oa,32:ox=px:oy=py:sc=sc+100+tf*7+lf:goto 2000:rem end
1400 px=ox:py=oy:rem invalid move
1900 rem update life; flash heart
1902 lf=lf-1:if lf=0 then lf=ml:gosub3000
1905 if fl=0 then poke56295,10:fl=1:goto 1990
1910 poke56295,2:fl=0:goto 1990
1990 goto1330
1999 geta$:ifa$=""then1319
2000 print"{home}";:forx=0to24:print:next
2010 gosub7400:forx=0to5000:next:forx=0to25:print:next
2030 lv=lv+1:ml=ml-8:lf=ml:mf=23-lv:goto1285:rem next lvl
3000 tf=tf-1:if tf=0 then goto 5000
3002 iftf>mfthentf=mf
3004 forx=1to24:if x>tf then poke2023-x*40,101:goto 3010
3007 poke2023-x*40,160:
3010 next:return:rem show life
4000 rem show level
4010 for x=0to7:print:next:gosub7500
4020 print
4022 a$="generating level"+str$(lv+1)+" please wait":gosub 4230
4025 a$="your score is{light green}"+str$(sc)+"{light blue}":gosub 4230
4030 for x=0to3000:next:rem wait
4035 if ml<5 then gosub7540:print:print "you beat the game!":print"total score";sc:gosub8300
4040 return
4100 rem show intro
4110 for x=0to1:print:next
4112 restore:for x=0 to 20:read a$:if a$=""then print;
4114 gosub4230:next
4120 data"welcome to the amazeing game of",,
4135 data "{yellow}** mazes **{light blue}",,,
4140 data"help our hero ({white}Q{light blue}) thru the maze to",
4160 data "save the beautiful princess ({pink}S{light blue})" ,
4180 data "before her lifeforce ({cyan}Z{light blue}) runs out.",,,
4200 data "{white}use joystick in port 2 to start!{light blue}",,,
4205 data "{gray}  code by eyvind ebsen oct. 2024 v4{light blue}",
4206 a$="source of mazes: ":wa=0
4207 if ds=1 then a$=a$+"{light green}disk{light blue}":gosub 4230:goto4210:rem set source
4208 a$=a$+"{green}cpu64{light blue}":gosub 4230
4210 if peek(js)=127 then wa=wa+1:if wa>500 then wa=0:gosub8200:gosub7700:goto4100
4212 if peek(js)<>127 then goto 4217:rem joy moved
4214 goto4210:rem wait joy
4217 for x=0to1:print:next:return
4220 rem print centered
4230 printspc((39-len(a$))/2)a$:return
4900 rem wait for joy
4910 if peek(js)=127 then goto 4910
4920 return
4930 rem wait for joy, flash heart and ply
4935 if fl=0 then poke56295,10:fl=1:goto 4940
4937 poke56295,2:fl=0
4940 gosub 4960:if peek(js)=127 then goto 4935
4950 return
4960 poke 55296+px+py*40,c:c=(c+1)and15:return:rem flash ply
5000 rem game over
5010 forx=.to25:print:next:gosub7460:print:print"final score"sc:gosub8300:goto10
7130 rem show maze from data-turbo
7132 print"{clear}";:for x=0to123:b=da(x) and 15:a=da(x) and 240
7133 a=a/2:a=a/2:a=a/2:a=a/2:printa$(a)a$(b);:next
7134 a=da(124):a=a/2:a=a/2:a=a/2:a=a/2:printa$(a)"{reverse off}{home}";
7136 forx=1024to2022step2:ifpeek(x)=32thenifint(rnd(.)*(9+(lv+1*8)))=1thenpokex,90:poke54272+x,3
7138 next:return
7160 rem check if file a$ exist
7170 open 15,dv,15
7172 print#15,"r0:"+a$+"="a$ : rem try to rename file to self
7174 input#15,e,e$,e1,e2
7175 close 15
7176 if e=62 then fe=0
7178 if e=63 then fe=1
7180 return
7190 rem get a maze from disk. set mc to #
7200 print:a$="{white}fetching maze{yellow}"+str$(mc)+"{light blue}":gosub4230
7205 open 2,dv,5,"mazes":open 15,dv,15:rem must reopen the command channel
7215 r=mc+1:rem which record
7220 r0=int(r/256):r1=r-r0*256:rem calc hi and low record number
7230 print#15,"p"+chr$(101)+chr$(r1)+chr$(r0)+chr$(1):rem seek record
7240 for i=1 to lr:get#2,a$:v=asc(a$+chr$(0)):da(i-1)=v:rem get data
7250 rem print da(i-1);:next:print
7255 next:close2:close15
7260 return
7300 rem open bottem right with 16 pokes
7305 forx=0to3:poke1899+x,32:poke1939+x,32:poke1979+x,32:poke2019+x,32:next
7340 return
7400 rem signs
7410 rem sign1 great
7412 print"    {cyan}{sh space}{sh space}"
7414 print"    {reverse on}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}"
7416 print"   {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}"
7418 print" {sh space}{reverse on}{sh space}{sh space}{reverse off}{sh space}{sh space}{sh space} {sh space}{sh space}{reverse on}{sh space}{reverse off} {sh space} {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7420 print"  {reverse on}{sh space}{reverse off}{sh space}  {sh space} {sh space} {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7422 print"  {reverse on}{sh space}{reverse off}{sh space}{reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7424 print"  {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}"
7426 print"  {reverse on}{sh space}{sh space}{reverse off}{sh space}{sh space}{reverse on}{sh space}{reverse off} {sh space}{sh space}{reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7428 print"   {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}{sh space} {sh space}{reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7430 print"{light blue}";
7440 forx=0to6:print:next
7454 return
7456 rem sign2 game over
7460 print"  {reverse on}{cyan}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{reverse off}             {reverse on}{sh space}{sh space}{sh space}"
7462 print" {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{sh space}"
7464 print" {reverse on}{sh space}{reverse off}      {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}"
7466 print" {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}"
7468 print" {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}"
7470 print"  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}"
7472 print"   {reverse on}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}"
7474 print"                      {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}"
7476 print"    {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}      {reverse on}{sh space}{reverse off}         {reverse on}{sh space}{sh space}{sh space}{sh space}"
7478 print"   {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}      {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}"
7480 print"   {reverse on}{sh space}{reverse off}        {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{reverse off}    {reverse on}{sh space}"
7482 print"   {reverse on}{sh space}{reverse off}        {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}      {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}"
7484 print"   {reverse on}{sh space}{reverse off}        {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}"
7486 print"   {reverse on}{sh space}{sh space}{reverse off}       {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}"
7488 print"     {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}      {reverse on}{sh space}{reverse off}    {reverse on}{sh space}"
7490 print"      {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{sh space}"
7491 print"{light blue}";
7492 return
7496 rem sign get ready
7500 print"        {reverse on}{cyan}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}"
7502 print"      {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}"
7504 print"    {reverse on}{sh space}{sh space}{sh space}{reverse off}      {reverse on}{sh space}{sh space}{sh space}{reverse off}           {reverse on}{sh space}{sh space}"
7506 print"    {reverse on}{sh space}{sh space}{reverse off}       {reverse on}{sh space}{sh space}{sh space}{reverse off}           {reverse on}{sh space}{sh space}"
7508 print"    {reverse on}{sh space}{sh space}{reverse off}       {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}       {reverse on}{sh space}{sh space}"
7510 print"    {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}       {reverse on}{sh space}{sh space}"
7512 print"    {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off}           {reverse on}{sh space}{sh space}"
7514 print"    {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{sh space}"
7516 print"      {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}"
7517 print
7518 print" {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7520 print" {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}"
7522 print" {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}      {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}"
7524 print" {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}"
7526 print" {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7528 print" {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7530 print" {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7532 print" {reverse on}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7534 print" {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}      {reverse on}{sh space}"
7536 print"{light blue}";
7538 return
7539 rem sign super
7540 print"   {reverse on}{yellow}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}"
7542 print"  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}"
7544 print" {reverse on}{sh space}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}"
7546 print" {reverse on}{sh space}{sh space}{reverse off}      {reverse on}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}"
7548 print" {reverse on}{sh space}{sh space}{reverse off}       {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}"
7550 print"  {reverse on}{sh space}{sh space}{reverse off}      {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}"
7552 print"   {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}"
7554 print"    {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}"
7556 print"       {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}"
7558 print"       {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{sh space}{sh space}"
7560 print"      {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}"
7562 print" {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}"
7564 print"   {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}     {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}"
7566 print"    {reverse on}{sh space}{sh space}{reverse off}      {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}      {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}    {reverse on}{sh space}{sh space}"
7576 print:print"{light blue}";
7586 return
7593 rem sign top ten
7600 print"  {reverse on}{cyan}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{light green}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}"
7602 print"    {reverse on}{cyan}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{light green}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}"
7604 print"    {reverse on}{cyan}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{light green}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}"
7606 print"    {reverse on}{cyan}{sh space}{reverse off}    {reverse on}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}      {reverse on}{light green}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{sh space}"
7608 print"    {reverse on}{cyan}{sh space}{reverse off}    {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{reverse off}      {reverse on}{light green}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{sh space}{sh space}"
7618 print"{light blue}";
7628 return
7638 rem sign title
7700 for x=0to6:print:next
7716 print"      {reverse on}{purple}{sh space}{reverse off} {reverse on}{sh space}{reverse off}     {reverse on}{yellow}{sh space}{sh space}{reverse off}   {reverse on}{red}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{light blue}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{cyan}{sh space}{sh space}{sh space}"
7718 print"      {reverse on}{purple}{sh space}{reverse off} {reverse on}{sh space}{reverse off}     {reverse on}{yellow}{sh space}{sh space}{reverse off}      {reverse on}{red}{sh space}{reverse off} {reverse on}{light blue}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{cyan}{sh space}{sh space}{sh space}{sh space}{sh space}"
7720 print"     {reverse on}{purple}{sh space}{reverse off} {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}   {reverse on}{yellow}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}    {reverse on}{red}{sh space}{reverse off}  {reverse on}{light blue}{sh space}{sh space}{reverse off}     {reverse on}{cyan}{sh space}"
7722 print"     {reverse on}{purple}{sh space}{reverse off} {reverse on}{sh space}{reverse off} {reverse on}{sh space}{reverse off}   {reverse on}{yellow}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}    {reverse on}{red}{sh space}{reverse off}  {reverse on}{light blue}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{cyan}{sh space}{sh space}{sh space}{sh space}"
7724 print"    {reverse on}{purple}{sh space}{sh space}{reverse off}   {reverse on}{sh space}{sh space}{reverse off}  {reverse on}{yellow}{sh space}{reverse off}  {reverse on}{sh space}{reverse off}   {reverse on}{red}{sh space}{reverse off}   {reverse on}{light blue}{sh space}{sh space}{sh space}{sh space}{reverse off}    {reverse on}{cyan}{sh space}{sh space}{sh space}{sh space}"
7726 print"    {reverse on}{purple}{sh space}{reverse off}     {reverse on}{sh space}{reverse off} {reverse on}{yellow}{sh space}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{red}{sh space}{reverse off}   {reverse on}{light blue}{sh space}{sh space}{reverse off}         {reverse on}{cyan}{sh space}"
7728 print"    {reverse on}{purple}{sh space}{reverse off}     {reverse on}{sh space}{reverse off} {reverse on}{yellow}{sh space}{reverse off}    {reverse on}{sh space}{reverse off} {reverse on}{red}{sh space}{reverse off}    {reverse on}{light blue}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}  {reverse on}{cyan}{sh space}{sh space}{sh space}{sh space}{sh space}"
7730 print"    {reverse on}{purple}{sh space}{reverse off}     {reverse on}{sh space}{reverse off} {reverse on}{yellow}{sh space}{reverse off}    {reverse on}{sh space}{reverse off} {reverse on}{red}{sh space}{sh space}{sh space}{sh space}{reverse off} {reverse on}{light blue}{sh space}{sh space}{sh space}{sh space}{sh space}{reverse off}   {reverse on}{cyan}{sh space}{sh space}{sh space}"
7732 print
7735 print:a$="{light gray}a game by eyvind ebsen. v4 aug 2024":gosub4230:rem center
7736 print"{down*2}":a$="{gray}those who fail to plan":gosub4230
7737 a$="are planning to fail{light blue}":gosub4230
7738 for x=0to3:print:next
7739 wt=400:gosub 7900:return
7900 rem wait for timeout or joystick, set wt for time
7902 x=.
7904 x=x+1:if peek(js)<>127 then return
7906 if x>wt then return:rem timeout
7908 goto 7904
7920 rem setup 16 strings for fast maze
7921 rem print "precalculating stuff --- please wait"
7922 bs=8:for x=0to3:bs(x)=bs:bs=bs/2:next:dima$(16)
7924 forx=0to15
7926 bn=0:b$="":a=x
7928 if a>=bs(bn) then b$=b$+"{reverse on} ":a=a-bs(bn):goto7932
7930 b$=b$+"{reverse off} "
7932 bn=bn+1:ifbn=4thenbn=0:goto 7936
7934 goto 7928
7936 a$(x)=b$
7937 next
7949 return
8000 rem hiscore stuff
8029 hi$(0)="the amazeing"
8030 hi$(1)="maze game v4 by"
8040 hi$(2)="eyvind ebsen"
8050 hi$(3)="oct 2024"
8060 hi$(4)="thanks to"
8070 hi$(5)="hne74 for code"
8080 hi$(6)="cbm studio" 
8090 hi$(7)="8-bit show tell"
8100 hi$(8)="and many others"
8110 hi$(9)="ingolf was here"
8120 for x=.to9:hi(x)=1017-int(x*1.8):next
8125 rem gosub 8600:rem save hiscore
8130 return
8140 rem create a string from hiscore data
8145 k$="":rem result
8150 forx=0to9
8152 c$=hi$(x):rem null byte name
8160 if len(c$)<16 thenc$=c$+" ":goto 8160
8165 k$=k$+c$:rem add name
8170 c$=str$(hi(x)):rem null byte score
8180 if len(c$)<5 thenc$=" "+c$:goto 8180
8190 k$=k$+c$:rem add score
8195 next:return
8200 rem show hiscore
8205 print"{down*2}":gosub 7600:print"{down*2}":rem show sign
8210 y=0:forx=.to9:z$=hi$(x)
8215 if len(z$)<17 then z$=z$+" ":goto 8215
8217 if y=0 then a$="{white}"
8218 if y=1 then a$="{light blue}"
8219 if x=0 then a$="{yellow}":rem gold
8220 if x=1 then a$="{light gray}":rem silver
8221 if x=2 then a$="{purple}":rem bronze
8223 y=y+1:if y=2 then y=0
8225 a$=a$+z$+str$(hi(x)):gosub4230:
8229 next:print"{down*4}{light blue}";
8234 wt=700:gosub 7900:return
8238 return
8239 rem overwrite hiscore data
8240 open 2,dv,5,"hiscore"
8242 open 15,dv,15:rem must reopen the command channel
8244 r=1:rem which record
8246 r0=int(r/256):r1=r-r0*256:rem calc hi and low record number
8248 print#15,"p"+chr$(101)+chr$(r1)+chr$(r0)+chr$(1):rem seek record
8250 gosub 9000:rem check errors
8260 gosub8145:print#2,k$;:rem write new rec
8270 close2:close15
8280 return
8300 rem check if ply made hiscore
8305 geta$:if a$<>""thengoto 8305:rem clear keyboard buffer
8310 x=.
8320 if sc>hi(x)thengoto8400:rem in hiscore
8330 x=x+1:if x>9 then 8500:rem not in hiscore
8340 goto 8320
8400 print"you made the hiscore in place";x+1
8410 print"congratulations!"
8420 print "enter your name"
8430 input a$:if a$=""then goto 8400
8440 if len(a$)>16 then a$=left$(a$,16)
8450 for y=9 to x+1 step-1:hi(y)=hi(y-1):hi$(y)=hi$(y-1):next
8460 hi$(x)=a$:hi(x)=sc
8462 gosub 8240:rem save
8470 return
8500 print"you did not make the hiscore :(":input a$
8510 return
8999 rem hiscore stuff
9000 input#15,e,e$,e1,e2
9010 print e;e$;e1,e2
9020 return
9025 rem load from hiscore rel file
9035 r=1:rem which record
9040 r0=int(r/256):r1=r-r0*256:rem calc hi and low record number
9050 print#15,"p"+chr$(101)+chr$(r1)+chr$(r0)+chr$(1):rem seek record
9060 for i=0 to hr-1:get#2,a$:v=asc(a$+chr$(0)):hr(i)=v:next:rem get data
9062 rem put data into hi$() and hi()
9064 x=0:hn=0:rem print"data:":print
9066 c$="":fory=0to15:c$=c$+chr$(hr(x)):x=x+1:next:hi$(hn)=c$:rem name
9068 c$="":fory=0to4:c$=c$+chr$(hr(x)):x=x+1:next:hi(hn)=val(c$):rem name
9070 rem print "name:"hi$(hn)" score:"hi(hn)
9072 hn=hn+1:if hn<10 then goto 9066
9080 return
9100 rem check if hiscore exist
9104 a$="hiscore":gosub 7170
9105 if fe=1thenprint"hiscore exist!":goto 9122
9106 if fe=0thenprint"no hiscore - creating..."
9107 gosub8029:rem init hiscore data. record=210 bytes
9109 open15,dv,15:gosub9000:rem open cmd channel to device9
9110 rem create file len of record, 10 names*16+10 scores*5:210
9111 print"creating hiscore file"
9112 open 2,dv,2,"hiscore,l,"+chr$(hr):rem set record length 
9114 r=1:rem number of records
9115 r0=int(r/256):r1=r-r0*256:rem calc hi and low record number
9116 print#15,"p"+chr$(96+2)+chr$(r1)+chr$(r0)+chr$(1):rem seek rec1
9117 gosub 9000:rem check errors
9118 gosub8145:print#2,k$;:rem convert and write rec
9119 close 2:close15:return:end:rem close up, done creating hiscore file. next run will open file
9120 rem read the hiscore file
9122 open 2,dv,5,"hiscore"
9124 open 15,dv,15:rem must reopen the command channel
9126 gosub 9035:rem read the data
9128 close2:close15:return