function ret = write_spice_model_my(tab_t, abc, str_filename)

	if((FID = fopen(str_filename, "w")) == -1)
		puts("nepodarilo sa otvorit subor: ");
		puts(str_filename);
		puts("\n");
		ret = -1;
	else
		ret =1;
	endif
	
	for i=1:numel(tab_t)
		eval(strcat("str_t", num2str(i-1), " = num2str(tab_t(", num2str(i), "));"));
	endfor
	
	for i=1:numel(abc)/3
		eval(strcat("str_a", num2str(i), " = num2str(abc(", num2str((i-1)*3+1), "));"));
		eval(strcat("str_b", num2str(i), " = num2str(abc(", num2str((i-1)*3+2), "));"));
		eval(strcat("str_c", num2str(i), " = num2str(abc(", num2str((i-1)*3+3), "));"));
	endfor

	%% pripad t012, abc12	
%	str_t0 = num2str(tab_t(1));
%	str_t1 = num2str(tab_t(2));
%	str_t2 = num2str(tab_t(3));
%	
%	str_a1 = num2str(abc(1));
%	str_b1 = num2str(abc(2));
%	str_c1 = num2str(abc(3));
%	str_a2 = num2str(abc(4));
%	str_b2 = num2str(abc(5));
%	str_c2 = num2str(abc(6));
	
	fputs(FID, "Btime ntime 0 v= 'time'\n\n"); 
	
	fputs(FID, "**************************************\n*** vypocet gce podla mojej krivky ***\n**************************************\n");
	fputs(FID, "Bgce ngce 0 v=\n");
	fputs(FID, strcat("+\tv(ntime) < ", str_t0, "?\n"));
	fputs(FID, strcat("+\t\t", str_a1, "*", str_t0, "*", str_t0, "+", str_b1, "*", str_t0, "+", str_c1, "\n"));
	
	for i=1:numel(abc)/3
		str_ti = num2str(tab_t(i+1));
		str_ai = num2str(abc((i-1)*3+1));
		str_bi = num2str(abc((i-1)*3+2));
		str_ci = num2str(abc((i-1)*3+3));

		feval("fputs", FID, strcat("+\t:v(ntime) < ", str_ti, "?\n"));
		feval("fputs", FID, strcat("+\t\t", str_ai, "*v(ntime)*v(ntime)+", str_bi, "*v(ntime)+", str_ci, "\n"));
	endfor


%	fputs(FID, strcat("+\t:v(ntime) < ", str_t1, "?\n"));
%	fputs(FID, strcat("+\t\t", str_a1, "*v(ntime)*v(ntime)+", str_b1, "*v(ntime)+", str_c1, "\n"));
%	fputs(FID, strcat("+\t:v(ntime) < ", str_t2, "?\n"));
%	fputs(FID, strcat("+\t\t", str_a2, "*v(ntime)*v(ntime)+", str_b2, "*v(ntime)+", str_c2, "\n"));

	fputs(FID, "+\t:\n");


	feval("fputs", FID, strcat("+\t\t", str_ai, "*", str_ti, "*", str_ti, "+", str_bi, "*", str_ti, "+", str_ci, "\n"));
%	fputs(FID, strcat("+\t\t", str_a2, "*", str_t2, "*", str_t2, "+", str_b2, "*", str_t2, "+", str_c2, "\n"));
	fputs(FID, "**************************************\n");
	
	if(fclose(FID) == -1)
		puts("nepodarilo sa zatvorit subor: ");
		puts(str_filename);
		puts("\n");
		ret = -2;
	else
		ret = 2;
	endif
endfunction
