function ret = write_spice_model_1c(tab_t, abc, str_filename)

	if((FID_spo1 = fopen(str_filename, "w")) == -1)
		puts("nepodarilo sa otvorit subor: ");
		puts(str_filename);
		puts("\n");
		ret = -1;
	else
		ret =1;
	endif
	
	
	str_t0 = num2str(tab_t(1));
	str_t1 = num2str(tab_t(2));
	str_t2 = num2str(tab_t(3));
	
	str_a1 = num2str(abc(1));
	str_b1 = num2str(abc(2));
	str_c1 = num2str(abc(3));
	str_a2 = num2str(abc(4));
	str_b2 = num2str(abc(5));
	str_c2 = num2str(abc(6));
	
	fputs(FID_spo1, "Btime ntime 0 v= 'time'\n\n"); 
	
	fputs(FID_spo1, "**************************************\n*** vypocet gce podla mojej krivky ***\n**************************************\n");
	fputs(FID_spo1, "Bgce ngce 0 v=\n");
	fputs(FID_spo1, strcat("+\tv(ntime) < ", str_t0, "?\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a1, "*", str_t0, "*", str_t0, "+", str_b1, "*", str_t0, "+", str_c1, "\n"));
	fputs(FID_spo1, strcat("+\t:v(ntime) < ", str_t1, "?\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a1, "*v(ntime)*v(ntime)+", str_b1, "*v(ntime)+", str_c1, "\n"));
	fputs(FID_spo1, strcat("+\t:v(ntime) < ", str_t2, "?\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a2, "*v(ntime)*v(ntime)+", str_b2, "*v(ntime)+", str_c2, "\n"));
	fputs(FID_spo1, strcat("+\t:\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a2, "*", str_t2, "*", str_t2, "+", str_b2, "*", str_t2, "+", str_c2, "\n"));
	fputs(FID_spo1, "**************************************\n");
	
	if(fclose(FID_spo1) == -1)
		puts("nepodarilo sa zavriet subor: ");
		puts(str_filename);
		puts("\n");
		ret = -2;
	else
		ret = 2;
	endif
endfunction
