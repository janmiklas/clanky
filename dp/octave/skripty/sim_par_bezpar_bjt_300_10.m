addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str_outfile_off = "../../latex/obr/plots/sim_par_bezpar_bjt_300_10_off.tex"
str_outfile_on = "../../latex/obr/plots/sim_par_bezpar_bjt_300_10_on.tex"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



sim_off_bezpar = sim_off_bezpar;
sim_off_par = sim_off_par;


close;
h = figure("papersize", [.1 .1]);
set(h, "position", [0  0 350 200]);
%plot(sim_off.tus, sim_off.vc/10, "k", sim_off.tus, sim_off.ic, "k", sim_off.tus, sim_off.gce*2.5, "k");
plot(sim_off_bezpar.tus, sim_off_bezpar.gce*2.5, "k", sim_off_bezpar.tus, sim_off_bezpar.vc/10, "k--;idealizované;", sim_off_bezpar.tus, sim_off_bezpar.ic, "k--", sim_off_par.tus, sim_off_par.vc/10, "k;korigované;", sim_off_par.tus, sim_off_par.ic, "k");
legend("boxoff");
grid;
xlim([110.8 111.4]);
ylim([-0 50]);
set(gca, "xtick", ceil(sim_off_bezpar.tus*5)/5:.2:sim_off_bezpar.tus(end));
set(gca, "ytick", 0:10:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel("Čas");
%ylabel("");
text(t_start*1e6+.1, sim_off_bezpar.gce(1)*2.5+2, '$g_{CE}$', 'interpreter', 'latex');
text(t_start*1e6+.1, sim_off_bezpar.vc(1)/10+2, '$u_{CE}$');
text(t_start*1e6+.1, sim_off_bezpar.ic(1)+2, '$i_{C}$', 'interpreter', 'latex');
system("mkdir plots");
print('-depslatex', '-S350,200', str_outfile_off); 
%print('-deps', '-S350,200', "/tmp/aa.eps"); 



sim_on_bezpar = sim_on_bezpar;
sim_on_par = sim_on_par;


%close;
h = figure("papersize", [.1 .1]);
set(h, "position", [0  0 350 200]);
%plot(sim_on.tus, sim_on.vc/10, "k", sim_on.tus, sim_on.ic, "k", sim_on.tus, sim_on.gce*2.5, "k");
plot(sim_on_bezpar.tus, sim_on_bezpar.gce*2.5, "k", sim_on_bezpar.tus, sim_on_bezpar.vc/10, "k--;idealizované;", sim_on_bezpar.tus, sim_on_bezpar.ic, "k--", sim_on_par.tus, sim_on_par.vc/10, "k;korigované;", sim_on_par.tus, sim_on_par.ic, "k");
legend("boxoff");
grid;
xlim([153.4 154]);
ylim([-0 50]);
set(gca, "xtick", ceil(sim_on_bezpar.tus*5)/5:.2:sim_on_bezpar.tus(end));
set(gca, "ytick", 0:10:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel("Čas");
%ylabel("");
text(t_start*1e6+.1, sim_on_bezpar.gce(1)*2.5+2, '$g_{CE}$', 'interpreter', 'latex');
text(t_start*1e6+.1, sim_on_bezpar.vc(1)/10+2, '$u_{CE}$');
text(t_start*1e6+.1, sim_on_bezpar.ic(1)+2, '$i_{C}$', 'interpreter', 'latex');
system("mkdir plots");
print('-depslatex', '-S350,200', str_outfile_on); 
%print('-deps', '-S350,200', "/tmp/aa.eps"); 
