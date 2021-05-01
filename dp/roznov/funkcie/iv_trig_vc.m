function ret = trig_vc(vc, VCth1, VCth2)
	sizevc=size(vc)(1)
	i=1;
	j=0;
	aa=0;
	while(i<sizevc)
		j++;
		while( i<sizevc && vc(i)>VCth1)
			i++;
			ret(j,1)=i;
		endwhile

		while(vc(i)<VCth2 && i<sizevc)
			i++;
			ret(j,2)=i;
		endwhile
		if(i>sizevc)
		endif
	endwhile

endfunction
