set term png
set out 'compare_big.png'
set xlabel 'Number of nodes'
set ylabel 'Time in seconds (real)'
set yrange [0:240]
set ytics 30
set grid ytics mytics
set mytics 2
#set logscale xy
set title 'Dijkstras Shortest Path Algorithm using different PQ Implementations'
plot \
  'results.csv' using 1:2 with lines title "CPriorityQueue (Graph of Degree: 4)",\
  'results.csv' using 1:4 with lines title "RubyPriorityQueue (Graph of Degree: 4)", \
  'results.csv' using 1:3 with lines title "PoorPriorityQueue (Graph of Degree: 4)"
