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


%tab.G=[7, 10/300, 0.1e-6];
%tab.t=1e-6*[0, 1.26 , 1.5];
%tab.t=tab.t+109.9e-6;
tab.G=[7, 3.1/300, 0.1e-6];
tab.t=1e-6*[109.4, 111.25 , 111.4];
abc = tab2abc_vect(tab.t, tab.G)



write_spice_model_1c(tab.t, abc, "/tmp/spo1.sp");


t = 0:.1e-7:5e-6;
t = t+tab.t(1);
gce = abc_vect2g(abc, t, tab.t(1), tab.t(2), tab.t(3));
%plot(t, gce);



system("mkdir /tmp/data");
system("ngspice -b ../spice/input1.sp");
%system("ngspice ../spice/input1.sp");

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
