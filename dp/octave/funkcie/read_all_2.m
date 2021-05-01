function ret = read_all_2(file, Kvc, Kic, Kvb, Kib)
	if(!exist("Kvc"))
		Kvc = 1
	endif
	if(!exist("Kic"))
		Kic = 2;	% 1ohm, 1/2 (50+50ohm)
	endif
	if(!exist("Kvb"))
		Kvb = 1;
	endif
	if(!exist("Kib"))
		Kib = 2000/500;	% prudove trafo 1:40, bocnik 10ohm
	endif

	data=dlmread(file, ",", 22, 1);

	ret.t = data(:,1);
	ret.vc = Kvc*data(:,2);
	ret.vb = Kvb*data(:,3);
	ret.ib = Kib*data(:,4);
	ret.ic = Kic*data(:,5);

endfunction
