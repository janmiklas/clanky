function sw_wafer_data = sw_read_wafer_2(str_wafer, Ch_num_vg, Ch_num_vc, Ch_num_ic, Kic, Kvc)
	
	i=1;
	
	t = dlmread(strcat("sw_", str_wafer, num2str(i, "%02i"), ".csv"), ",", 21, 0)(:,1);
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
	
	while(exist(strcat("sw_", str_wafer, num2str(i, "%02i"), ".csv")))
		vg = [vg, dlmread(strcat("sw_", str_wafer, num2str(i, "%02i"), ".csv"), ",", 21, 0)(:,Ch_num_vg+1)];
		vc = [vc, dlmread(strcat("sw_", str_wafer, num2str(i, "%02i"), ".csv"), ",", 21, 0)(:,Ch_num_vc+1)];
		ic = [ic, dlmread(strcat("sw_", str_wafer, num2str(i, "%02i"), ".csv"), ",", 21, 0)(:,Ch_num_ic+1)];
		i++;
	endwhile

	t=t(1:rows(t)-1,:);
	tus=tus(1:rows(tus)-1,:);
	vg=vg(1:rows(vg)-1,:);
	vc=vc(1:rows(vc)-1,:);
	ic=ic(1:rows(ic)-1,:);

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
