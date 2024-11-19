#!/bin/bash
if [ "$#" -ne 2 ]; then
  echo "Usage:  #iterations rate_limit"
  echo "Example: ./run_client_3flows_bw 1000000 2.5" 
  exit 1
fi

rtng="det"
rate="--rate_limit $2"
num=$2
int=${num%.*}



if (( $int > 200)); then
  rate=""
fi



clt1="n058"
clt2="n059"
#clt3="n060"

srv1="n056"
srv2="n057"


#sudo ssh $srv1 "pidof ib_write_bw | xargs sudo kill -9"
#sudo ssh $srv1 "pidof ib_write_bw | xargs sudo kill -9"
#sudo ssh $srv1 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt1 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt2 "pidof ib_write_bw | xargs sudo kill -9"
#sudo ssh $clt3 "pidof ib_write_bw | xargs sudo kill -9"

#Clear routing notifications port counters
sudo ibdiagnet -r --r_opt=crnc > /dev/null
sudo ibdiagnet --clear_congestion_counters > /dev/null



sleep 5


sudo ibqueryerrors -K
perfquery -R 8 21
perfquery -R 8 22 
perfquery -R 7 21 
perfquery -R 7 22 
perfquery -R 1 1  
perfquery -R 2 1  
perfquery -R 3 1  
perfquery -R 4 1  


#Init servers
#sudo ssh $srv1 "ib_write_bw -d mlx5_1 " &
#sudo ssh $srv2 "ib_write_bw -d mlx5_1 " &
#sudo ssh $srv2 "ib_write_bw -d mlx5_1 -p 21 " &

#Init clients
echo ssh $clt1 "ib_write_bw -d mlx5_1 $srv1 -F -n $1 $rate"
sudo ssh $clt1 "/home/jorocgon/perftest-master/ib_write_bw -d mlx5_1 $srv1 -F -n $1 $rate > /home/jorocgon/paper2CC/First2FScenario_a_$rtng\_$2.txt" &
sudo ssh $clt2 "/home/jorocgon/perftest-master/ib_write_bw -d mlx5_1 $srv2 -F -n $1 $rate > /home/jorocgon/paper2CC/First2FScenario_b_$rtng\_$2.txt" &
#sudo ssh $clt3 "/home/jorocgon/perftest-master/ib_write_bw -d mlx5_1 $srv1 -F -n $1 $rate -p 23 > /home/jorocgon/paper2CC/First2FScenario_c_$rtng\_$2.txt" &


#Wait processes in background
wait


#Collect data
sudo ibdiagnet -r --r_opt=drnc > /dev/null
sudo ibdiagnet --congestion_counters > /dev/null

cp /var/tmp/ibdiagnet2/ibdiagnet2.rnc ./First2FScenario_RN_$rtng\_$2.txt
cp /var/tmp/ibdiagnet2/ibdiagnet2.db_csv ./First2FScenario_CCN_$rtng\_$2.txt


perfquery -x 8 21 > pent1.txt
perfquery -x 8 22 > pent2.txt
perfquery -x 7 21 > pent3.txt
perfquery -x 7 22 > pent4.txt
perfquery -x 1 1  > pent5.txt
perfquery -x 2 1  > pent6.txt
perfquery -x 3 1  > pent7.txt
perfquery -x 4 1  > pent8.txt

cat pent1.txt  | grep "PortXmitData" > pen1.txt
cat pent1.txt  | grep "PortXmitPkts" > pen1P.txt
cat pent2.txt  | grep "PortXmitData" > pen2.txt
cat pent2.txt  | grep "PortXmitPkts" > pen2P.txt

cat pent3.txt  | grep "PortRcvData"  > pen3.txt
cat pent3.txt  | grep "PortRcvPkts"  > pen3P.txt
cat pent4.txt  | grep "PortRcvData"  > pen4.txt
cat pent4.txt  | grep "PortRcvPkts"  > pen4P.txt

cat pent5.txt  | grep "PortXmitData" > pen5.txt
cat pent5.txt  | grep "PortXmitPkts" > pen5P.txt
cat pent6.txt  | grep "PortXmitData" > pen6.txt
cat pent6.txt  | grep "PortXmitPkts" > pen6P.txt
cat pent7.txt  | grep "PortXmitData" > pen7.txt
cat pent7.txt  | grep "PortXmitPkts" > pen7P.txt

cat pent8.txt  | grep "PortRcvData"  > pen8.txt
cat pent8.txt  | grep "PortRcvPkts"  > pen8P.txt



val1=$(cat pen1.txt | cut -c 34-)
val2=$(cat pen2.txt | cut -c 34-)
val3=$(cat pen3.txt | cut -c 34-)
val4=$(cat pen4.txt | cut -c 34-)
val5=$(cat pen5.txt | cut -c 34-)
val6=$(cat pen6.txt | cut -c 34-)
val7=$(cat pen7.txt | cut -c 34-)
val8=$(cat pen8.txt | cut -c 34-)


val1P=$(cat pen1P.txt | cut -c 34-)
val2P=$(cat pen2P.txt | cut -c 34-)
val3P=$(cat pen3P.txt | cut -c 34-)
val4P=$(cat pen4P.txt | cut -c 34-)
val5P=$(cat pen5P.txt | cut -c 34-)
val6P=$(cat pen6P.txt | cut -c 34-)
val7P=$(cat pen7P.txt | cut -c 34-)
val8P=$(cat pen8P.txt | cut -c 34-)


echo "scale=10; $val1/164840000000" | bc >  DataFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val2/164840000000" | bc >> DataFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val3/164840000000" | bc >> DataFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val4/164840000000" | bc >> DataFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val5/164840000000" | bc >> DataFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val6/164840000000" | bc >> DataFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val7/164840000000" | bc >> DataFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val8/164840000000" | bc >> DataFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val9/164840000000" | bc >> DataFirst2FScenario$rtng\_$2.txt


echo "scale=10; $val1P/160000000" | bc >  PktsFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val2P/160000000" | bc >> PktsFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val3P/160000000" | bc >> PktsFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val4P/160000000" | bc >> PktsFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val5P/160000000" | bc >> PktsFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val6P/160000000" | bc >> PktsFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val7P/160000000" | bc >> PktsFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val8P/160000000" | bc >> PktsFirst2FScenario$rtng\_$2.txt
echo "scale=10; $val9P/160000000" | bc >> PktsFirst2FScenario$rtng\_$2.txt


awk 'NR > 19 { print }' < First2FScenario_a_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > First2FScenario_a_$rtng\_$2.txt

awk 'NR > 19 { print }' < First2FScenario_b_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > First2FScenario_b_$rtng\_$2.txt

#awk 'NR > 19 { print }' < First2FScenario_c_$rtng\_$2.txt  > temp.txt
#head -n -2 temp.txt > First2FScenario_c_$rtng\_$2.txt


#perfquery -x 6 21 | head -5
#perfquery -x 6 22 | head -5
echo "All done! "





