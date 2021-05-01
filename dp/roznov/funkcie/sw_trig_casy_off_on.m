function ret = sw_trig_casy_off_on(measured, Vdc, Il, Vdrvpos, Vdrvneg)
	vc=measured.vc;
	ic=measured.ic;
	vdrv=measured.vdrv;

	if(!exist("Vdc"))
		Vdc = 600;
	endif
	if(!exist("Il"))
		Il = 40;
	endif
	if(!exist("Vdrvpos"))
		Vdrvpos = 15;
	endif
	if(!exist("Vdrvneg"))
		Vdrvneg = -3;
	endif
	Vpeak=max(vc);
	sizevc=rows(vc);
	j=1;
	i=1;
	for j= 1:columns(vc)
		%%%%%%%%%%%%%%%
		%% turn off  %%
		%%%%%%%%%%%%%%%
		i=1;
		while(i<sizevc && vdrv(i,j)>.7*Vdrvpos)
			i++;
			ret(1,j)=i;
		endwhile

		while(i<sizevc && vc(i,j)<.1*Vdc)
			i++;
			ret(2,j)=i;
		endwhile 

		while(i<sizevc && vc(i,j)<1.0*Vdc)
			i++;
			ret(3,j)=i;
		endwhile

		while(i<sizevc && (vc(i,j)>1.03*Vdc || ic(i,j)>.5*Il))
			i++;
			ret(4,j)=i;
		endwhile

		while(i<sizevc && ic(i,j)>.03*Il)
			i++;
			ret(5,j)=i;
		endwhile


		%%%%%%%%%%%%%%
		%% turn on  %%
		%%%%%%%%%%%%%%

		while(i<sizevc && vdrv(i,j)<(Vdrvneg+.2*(Vdrvpos-Vdrvneg)))
			i++;
			ret(6,j)=i;
		endwhile

		while(i<sizevc && ic(i,j)<.1*Il)
			i++;
			ret(7,j)=i;
		endwhile

		while(i<sizevc && ic(i,j)<.9*Il)
			i++;
			ret(8,j)=i;
		endwhile

		while(i<sizevc && vc(i,j)>.1*Vdc)
			i++;
			ret(9,j)=i;
		endwhile

		while(i<sizevc && vc(i,j)>.03*Vdc)
			i++;
			ret(10,j)=i;
		endwhile
	endfor
endfunction
