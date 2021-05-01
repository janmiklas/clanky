function sw_plots_data = sw_plots(sw_wafer_data)
%sw_wafer_data=w04;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% P L O T S
	tr = sw_trig_p(sw_wafer_data.p,3000, 2000);
	t=sw_wafer_data.tus;
	str_wafer=sw_wafer_data.wafer;
	
	%%% turn off
	nb = tr(1,1) - 10*(tr(1,1)>=10) ;
	nt = tr(1,2) + 10*(tr(1,2)<=rows(sw_wafer_data.p)-10);

	toff = sw_wafer_data.tus(nb:nt);
	%% cas od nuly:
	toff = toff - toff(1);
	
	vgoff = sw_wafer_data.vg(nb:nt,:);
	vcoff = sw_wafer_data.vc(nb:nt,:);
	icoff = sw_wafer_data.ic(nb:nt,:);

	figure
	handle_vgvcicoff = plot(toff, vgoff/5+10, toff, vcoff/100, toff ,icoff/10);
	set(gca, 'Ytick', [0:1:15]);
	grid;
	xlabel("Time (us)");
	ylabel("vc (100V/div), ic (10A/div), vg (5V/div)");
	title(strcat("vg, vc, ic", " - ", sw_wafer_data.wafer));
	%xlim([0 3]);
	ylim([0 15]);
	print(strcat("./plots/", str_wafer, "vgvcic_off.png"));


	poff = sw_wafer_data.p(nb:nt,:);

	figure
	handle_poff = plot(toff, poff/1000);
	grid;
	xlabel("Time (us)");
	ylabel("p (kW)");
	title(strcat("p_{off}", " - ", sw_wafer_data.wafer));
	%xlim([0 3]);
	%ylim([0 15]);
	print(strcat("./plots/", str_wafer, "_vgvcic_off.png"));


	enoff = sw_wafer_data.en(nb:nt,:)-sw_wafer_data.en(nb,:);
	
	figure
	handle_enoff = plot(toff, enoff*1000);
	grid;
	xlabel("Time (us)");
	ylabel("Energy (mJ)");
	title(strcat("e_{off}", " - ", sw_wafer_data.wafer));
	%xlim([0 3]);
	%ylim([0 15]);
	print(strcat("./plots/", str_wafer, "_e_off.png"));
	
	Eoff=enoff(rows(enoff),:);
	


	%%% turn on
	
	nb = tr(2,1) - 10*(tr(1,1)>=10) ;
	nt = tr(2,2) + 10*(tr(1,2)<=rows(sw_wafer_data.p)-10);
	
	ton = sw_wafer_data.tus(nb:nt);
	%% cas od nuly:
	ton = ton - ton(1);

	vgon = sw_wafer_data.vg(nb:nt,:);
	vcon = sw_wafer_data.vc(nb:nt,:);
	icon = sw_wafer_data.ic(nb:nt,:);

	figure
	handle_vgvcicon = plot(ton, vgon/5+10, ton, vcon/100, ton ,icon/10);
	set(gca, 'Ytick', [0:1:15]);
	grid;
	xlabel("Time (us)");
	ylabel("vc (100V/div), ic (10A/div), vg (5V/div)");
	title(strcat("vg, vc, ic", " - ", sw_wafer_data.wafer));
	%xlim([0 3]);
	ylim([0 15]);
	print(strcat("./plots/", str_wafer, "vgvcic_on.png"));

	pon = sw_wafer_data.p(nb:nt,:);

	figure
	handle_pon = plot(ton, pon/1000);
	grid;
	xlabel("Time (us)");
	ylabel("p (kW)");
	title(strcat("p_{on}", " - ", sw_wafer_data.wafer));
	%xlim([0 3]);
	%ylim([0 15]);
	print(strcat("./plots/", str_wafer, "_p_on.png"));


	enon = sw_wafer_data.en(nb:nt,:)-sw_wafer_data.en(nb,:);
	
	figure
	handle_enon = plot(ton, enon*1000);
	grid;
	xlabel("Time (us)");
	ylabel("Energy (mJ)");
	title(strcat("e_{on}", " - ", sw_wafer_data.wafer));
	%xlim([0 3]);
	%ylim([0 15]);
	print(strcat("./plots/", str_wafer, "_e_on.png"));
	
	Eon=enon(rows(enon),:);



	%%% histogramy

	
	muEoff = mean(Eoff);
	sigmaEoff = std(Eoff);
	xlo = muEoff-3*sigmaEoff;
	xhi = muEoff+3*sigmaEoff;
	x = xlo:(xhi-xlo)/100:xhi;
	nbins = ceil(sqrt(numel(Eoff)));
	%nbins = 5;
	
	figure
	[nn, xx] = hist(Eoff, nbins);
	binwidth=xx(2)-xx(1);
	Knorm = numel(Eoff)*binwidth;	% obsah plochy
	bar(xx*1000, nn, 1);
	hold on; 	% x*1000 aby vysli [mJ]
	plot( x*1000, Knorm * normpdf(x, muEoff, sigmaEoff),"r");  	% x*1000 aby vysli [mJ]
	xlabel("E_{off} (mJ)");
	ylabel("n");
	title(strcat("", " - ", sw_wafer_data.wafer, ", ", num2str(numel(Eoff)), "pcs"));
	xlim([xlo*1000 xhi*1000]);
	%ylim([0 15]);
	print(strcat("./plots/", str_wafer, "_hist_e_off.png"));
	hold off;
	

	muEon = mean(Eon);
	sigmaEon = std(Eon);
	xlo = muEon-3*sigmaEon;
	xhi = muEon+3*sigmaEon;
	x = xlo:(xhi-xlo)/100:xhi;
	nbins = ceil(sqrt(numel(Eon)));
	%nbins = 5;
	
	figure
	[nn, xx] = hist(Eon, nbins);
	binwidth=xx(2)-xx(1);
	Knorm = numel(Eon)*binwidth;	% obsah plochy
	bar(xx*1000, nn, 1);
	hold on; 	% x*1000 aby vysli [mJ]
	plot( x*1000, Knorm * normpdf(x, muEon, sigmaEon),"r");  	% x*1000 aby vysli [mJ]
	xlabel("E_{on} (mJ)");
	ylabel("n");
	title(strcat("", " - ", sw_wafer_data.wafer, ", ", num2str(numel(Eon)), "pcs"));
	xlim([xlo*1000 xhi*1000]);
	%ylim([0 15]);
	print(strcat("./plots/", str_wafer, "_hist_e_on.png"));
	hold off;
	

	
	
	sw_plots_data.toff = toff;
	sw_plots_data.vgoff = vgoff;
	sw_plots_data.vcoff = vcoff;
	sw_plots_data.icoff = icoff;
	sw_plots_data.poff = poff;
	sw_plots_data.enoff = enoff;
	sw_plots_data.Eoff = Eoff;
	sw_plots_data.muEoff = muEoff;
	sw_plots_data.sigmaEoff = sigmaEoff;

	sw_plots_data.vgon = vgon;
	sw_plots_data.vcon = vcon;
	sw_plots_data.icon = icon;
	sw_plots_data.ton = ton;
	sw_plots_data.pon = pon;
	sw_plots_data.enon = enon;
	sw_plots_data.Eon = Eon;
	sw_plots_data.muEon = muEon;
	sw_plots_data.sigmaEon = sigmaEon;


	sw_plots_data.tr = tr;

	sw_plots_data.handle_vgvcicoff = handle_vgvcicoff;
	sw_plots_data.handle_poff = handle_poff;
	sw_plots_data.handle_enoff = handle_enoff;
	sw_plots_data.handle_vgvcicon = handle_vgvcicon;
	sw_plots_data.handle_pofn= handle_pon;
	sw_plots_data.handle_enon = handle_enon;

endfunction
