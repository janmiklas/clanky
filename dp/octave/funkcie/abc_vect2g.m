function gce = abc_vect2g(abc, t, t0, t1, t2)
	a1=abc(1); b1=abc(2); c1=abc(3); a2=abc(4); b2=abc(5); c2=abc(6);
	gce = (a1*t0.^2 + b1*t0 + c1).*(t<t0) + (a1*t.^2 + b1*t + c1).*(t>=t0 & t<t1) + (a2*t.^2 + b2*t + c2).*(t>=t1 & t<t2) + (a2*t2.^2 + b2*t2 + c2).*(t>=t2);	
endfunction


%% pouzitie:
%t = 0:.1e-7:5e-6
%gce = abc2g(abc, t, t0, t1, t2);
%plot(t, gce)
