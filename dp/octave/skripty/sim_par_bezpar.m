addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str_outfile_off = "../../latex/obr/plots/sim_off_L4.tex"
str_outfile_on = "../../latex/obr/plots/sim_on_L4.tex"
tab_off.tus=1+[0 .15 .3];
tab_off.G=[10 2 .001];
tab_off.t=1e-6*tab_off.tus;

tab_on.tus=1+[0 .15 .3];
tab_on.G=[.001 2 10];
tab_on.t=1e-6*tab_on.tus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


abc_off = tab2abc(tab_off.t, tab_off.G);
abc_on = tab2abc_on(tab_on.t, tab_on.G);


system("mkdir /tmp/patocka__");
write_spice_model_my(tab_off.t, abc_off, "/tmp/patocka__/gce_off_par.sp");
t_start = tab_off.t(1)-.2e-6;
t_stop = tab_off.t(numel(tab_off.t))+.2e-6;
numsteps = 10000;
timestep = (t_stop-t_start)/numsteps;
write_spice_control(timestep, t_stop, t_start, "ngce nc i(Va1)", "/tmp/patocka__/control_off.sp", "/tmp/patocka__/data.data")
system("cp /tmp/patocka__/gce_off_par.sp /tmp/patocka__/gce.sp");
system("cp /tmp/patocka__/control_off.sp /tmp/patocka__/control.sp");

system("ngspice -b ../../spice/input.spc");

sim_off_data = dlmread("/tmp/patocka__/data.data", "\t", 5, 0);
sim_off_data = sim_off_data((1:numsteps/1000:rows(sim_off_data)),:); % aby neboli zbytocne velke vektory (a eps subory) v pripade, ze sa da malinky timestep
sim_off.t = sim_off_data(:,2);
sim_off.tus = sim_off.t*1e6;
sim_off.gce = sim_off_data(:,3);
sim_off.vc = sim_off_data(:,4);
sim_off.ic = sim_off_data(:,5);


close;
h = figure("papersize", [.1 .1]);
set(h, "position", [0  0 350 200]);
%plot(sim_off.tus, sim_off.vc/10, "k", sim_off.tus, sim_off.ic, "k", sim_off.tus, sim_off.gce*2.5, "k");
plot(sim_off.tus, sim_off.gce*2.5, "k", sim_off_zakl.tus, sim_off_zakl.vc/10, "k--;bez parazít;", sim_off_zakl.tus, sim_off_zakl.ic, "k--", sim_off.tus, sim_off.vc/10, "k;s parazitami;", sim_off.tus, sim_off.ic, "k");
legend("boxoff");
%grid;
xlim(1e6*[t_start t_stop]);
ylim([-0 50]);
set(gca, "xtick", ceil(sim_off.tus*5)/5:.2:sim_off.tus(end));
set(gca, "ytick", 0:10:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel("Čas");
%ylabel("");
text(t_start*1e6+.1, sim_off.gce(1)*2.5+2, "$g_{CE}$");
text(t_start*1e6+.1, sim_off.vc(1)/10+2, '$u_{CE}$');
text(t_start*1e6+.1, sim_off.ic(1)+2, '$i_{C}$', 'interpreter', 'latex');
system("mkdir plots");
%print('-depslatex', '-S350,200', str_outfile_off); 
%print('-deps', '-S350,200', "/tmp/aa.eps"); 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% zapinaci dej
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
write_spice_model_my(tab_on.t, abc_on, "/tmp/patocka__/gce_on_par.sp");
t_start = tab_on.t(1)-.2e-6;
t_stop = tab_on.t(numel(tab_on.t))+.2e-6;
numsteps = 10000;
timestep = (t_stop-t_start)/numsteps;
write_spice_control(timestep, t_stop, t_start, "ngce nc i(Va1)", "/tmp/patocka__/control_on.sp", "/tmp/patocka__/data.data")
system("cp /tmp/patocka__/gce_on_par.sp /tmp/patocka__/gce.sp");
system("cp /tmp/patocka__/control_on.sp /tmp/patocka__/control.sp");

system("ngspice -b ../../spice/input.spc");

sim_on_data = dlmread("/tmp/patocka__/data.data", "\t", 5, 0);
sim_on_data = sim_on_data((1:numsteps/1000:rows(sim_on_data)),:); % aby neboli zbytocne velke vektory (a eps subory) v pripade, ze sa da malinky timestep
sim_on.t = sim_on_data(:,2);
sim_on.tus = sim_on.t*1e6;
sim_on.gce = sim_on_data(:,3);
sim_on.vc = sim_on_data(:,4);
sim_on.ic = sim_on_data(:,5);


%close;
h = figure("papersize", [.1 .1]);
set(h, "position", [0  0 350 200]);
%plot(sim_on.tus, sim_on.vc/10, "k", sim_on.tus, sim_on.ic, "k", sim_on.tus, sim_on.gce*2.5, "k");
plot(sim_on.tus, sim_on.gce*2.5, "k", sim_on_zakl.tus, sim_on_zakl.vc/10, "k--;bez parazít;", sim_on_zakl.tus, sim_on_zakl.ic, "k--", sim_on.tus, sim_on.vc/10, "k;s parazitami;", sim_on.tus, sim_on.ic, "k");
legend("boxoff");
%grid;
xlim(1e6*[t_start t_stop]);
ylim([-0 50]);
set(gca, "xtick", ceil(sim_on.tus*5)/5:.2:sim_on.tus(end));
set(gca, "ytick", 0:10:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel("Čas");
%ylabel("");
text(t_stop*1e6-.1, sim_on.gce(end)*2.5+2, "$g_{CE}$");
text(t_start*1e6+.1, sim_on.vc(1)/10+2, '$u_{CE}$');
text(t_start*1e6+.1, sim_on.ic(1)+2, '$i_{C}$', 'interpreter', 'latex');
system("mkdir plots");
%print('-depslatex', '-S350,200', str_outfile_on); 
%print('-deps', '-S350,200', "/tmp/aa.eps"); 
