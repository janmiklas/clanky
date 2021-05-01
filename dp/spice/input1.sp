pokus

****************************
*** parametre ***
****************************
.temp 160
.param Il=10
BT nT 0 v='temper'
BIc nIc 0 v=Il
****************************

.include /tmp/spo1.sp


* * * * * * * * * * * * * * * * * * * * *
*** samotny obvod ***
* * * * * * * * * * * * * * * * * * * * *
Vd 1 0 300

Il 1 nc Il
Rd0 111 11 r='v(111)>(v(11))?.1u:.10MEG'
Vad0 11 1 0V
Cd0 111 11 000p
Lpar 111 nc .0u
//Rpar 111 nc .01MEG
Rce nc ne r='1/v(ngce)'
Cce nc ne 000p
Vae ne 0 0V


.control
tran  .002u 118u 108u
set nobreak
//print ngce nc i(Vae) > ../latex/obr/gnuplot/patVj_j.data
print ngce nc i(Vae) > /tmp/data/j.data
//plot ngce nc i(Vae) 
*plot np/1000000 nw
.endc

.END
