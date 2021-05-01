function abc12= tab2abc_on_2(tab_t012, tab_G012)

	t0=tab_t012(1);
	t1=tab_t012(2);
	t2=tab_t012(3);
	G0=tab_G012(1);
	G1=tab_G012(2);
	G2=tab_G012(3);

	V = [G0; G1; G1; G2; 0; 0];

	M = [	t0^2,	t0,	1,	0,	0,	0;
		t1^2,	t1,	1,	0,	0,	0;
		0,	0,	0,	t1^2,	t1,	1;
		0,	0,	0,	t2^2,	t2,	1;
		2*t1,	1,	0,	-2*t1,	-1,	0;
		2*t0,	1,	0,	0,	0,	0];
	abc12 = X = M \ V;
endfunction
