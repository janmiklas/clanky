function sw_wafer_data = sw_read_wafer(str_wafer, str_vg, str_vc, str_ic, Kic, Kvc)
	
	i=1;
	
	t = dlmread(strcat("sw_", str_wafer, num2str(i, "%02i"), "_", str_vg, ".csv"), ",", 6, 3)(:,1);
	% cas aby zacinal od nuly:
	t=t-t(1);
	% cas v us:
	tus=t*1e6;
	
	% konstanta (prudove trafo)
	if(!exist("Kic"))
		Kic=1
	endif
	% konstanta (dif. sonda)
	if(!exist("Kvc"))
		Kvc=1
	endif
	
	vg=[];
	vc=[];
	ic=[];
	
	while(exist(strcat("sw_", str_wafer, num2str(i, "%02i"), "_", str_vc, ".csv")))
		vg = [vg, dlmread(strcat("sw_", str_wafer, num2str(i, "%02i"), "_", str_vg, ".csv"), ",", 6, 4)];
		vc = [vc, dlmread(strcat("sw_", str_wafer, num2str(i, "%02i"), "_", str_vc, ".csv"), ",", 6, 4)];
		ic = [ic, Kic * dlmread(strcat("sw_", str_wafer, num2str(i, "%02i"), "_", str_ic, ".csv"), ",", 6, 4)];
		i++;
	endwhile

	%vgmax=max(vg);
	%vcmax=max(vc);
	%icmax=max(ic);
	%pmax=icmax*vcmax;
	dt=t(2)-t(1);
	p = vc.*ic;
	en = cumsum(p*dt);
	
	sw_wafer_data.wafer=str_wafer;
	sw_wafer_data.t=t;
	sw_wafer_data.tus=tus;
	sw_wafer_data.dt=dt;
	sw_wafer_data.vg=vg;
	sw_wafer_data.vc=vc;
	sw_wafer_data.ic=ic;
	sw_wafer_data.p=p;
	sw_wafer_data.en=en;
	
endfunction
