function ret = write_spice_control(timestep, t_stop, t_start, str_plot_variables, str_control_filename, str_data_filename)

	if((FID = fopen(str_control_filename, "w")) == -1)
		puts("nepodarilo sa otvorit subor: ");
		puts(str_control_filename);
		puts("\n");
		ret = -1;
	else
		ret =1;
	endif
	
	fputs(FID, ".control\n");
	fputs(FID, "tran\ ");
	fputs(FID, num2str(timestep));
	fputs(FID, "\ ");
	fputs(FID, num2str(t_stop));
	fputs(FID, "\ ");
	fputs(FID, num2str(t_start))
	fputs(FID, "\n");
	fputs(FID, "set nobreak\n");
	fputs(FID, "print\ ");
	fputs(FID, str_plot_variables);
	fputs(FID, "\ >\ ");
	fputs(FID, str_data_filename);
	fputs(FID, "\n");
	fputs(FID, ".endc\n");
	
	
	if(fclose(FID) == -1)
		puts("nepodarilo sa zavriet subor: ");
		puts(str_control_filename);
		puts("\n");
		ret = -2;
	else
		ret = 2;
	endif
endfunction
