function n = t2n(data_t, t)
	dt = data_t(2)-data_t(1);
	n = (t-data_t(1))/dt + 1;
	n = int32(n);
endfunction
