i=[4 6 8 10]
v300=[8.5 13 17 23]
v150=[8 12.5 18 23]

figure
plot(v300, i, "k.;Ud=300V;", v150, i, "ko;Ud=150V;");
grid;
xlim([0 30]);
ylim([0 15]);
xlabel("Uce (V)");
ylabel("IL (A)");
