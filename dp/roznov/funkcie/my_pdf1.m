function ret = my_pdf1(mu,sigma)
	xb=min(mu)-3*max(sigma);
	xt=max(mu)+3*max(sigma);
	ret.x=x=(xb:(xt-xb)/1000:xt)';
	ret.pdf=[normpdf(x, mu(1), sigma(1))];
	for i=2:rows(mu)
		ret.pdf=[ret.pdf, normpdf(x, mu(i), sigma(i))-sum(ret.pdf)]
	endfor
endfunction
