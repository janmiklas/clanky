addpath "../funkcie/"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EDITOVAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outfilename_off = "../../latex/obr/plots/bjt_porov_300V_150V_off.tex"
outfilename_on = "../../latex/obr/plots/bjt_porov_300V_150V_on.tex"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mer_300_10 = mer_300_10;
mer_150_10 = mer_150_10;

sim_off_300_10 = sim_off_300_10;
sim_on_300_10 = sim_on_300_10;
sim_off_150_10 = sim_off_150_10;
sim_on_150_10 = sim_on_150_10;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% turn off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tus300 = mer_300_10.tus-109.4;
tus150 = mer_150_10.tus-84.85+.17;

figure;
close;
h_off = figure%("papersize", [.1 .1]);
set(h_off, "position", [0  0 350 200]);
plot(tus300, [mer_300_10.vc/10, mer_300_10.ic*2.5], "k", tus150, [mer_150_10.vc/10, mer_150_10.ic*2.5], "k")
legend("boxoff");
grid;
xlim([.4 2.4]);
ylim([-0 40]);
set(gca, "xtick", 0:.2:3);
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div}$', 'interpreter', 'latex');
text(2, 33, '$u_{CE} = 300\un{V}$', 'interpreter', 'latex');
text(2, 18, '$u_{CE} = 150\,\mathrm{V}$', 'interpreter', 'latex');
text(.8, 28, '$i_{C} = 10\un{A}$', 'interpreter', 'latex');
system("mkdir plots");
print('-depslatex', '-S350,200', outfilename_off); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% turn on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tus300 = mer_300_10.tus-152.6;
tus150 = mer_150_10.tus-127.73;

figure;
close;
h_off = figure%("papersize", [.1 .1]);
set(h_off, "position", [0  0 350 200]);
plot(tus300, [mer_300_10.vc/10, mer_300_10.ic*2.5], "k", tus150, [mer_150_10.vc/10, mer_150_10.ic*2.5], "k")
legend("boxoff");
grid;
xlim([.4 2.4]);
ylim([-0 40]);
set(gca, "xtick", 0:.2:3);
set(gca, "ytick", 0:5:50);
set(gca, "xticklabel", "");
set(gca, "yticklabel", "");
xlabel('$200\un{ns/div}$', 'interpreter', 'latex');
ylabel('$50\un{V/div},\,\,\, 2\un{A/div}$', 'interpreter', 'latex');
text(.8, 33, '$u_{CE} = 300\un{V}$', 'interpreter', 'latex');
text(.8, 18, '$u_{CE} = 150\,\mathrm{V}$', 'interpreter', 'latex');
text(2, 28, '$i_{C} = 10\un{A}$', 'interpreter', 'latex');
system("mkdir plots");
print('-depslatex', '-S350,200', outfilename_on); 
