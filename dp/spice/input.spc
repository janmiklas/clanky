*SPICE circuit <input> from XCircuit v3.8 rev 78

.include /tmp/patocka__/gce.sp
.include /tmp/patocka__/control.sp
C5 int4 int10 000p
C2 int7 ne 000p
L3 int10 nc 00n
Rd int11 int4 r='v(int11 ) > v(int4 ) ? .1u : 10MEG'
V1 int4 int5 303
L1 ne 0 00n
Va1 0 int12 0
R1 int12 int5 0
Rce1 int7 ne r='1/v(ngce)'
L4 int11 int10 00n
L2 nc int7 00n
I1 int4 int10 10
C1 int7 0 000p
C3 int10 0 000p
C4 int10 int7 000p
C6 int4 int11 000p

.end
