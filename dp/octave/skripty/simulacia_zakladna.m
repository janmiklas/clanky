addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str_outfile_off = "../../latex/obr/plots/sim_off_C5.tex"
str_outfile_on = "../../latex/obr/plots/sim_on_C5.tex"
tab_off.tus=1+[0 .15 .3];
tab_off.G=[10 2 .001];
tab_off.t=1e-6*tab_off.tus;

tab_on.tus=1+[0 .15 .3];
tab_on.G=[.001 2 10];
tab_on.t=1e-6*tab_on.tus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


abc = tab2abc(tab_off.t, tab_off.G);
abc_on = tab2abc(tab_on.t, tab_on.G);


system("mkdir /tmp/patocka__");
write_spice_model_my(tab_off.t, abc, "/tmp/patocka__/gce_off.sp");
t_start = tab_off.t(1)-.2e-6;
t_stop = tab_off.t(numel(tab_off.t))+.2e-6;
numsteps = 10000;
timestep = (t_stop-t_start)/numsteps;
write_spice_control(timestep, t_stop, t_start, "ngce nc i(Va1)", "/tmp/patocka__/control_off.sp", "/tmp/patocka__/data.data")
system("cp /tmp/patocka__/gce_off.sp /tmp/patocka__/gce.sp");
system("cp /tmp/patocka__/control_off.sp /tmp/patocka__/control.sp");

system("ngspice -b ../../spice/input.spc");

sim_data = dlmread("/tmp/patocka__/data.data", "\t", 5, 0);
sim_data = sim_data((1:numsteps/1000:rows(sim_data)),:); % aby neboli zbytocne velke vektory (a eps subory) v pripade, ze sa da malinky timestep
sim.t = sim_data(:,2);
sim.tus = sim.t*1e6;
sim.gce = sim_data(:,3);
sim.vc = sim_data(:,4);
sim.ic = sim_data(:,5);


close;
h = figure("papersize", [.1 .1]);
set(h, "position", [0  0 350 200]);
%plot(sim.tus, sim.vc/10, "k", sim.tus, sim.ic, "k", sim.tus, sim.gce*2.5, "k");
plot(sim.tus, sim.gce*2.5, "k", sim_zakl.tus, sim_zakl.vc/10, "k--;bez parazít;", sim_zakl.tus, sim_zakl.ic, "k--", sim.tus, sim.vc/10, "k;s parazitami;", sim.tus, sim.ic, "k");
%grid;
xlim(1e6*[t_start t_stop]);
ylim([-0 50]);
set(gca, "xtick", ceil(sim.tus*5)/5:.2:sim.tus(end));
set(gca, "ytick", 0:10:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel("Čas");
%ylabel("");
text(t_start*1e6+.1, sim.gce(1)*2.5+2, "$g_{CE}$");
text(t_start*1e6+.1, sim.vc(1)/10+2, '$u_{CE}$');
text(t_start*1e6+.1, sim.ic(1)+2, '$i_{C}$', 'interpreter', 'latex');
system("mkdir plots");
%print('-depslatex', '-S350,200', str_outfile_off); 
%print('-deps', '-S350,200', "/tmp/aa.eps"); 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% zapinaci dej
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_spice_model_my(tab_off.t, abc, "/tmp/patocka__/gce_off.sp");
t_start = tab_off.t(1)-.2e-6;
t_stop = tab_off.t(numel(tab_off.t))+.2e-6;
numsteps = 10000;
timestep = (t_stop-t_start)/numsteps;
write_spice_control(timestep, t_stop, t_start, "ngce nc i(Va1)", "/tmp/patocka__/control_off.sp", "/tmp/patocka__/data.data")
system("cp /tmp/patocka__/gce_off.sp /tmp/patocka__/gce.sp");
system("cp /tmp/patocka__/control_off.sp /tmp/patocka__/control.sp");

system("ngspice -b ../../spice/input.spc");

sim_data = dlmread("/tmp/patocka__/data.data", "\t", 5, 0);
sim_data = sim_data((1:numsteps/1000:rows(sim_data)),:); % aby neboli zbytocne velke vektory (a eps subory) v pripade, ze sa da malinky timestep
sim.t = sim_data(:,2);
sim.tus = sim.t*1e6;
sim.gce = sim_data(:,3);
sim.vc = sim_data(:,4);
sim.ic = sim_data(:,5);


close;
h = figure("papersize", [.1 .1]);
set(h, "position", [0  0 350 200]);
%plot(sim.tus, sim.vc/10, "k", sim.tus, sim.ic, "k", sim.tus, sim.gce*2.5, "k");
plot(sim.tus, sim.gce*2.5, "k", sim_zakl.tus, sim_zakl.vc/10, "k--;bez parazít;", sim_zakl.tus, sim_zakl.ic, "k--", sim.tus, sim.vc/10, "k;s parazitami;", sim.tus, sim.ic, "k");
%grid;
xlim(1e6*[t_start t_stop]);
ylim([-0 50]);
set(gca, "xtick", ceil(sim.tus*5)/5:.2:sim.tus(end));
set(gca, "ytick", 0:10:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel("Čas");
%ylabel("");
text(t_start*1e6+.1, sim.gce(1)*2.5+2, "$g_{CE}$");
text(t_start*1e6+.1, sim.vc(1)/10+2, '$u_{CE}$');
text(t_start*1e6+.1, sim.ic(1)+2, '$i_{C}$', 'interpreter', 'latex');
system("mkdir plots");
%print('-depslatex', '-S350,200', str_outfile_on); 
%print('-deps', '-S350,200', "/tmp/aa.eps"); 
