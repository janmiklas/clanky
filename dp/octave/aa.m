%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mer_path1 = "../merania/0513/";
mer_path2 = "BP_BUV48A_300V_10A_02/";
mer_filename_vc = "scope_16_1.csv";
mer_filename_ic = "scope_16_4.csv";
mer_filename_vb = "scope_16_2.csv";
mer_filename_ib = "scope_16_3.csv";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_vc = strcat(mer_path1, mer_path2, mer_filename_vc);
file_ic = strcat(mer_path1, mer_path2, mer_filename_ic);
file_vb = strcat(mer_path1, mer_path2, mer_filename_vb);
file_ib = strcat(mer_path1, mer_path2, mer_filename_ib);
addpath "./funkcie/"

mer_a = read_all(file_vc, file_ic, file_vb, file_ib);
mer_a.tus=mer_a.t*1e6;


tab.G=[7, 10/300, 0.1e-6];
tab.t=1e-6*[0, 1.26 , 1.5];
tab.t=tab.t+109.9e-6;
abc = tab2abc_vect(tab.t, tab.G)

FID_spo1 = fopen("/tmp/spo1.sp", "w");

fputs(FID_spo1, "Btime ntime 0 v= 'time'\n"); 
fputs(FID_spo1, "\n");
fputs(FID_spo1, "Btime0 ntime0 0 v="); fputs(FID_spo1, num2str(tab.t(1))); fputs(FID_spo1, "\n");
fputs(FID_spo1, "Btime1 ntime1 0 v="); fputs(FID_spo1, num2str(tab.t(2))); fputs(FID_spo1, "\n");
fputs(FID_spo1, "Btime2 ntime2 0 v="); fputs(FID_spo1, num2str(tab.t(3))); fputs(FID_spo1, "\n");
fputs(FID_spo1, "\n");

fputs(FID_spo1, "Ba1 na1 0 v="); fputs(FID_spo1, num2str(abc(1))); fputs(FID_spo1, "\n");
fputs(FID_spo1, "Bb1 nb1 0 v="); fputs(FID_spo1, num2str(abc(2))); fputs(FID_spo1, "\n");
fputs(FID_spo1, "Bc1 nc1 0 v="); fputs(FID_spo1, num2str(abc(3))); fputs(FID_spo1, "\n");
fputs(FID_spo1, "Ba2 na2 0 v="); fputs(FID_spo1, num2str(abc(4))); fputs(FID_spo1, "\n");
fputs(FID_spo1, "Bb2 nb2 0 v="); fputs(FID_spo1, num2str(abc(5))); fputs(FID_spo1, "\n");
fputs(FID_spo1, "Bc2 nc2 0 v="); fputs(FID_spo1, num2str(abc(6))); fputs(FID_spo1, "\n");
fputs(FID_spo1, "\n");

fputs(FID_spo1, "**************************************\n*** vypocet gce podla mojej krivky ***\n**************************************\n");
fputs(FID_spo1, "Bgce ngce 0 v=\n");
fputs(FID_spo1, "+\tv(ntime) < v(ntime0) ?\n");
fputs(FID_spo1, "+\t\tv(na1)*v(ntime0)^2+v(nb1)*v(ntime0)+v(nc1)\n");
fputs(FID_spo1, "+\t:v(ntime) < v(ntime1) ?\n");
fputs(FID_spo1, "+\t\tv(na1)*v(ntime)^2+v(nb1)*v(ntime)+v(nc1)\n");
fputs(FID_spo1, "+\t:v(ntime) < v(ntime2) ?\n");
fputs(FID_spo1, "+\t\tv(na2)*v(ntime)^2+v(nb2)*v(ntime)+v(nc2)\n");
fputs(FID_spo1, "+\t:\n");
fputs(FID_spo1, "+\t\tv(na2)*v(ntime2)^2+v(nb2)*v(ntime2)+v(nc2)\n");
fputs(FID_spo1, "**************************************\n");

fclose(FID_spo1);


t = 0:.1e-7:5e-6;
t = t+tab.t(1);
gce = abc_vect2g(abc, t, tab.t(1), tab.t(2), tab.t(3));
%plot(t, gce);



system("ngspice -b ../spice/input1.sp");
%system("ngspice ../spice/input1.sp")

sim_data = dlmread("/tmp/data/j.data", "\t", 5, 0);
sim.t = sim_data(:,2);
sim.tus = sim.t*1e6;
sim.gce = sim_data(:,3);
sim.vc = sim_data(:,4);
sim.ic = sim_data(:,5);



mer=mer_a;
plot(mer.tus, mer.vc/10, mer.tus, mer.ic, sim.tus, sim.vc/10, sim.tus, sim.ic);
grid;
xlim([110.5, 111.5]);
xlabel("Time (us)");
