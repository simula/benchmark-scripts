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



clt1="n055"
clt2="n058"
clt3="n057"
clt4="n053"

srv1="n056"
#srv2="n059"


#sudo ssh $srv1 "pidof ib_write_bw | xargs sudo kill -9"
#sudo ssh $srv1 "pidof ib_write_bw | xargs sudo kill -9"
#sudo ssh $srv1 "pidof ib_write_bw | xargs sudo kill -9"
#sudo ssh $clt1 "pidof ib_write_bw | xargs sudo kill -9"
#sudo ssh $clt2 "pidof ib_write_bw | xargs sudo kill -9"
#sudo ssh $clt3 "pidof ib_write_bw | xargs sudo kill -9"
#sudo ssh $clt4 "pidof ib_write_bw | xargs sudo kill -9"


sudo ssh $srv1 "ib_write_bw -d mlx5_1 -p 21  > /dev/null" &
echo "hola 1"
sudo ssh $srv1 "ib_write_bw -d mlx5_1 -p 24  > /dev/null" &
echo "hola 2"
sudo ssh $srv1 "ib_write_bw -d mlx5_1  > /dev/null" &
echo "hola 3"
sudo ssh $srv1 "ib_write_bw -d mlx5_1 -p 17  > /dev/null" &
echo "hola 4"



#Clear routing notifications port counters
sudo ibdiagnet -r --r_opt=crnc > /dev/null
sudo ibdiagnet --clear_congestion_counters > /dev/null


sleep 5


sudo ibqueryerrors -K
perfquery -R 6 19
perfquery -R 6 20 
perfquery -R 6 22 
perfquery -R 11 19  
perfquery -R 11 20  
perfquery -R 11 21
perfquery -R 7 21  
perfquery -R 7 22  


#Init servers
#sudo ssh $srv1 "ib_write_bw -d mlx5_1 " &
#sudo ssh $srv2 "ib_write_bw -d mlx5_1 " &
#sudo ssh $srv2 "ib_write_bw -d mlx5_1 -p 21 " &
 
#Init clients
echo ssh $clt1 "ib_write_bw -d mlx5_1 $srv1 -F -n $1 $rate"
sudo ssh $clt1 "/home/jorocgon/perftestRepo/compile/ib_write_bw -d mlx5_1 $srv1 -F -n $1 $rate >       /home/jorocgon/paper2CC/FairFiveScenario_a_$rtng\_$2.txt" &
sudo ssh $clt2 "/home/jorocgon/perftestRepo/compile/ib_write_bw -d mlx5_1 $srv1 -F -n $1 $rate -p 21 > /home/jorocgon/paper2CC/FairFiveScenario_b_$rtng\_$2.txt" &
sudo ssh $clt3 "/home/jorocgon/perftestRepo/compile/ib_write_bw -d mlx5_1 $srv1 -F -n $1 $rate -p 24 > /home/jorocgon/paper2CC/FairFiveScenario_c_$rtng\_$2.txt" &
sudo ssh $clt4 "/home/jorocgon/perftestRepo/compile/ib_write_bw -d mlx5_1 $srv1 -F -n $1 $rate -p 17 > /home/jorocgon/paper2CC/FairFiveScenario_d_$rtng\_$2.txt" &



#Wait processes in background
wait


#Collect data
sudo ibdiagnet -r --r_opt=drnc > /dev/null
sudo ibdiagnet --congestion_counters > /dev/null

cp /var/tmp/ibdiagnet2/ibdiagnet2.rnc ./FairFiveScenario_RN_$rtng\_$2.txt
cp /var/tmp/ibdiagnet2/ibdiagnet2.db_csv ./FairFiveScenario_CCN_$rtng\_$2.txt


perfquery -x 6 19  > pent1.txt
perfquery -x 6 20  > pent2.txt
perfquery -x 6 22  > pent3.txt
perfquery -x 11 19 > pent4.txt
perfquery -x 11 20 > pent5.txt
perfquery -x 11 21 > pent6.txt
perfquery -x 7 21  > pent7.txt
perfquery -x 7 22  > pent8.txt

cat pent1.txt  | grep "PortRcvData" > pen1.txt
cat pent1.txt  | grep "PortRcvPkts" > pen1P.txt
cat pent2.txt  | grep "PortRcvData" > pen2.txt
cat pent2.txt  | grep "PortRcvPkts" > pen2P.txt
cat pent3.txt  | grep "PortRcvData"  > pen3.txt
cat pent3.txt  | grep "PortRcvPkts"  > pen3P.txt

cat pent4.txt  | grep "PortRcvData"  > pen4.txt
cat pent4.txt  | grep "PortRcvPkts"  > pen4P.txt
cat pent5.txt  | grep "PortRcvData" > pen5.txt
cat pent5.txt  | grep "PortRcvPkts" > pen5P.txt
cat pent6.txt  | grep "PortRcvData" > pen6.txt
cat pent6.txt  | grep "PortRcvPkts" > pen6P.txt


cat pent7.txt  | grep "PortRcvData" > pen7.txt
cat pent7.txt  | grep "PortRcvPkts" > pen7P.txt

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


echo "scale=10; $val1/164840000000" | bc >  DataFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val2/164840000000" | bc >> DataFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val3/164840000000" | bc >> DataFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val4/164840000000" | bc >> DataFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val5/164840000000" | bc >> DataFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val6/164840000000" | bc >> DataFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val7/164840000000" | bc >> DataFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val8/164840000000" | bc >> DataFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val9/164840000000" | bc >> DataFairFiveScenario$rtng\_$2.txt


echo "scale=10; $val1P/160000000" | bc >  PktsFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val2P/160000000" | bc >> PktsFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val3P/160000000" | bc >> PktsFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val4P/160000000" | bc >> PktsFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val5P/160000000" | bc >> PktsFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val6P/160000000" | bc >> PktsFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val7P/160000000" | bc >> PktsFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val8P/160000000" | bc >> PktsFairFiveScenario$rtng\_$2.txt
echo "scale=10; $val9P/160000000" | bc >> PktsFairFiveScenario$rtng\_$2.txt


awk 'NR > 19 { print }' < FairFiveScenario_a_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > FairFiveScenario_a_$rtng\_$2.txt

awk 'NR > 19 { print }' < FairFiveScenario_b_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > FairFiveScenario_b_$rtng\_$2.txt

awk 'NR > 19 { print }' < FairFiveScenario_c_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > FairFiveScenario_c_$rtng\_$2.txt

awk 'NR > 19 { print }' < FairFiveScenario_d_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > FairFiveScenario_d_$rtng\_$2.txt




echo "All done! "





