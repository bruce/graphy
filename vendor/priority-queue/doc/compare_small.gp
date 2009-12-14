set term png
set out 'compare_small.png'
set xlabel 'Number of nodes'
set ylabel 'Time in seconds (real)'
set yrange [0:60]
set xrange [0:8000]
set ytics 15
set grid ytics mytics
set mytics 3
#set logscale xy
set title 'Dijkstras Shortest Path Algorithm using different PQ Implementations'
plot \
  'results.csv' using 1:2 with lines title "CPriorityQueue (Graph of Degree: 4)",\
  'results.csv' using 1:4 with lines title "RubyPriorityQueue (Graph of Degree: 4)", \
  'results.csv' using 1:3 with lines title "PoorPriorityQueue (Graph of Degree: 4)"
