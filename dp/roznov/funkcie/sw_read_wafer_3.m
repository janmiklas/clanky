function sw_wafer_data = sw_read_wafer_3(str_wafer, Ch_num_drv, Ch_num_vg, Ch_num_vc, Ch_num_ic, Kic, Kvc)
	
	i=1;
	
	data = dlmread(strcat(str_wafer, "/tek00", num2str(i, "%02i"), "ALL.csv"), ",", 21, 0);

	t=data(:,1);
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
	
	vdrv=[];
	vg=[];
	vc=[];
	ic=[];
	
	while(exist(strcat(str_wafer, "/tek00", num2str(i, "%02i"), "ALL.csv")))
		data = dlmread(strcat(str_wafer, "/tek00", num2str(i, "%02i"), "ALL.csv"), ",", 21, 0);
		vdrv = [vdrv, data(:,Ch_num_drv+1)];
		vg = [vg, data(:,Ch_num_vg+1)];
		vc = [vc, Kvc*data(:,Ch_num_vc+1)];
		ic = [ic, Kic*data(:,Ch_num_ic+1)];
		i++;
	endwhile

	t=t(1:rows(t)-1,:);
	tus=tus(1:rows(tus)-1,:);
	vdrv=vdrv(1:rows(vdrv)-1,:);
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
	sw_wafer_data.vdrv=vdrv;
	sw_wafer_data.vg=vg;
	sw_wafer_data.vc=vc;
	sw_wafer_data.ic=ic;
	sw_wafer_data.p=p;
	sw_wafer_data.p_kW=p/1000;
	sw_wafer_data.en=en;
	sw_wafer_data.en_mJ=en*1000;
	
endfunction
