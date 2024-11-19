set datafile separator " "
set terminal postscript enhanced eps color 15
set output "New-adap2LCC200.eps"
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
plot "NewScenario_a_adap2LCC_200.txt" every 1 using ($1):($2) title 'LID 37 to LID 4' with linespoint lw 4 linecolor rgb "black", "NewScenario_b_adap2LCC_200.txt" every 2 using ($1):($2) title 'LID 1 to LID 4' with linespoint lw 4 linecolor rgb "red", "NewScenario_c_adap2LCC_200.txt" every 5 using ($1):($2) title 'LID 39 to LID 28' with linespoint lw 4 linecolor rgb "orange"
