target="a.out"

results="results.txt"

TIMEFORMAT=%3R

start=1
stop=100000000
step=1000000

for i in $(seq $start $step $stop); do
    { time mpirun "$target" "$i" ; } 2>> "$results"
done
