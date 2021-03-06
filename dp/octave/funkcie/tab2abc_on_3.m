function abc123 = tab2abc_on_3(tab_t0123, tab_G0123)

	t0=tab_t0123(1);
	t1=tab_t0123(2);
	t2=tab_t0123(3);
	t3=tab_t0123(4);
	G0=tab_G0123(1);
	G1=tab_G0123(2);
	G2=tab_G0123(3);
	G3=tab_G0123(4);

	V = [G0; G1; G1; G2; G2; G3; 0; 0; 0];

	M = [	t0^2,	t0,	1,	0,	0,	0,	0,	0,	0;	%1
		t1^2,	t1,	1,	0,	0,	0,	0,	0,	0;	%2
		0,	0,	0,	t1^2,	t1,	1,	0,	0,	0;	%3
		0,	0,	0,	t2^2,	t2,	1,	0,	0,	0;	%4
		0,	0,	0,	0,	0,	0,	t2^2,	t2,	1;	%5
		0,	0,	0,	0,	0,	0,	t3^2,	t3,	1;	%6
		2*t1,	1,	0,	-2*t1,	-1,	0,	0,	0,	0;	%7
		0,	0,	0,	2*t2,	1,	0,	-2*t2,	-1,	0;	%8
		2*t0,	1,	0,	0,	0,	0,	0,	0,	0];	%9
	abc123 = X = M \ V;
endfunction
