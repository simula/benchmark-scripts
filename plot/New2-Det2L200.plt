set datafile separator " "
set terminal postscript enhanced eps color 15
set output "New2-det2LCC200.eps"
set pointsize 1.5
set key right bottom spacing 1.5
set xlabel "Time (seconds)"
set style line 100 lt 0.5 lc rgb "black" lw 4
set style line 101 lt 0.5 lc rgb "gray" lw 1
set grid ytics mytics ls 100, ls 101
set mytics 5
set ylabel "Flow Bandwith MBps" offset 2
set size 0.6,0.7
set yrange [0:26000]
set xrange [0:30]
plot "New2Scenario_a_det2LCC_200.txt" every 1 using ($1):($2) title 'LID 37 to LID 4' with linespoint lw 4 linecolor rgb "black", "New2Scenario_b_det2LCC_200.txt" every 3 using ($1):($2) title 'LID 1 to LID 4' with linespoint lw 4 linecolor rgb "red", "New2Scenario_c_det2LCC_200.txt" every 2 using ($1):($2) title 'LID 39 to LID 28' with linespoint lw 4 linecolor rgb "orange", "New2Scenario_d_det2LCC_200.txt" every 3 using ($1):($2) title 'LID 13 to LID 3' with linespoint lw 4 linecolor rgb "brown", "New2Scenario_e_det2LCC_200.txt" every 4 using ($1):($2) title 'LID 5 to LID 31' with linespoint lw 4 linecolor rgb "blue"
