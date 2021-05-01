function iv_wafer_data = iv_read_wafer(str_wafer, str_vc, str_ic, Kic, Kvc)
	
	i=1;
	
	t = dlmread(strcat(str_wafer, num2str(i, "%02i"), "_", str_vc, ".csv"), ",", 6, 3)(:,1);
	% cas aby zacinal od nuly:
	t=t-t(1);
	
	% konstanta (prudove trafo)
	if(!exist("Kic"))
		Kic=1;
	endif
	% konstanta (dif. sonda)
	if(!exist("Kvc"))
		Kvc=1;
	endif
	
	
	vc=[];
	ic=[];
	
	while(exist(strcat(str_wafer, num2str(i, "%02i"), "_", str_vc, ".csv")))
		vc = [vc, Kvc * dlmread(strcat(str_wafer, num2str(i, "%02i"), "_", str_vc, ".csv"), ",", 6, 4)];
		ic = [ic, Kic * dlmread(strcat(str_wafer, num2str(i, "%02i"), "_", str_ic, ".csv"), ",", 6, 4)];
		i++;
	endwhile
	
	%vcmax=max(vc);
	%icmax=max(ic);
	%pmax=icmax*vcmax;
	dt=t(2)-t(1);
	
	iv_wafer_data.vv = vc;
	iv_wafer_data.ii = ic;
	
	iv_wafer_data.tt = t;
endfunction
