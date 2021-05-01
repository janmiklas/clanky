addpath "../funkcie/"


file_vc = strcat(mer_path1, mer_path2, mer_filename_vc);
file_ic = strcat(mer_path1, mer_path2, mer_filename_ic);
file_vg = strcat(mer_path1, mer_path2, mer_filename_vg);
file_ig = strcat(mer_path1, mer_path2, mer_filename_ig);

mer = read_all(file_vc, file_ic, file_vg, file_ig);
mer.tus=mer.t*1e6;

abc_off = tab2abc(tab_off.t, tab_off.G);
abc_on = tab2abc_on(tab_on.t, tab_on.G);


system("mkdir /tmp/patocka__");
write_spice_model_my(tab_off.t, abc_off, "/tmp/patocka__/gce_off.sp");
write_spice_model_my(tab_on.t, abc_on, "/tmp/patocka__/gce_on.sp");

t_start = tab_off.t(1)-.2e-6;
t_stop = tab_off.t(numel(tab_off.t))+.2e-6;
if(!exist("numsteps"))
	numsteps = 1000;
endif
timestep = (t_stop-t_start)/numsteps;
write_spice_control(timestep, t_stop, t_start, "ngce nc i(Va1)", "/tmp/patocka__/control_off.sp", "/tmp/patocka__/data.data")
system("cp /tmp/patocka__/gce_off.sp /tmp/patocka__/gce.sp");
system("cp /tmp/patocka__/control_off.sp /tmp/patocka__/control.sp");

system("ngspice -b ../../spice/input.spc");

sim_off_data = dlmread("/tmp/patocka__/data.data", "\t", 5, 0);
sim_off_data = sim_off_data((1:numsteps/1000:rows(sim_off_data)),:); % aby neboli zbytocne velke vektory (a eps subory) v pripade, ze sa da malinky timestep
sim_off.t = sim_off_data(:,2);
sim_off.tus = sim_off.t*1e6;
sim_off.gce = sim_off_data(:,3);
sim_off.vc = sim_off_data(:,4);
sim_off.ic = sim_off_data(:,5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% turn off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
h_off = figure%("papersize", [.1 .1]);
set(h_off, "position", [0  0 350 200]);
plot(mer.tus, mer.vc/10, "k", mer.tus, mer.ic, "k;meranie;", sim_off.tus, sim_off.vc/10, "k--", sim_off.tus, sim_off.ic, "k--", sim_off.tus, sim_off.gce/2*5, "k--;simulácia;");
legend("boxoff");
grid;
xlim(1e6*[t_start t_stop]);
ylim([-2 50]);
set(gca, "xtick", ceil(sim_off.tus*5)/5:.2:sim_off.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 5\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');
text(t_start*1e6+.1, sim_off.gce(1)/2*5+2, '$g_{CE}$', 'interpreter', 'latex');
text(t_start*1e6+.1, sim_off.vc(1)/10+2, '$u_{CE}$', 'interpreter', 'latex');
text(t_start*1e6+.1, sim_off.ic(1), '$i_{C}$', 'interpreter', 'latex');
system("mkdir plots");
print('-depslatex', '-S350,200', outfilename_off); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% turn on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_start = tab_on.t(1)-.2e-6;
t_stop = tab_on.t(numel(tab_on.t))+.2e-6;
if(!exist("numsteps"))
	numsteps = 1000;
endif
timestep = (t_stop-t_start)/numsteps;
write_spice_control(timestep, t_stop, t_start, "ngce nc i(Va1)", "/tmp/patocka__/control_on.sp", "/tmp/patocka__/data.data")
system("cp /tmp/patocka__/gce_on.sp /tmp/patocka__/gce.sp");
system("cp /tmp/patocka__/control_on.sp /tmp/patocka__/control.sp");

system("ngspice -b ../../spice/input.spc");

sim_on_data = dlmread("/tmp/patocka__/data.data", "\t", 5, 0);
sim_on_data = sim_on_data((1:numsteps/1000:rows(sim_on_data)),:); % aby neboli zbytocne velke vektory (a eps subory) v pripade, ze sa da malinky timestep
sim_on.t = sim_on_data(:,2);
sim_on.tus = sim_on.t*1e6;
sim_on.gce = sim_on_data(:,3);
sim_on.vc = sim_on_data(:,4);
sim_on.ic = sim_on_data(:,5);

figure; close;
h_on = figure%("papersize", [.1 .1]);
set(h_on, "position", [0  0 350 200]);
plot(mer.tus, mer.vc/10, "k", mer.tus, mer.ic, "k;meranie;", sim_on.tus, sim_on.vc/10, "k--", sim_on.tus, sim_on.ic, "k--", sim_on.tus, sim_on.gce/2*5, "k--;simulácia;");
legend("boxoff");
grid;
xlim(1e6*[t_start t_stop]);
ylim([-2 50]);
set(gca, "xtick", ceil(sim_on.tus*5)/5:.2:sim_on.tus(end));
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 5\un{A/div},\,\,\, 2\un{S/div}$', 'interpreter', 'latex');
text(t_stop*1e6-.1, sim_on.gce(end)/2*5+2, '$g_{CE}$', 'interpreter', 'latex');
text(t_start*1e6+.1, sim_on.vc(1)/10+2, '$u_{CE}$', 'interpreter', 'latex');
text(t_start*1e6+.1, sim_on.ic(1), '$i_{C}$', 'interpreter', 'latex');
system("mkdir plots");
print('-depslatex', '-S350,200', outfilename_on); 
