function ret = sw_trig_p2(p)
	sizep=size(p)(1)
	Pmax=max(max(p));
	Pth1 = Pmax*.1
	Pth2 = Pmax*.05
	i=1;
	j=0;
	aa=0;
	while(i<sizep)
		j++;
		while( i<sizep && p(i)<Pth1)
			i++;
			ret(j,1)=i-300;
		endwhile

		while(p(i)>Pth2 && i<sizep)
			i++;
			ret(j,2)=i+300;
		endwhile
		if(i>sizep)
		endif
	endwhile

endfunction
