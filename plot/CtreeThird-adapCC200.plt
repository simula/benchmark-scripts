set datafile separator " "
set terminal postscript enhanced eps color 13
set output "CtreeThird-adapCC200.eps"
set title "CtreeThird-adapCC200"
set pointsize 1
set key right center spacing 1.5
set xlabel "Time (seconds)"
set style line 100 lt 0.5 lc rgb "black" lw 2
set style line 101 lt 0.5 lc rgb "gray" lw 1
set grid ytics mytics ls 100, ls 101
set mytics 5
set ylabel "Flow Bandwith MBps" offset 2
set size 0.6,0.7
set yrange [0:26000]
plot "CtreeThirdScenario_a_adapCC_200.txt" every 1 using ($1):($2) title '28 to 13' with linespoint lw 5 pointtype 5 linecolor rgb "black", "CtreeThirdScenario_b_adapCC_200.txt" every 1 using ($1):($2) title '5 to 4' with linespoint lw 5 pointtype 4 linecolor rgb "red", "CtreeThirdScenario_c_adapCC_200.txt" every 1 using ($1):($2) title '2 to 4' with linespoint lw 5 pointtype 3 linecolor rgb "orange"
