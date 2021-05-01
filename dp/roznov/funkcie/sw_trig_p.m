function ret = sw_trig_p(p, Pth1, Pth2)
	sizep=size(p)(1)
	i=1;
	j=0;
	while(i<sizep)
		j++;
		while( i<sizep && p(i)<Pth1)
			i++;
			ret(j,1)=i;
		endwhile

		while(p(i)>Pth2 && i<sizep)
			i++;
			ret(j,2)=i;
		endwhile
		if(i>sizep)
		endif
	endwhile

endfunction
