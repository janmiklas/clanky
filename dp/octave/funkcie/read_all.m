function ret = read_all(file_vc, file_ic, file_vb, file_ib, Kvc, Kic, Kvb, Kib)
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

	ret.t = dlmread(file_vc, ",", 2, 0)(:,1);
	ret.vc = Kvc * dlmread(file_vc, ",", 2, 1);
	ret.ic = Kic * dlmread(file_ic, ",", 2, 1);
	ret.vb = Kvb * dlmread(file_vb, ",", 2, 1);
	ret.ib = Kib * dlmread(file_ib, ",", 2, 1);
endfunction
