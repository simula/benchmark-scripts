set datafile separator " "
set terminal postscript enhanced eps color 15
set output "Fourth-det2LCC200.eps"
set pointsize 1.5
set key right top spacing 1.5
set xlabel "Time (seconds)"
set style line 100 lt 0.5 lc rgb "black" lw 2
set style line 101 lt 0.5 lc rgb "gray" lw 1
set grid ytics mytics ls 100, ls 101
set mytics 5
set ylabel "Flow Bandwith MBps" offset 2
set size 0.6,0.7
set yrange [0:26000]
set xrange [0:30]
plot "FourthScenario_a_det2LCC_200.txt" every 1 using ($1):($2) title 'LID 5 to LID 4' with linespoint lw 4 linecolor rgb "black", "FourthScenario_b_det2LCC_200.txt" every 1 using ($1):($2) title 'LID 2 to LID 4' with linespoint lw 4 linecolor rgb "red", "FourthScenario_c_det2LCC_200.txt" every 3 using ($1):($2) title 'LID 37 to LID 4' with linespoint lw 4 linecolor rgb "orange", "FourthScenario_d_det2LCC_200.txt" every 3 using ($1):($2) title 'LID 13 to LID 4' with linespoint lw 4 linecolor rgb "brown" 
