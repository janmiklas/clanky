function ret = write_spice_model_1c_4(tab_t01234, abc1234, str_filename)

	if((FID_spo1 = fopen(str_filename, "w")) == -1)
		puts("nepodarilo sa otvorit subor: ");
		puts(str_filename);
		puts("\n");
		ret = -1;
	else
		ret =1;
	endif
	
	
	str_t0 = num2str(tab_t01234(1));
	str_t1 = num2str(tab_t01234(2));
	str_t2 = num2str(tab_t01234(3));
	str_t3 = num2str(tab_t01234(4));
	str_t4 = num2str(tab_t01234(5));
	
	str_a1 = num2str(abc(1));
	str_b1 = num2str(abc(2));
	str_c1 = num2str(abc(3));
	str_a2 = num2str(abc(4));
	str_b2 = num2str(abc(5));
	str_c2 = num2str(abc(6));
	str_a3 = num2str(abc(7));
	str_b3 = num2str(abc(8));
	str_c3 = num2str(abc(9));
	str_a4 = num2str(abc(10));
	str_b4 = num2str(abc(11));
	str_c4 = num2str(abc(12));
	
	fputs(FID_spo1, "Btime ntime 0 v= 'time'\n\n"); 
	
	fputs(FID_spo1, "**************************************\n*** vypocet gce podla mojej krivky ***\n**************************************\n");
	fputs(FID_spo1, "Bgce ngce 0 v=\n");
	fputs(FID_spo1, strcat("+\tv(ntime) < ", str_t0, "?\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a1, "*", str_t0, "*", str_t0, "+", str_b1, "*", str_t0, "+", str_c1, "\n"));
	

	fputs(FID_spo1, strcat("+\t:v(ntime) < ", str_t1, "?\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a1, "*v(ntime)*v(ntime)+", str_b1, "*v(ntime)+", str_c1, "\n"));

	fputs(FID_spo1, strcat("+\t:v(ntime) < ", str_t2, "?\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a2, "*v(ntime)*v(ntime)+", str_b2, "*v(ntime)+", str_c2, "\n"));

	fputs(FID_spo1, strcat("+\t:v(ntime) < ", str_t3, "?\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a3, "*v(ntime)*v(ntime)+", str_b3, "*v(ntime)+", str_c3, "\n"));

	fputs(FID_spo1, strcat("+\t:v(ntime) < ", str_t4, "?\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a4, "*v(ntime)*v(ntime)+", str_b4, "*v(ntime)+", str_c4, "\n"));


	fputs(FID_spo1, strcat("+\t:\n"));
	fputs(FID_spo1, strcat("+\t\t", str_a4, "*", str_t4, "*", str_t4, "+", str_b4, "*", str_t4, "+", str_c4, "\n"));
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
