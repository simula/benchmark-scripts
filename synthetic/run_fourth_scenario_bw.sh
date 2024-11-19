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



clt1="n057"
clt2="n058"
clt3="n054"
clt4="n055"


srv1="n056"


sudo ssh $clt1 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt2 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt3 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt4 "pidof ib_write_bw | xargs sudo kill -9"


sudo ibqueryerrors --Ca mlx5_1 -K
sudo ibqueryerrors --Ca mlx5_1 -k

sudo perfquery -R --Ca mlx5_1 7 21
sudo perfquery -R --Ca mlx5_1 7 22
sudo perfquery -R --Ca mlx5_1 7 23
sudo perfquery -R --Ca mlx5_1 7 25


#Clear routing notifications port counters
rm /var/tmp/ibdiagnet2/ibdiagnet2.rnc
sudo ibdiagnet -r --r_opt=crnc > /dev/null
sudo ibdiagnet --clear_congestion_counters > /dev/null


sleep 5

 
#Init clients
echo ssh $clt1 "ib_write_bw -d mlx5_1 $srv1 -n $1 $rate"
sudo ssh $clt1 "/home/jorocgon/perftestRepo/compile/ib_write_bw -F -d mlx5_1 $srv1 -n $1 $rate >       /home/jorocgon/paper2CC/FourthScenario_a_$rtng\_$2.txt" &
sudo ssh $clt2 "/home/jorocgon/perftestRepo/compile/ib_write_bw -F -d mlx5_1 $srv1 -n $1 $rate -p 21 > /home/jorocgon/paper2CC/FourthScenario_b_$rtng\_$2.txt" &
sudo ssh $clt3 "/home/jorocgon/perftestRepo/compile/ib_write_bw -F -d mlx5_1 $srv1 -n $1 $rate -p 23 > /home/jorocgon/paper2CC/FourthScenario_c_$rtng\_$2.txt" &
sudo ssh $clt4 "/home/jorocgon/perftestRepo/compile/ib_write_bw -F -d mlx5_1 $srv1 -n $1 $rate -p 26 > /home/jorocgon/paper2CC/FourthScenario_d_$rtng\_$2.txt" &




#Wait processes in background
wait


#Collect data
sudo ibdiagnet -i mlx5_1 -r --r_opt=drnc > /dev/null
sudo ibdiagnet --congestion_counters > /dev/null

cp /var/tmp/ibdiagnet2/ibdiagnet2.rnc ./FourthScenario_RN_$rtng\_$2.txt
cp /var/tmp/ibdiagnet2/ibdiagnet2.db_csv ./FourthScenario_CCN_$rtng\_$2.txt


sudo perfquery -x --Ca mlx5_1  7 21 > pent1.txt
sudo perfquery -x --Ca mlx5_1  7 22 > pent2.txt
sudo perfquery -x --Ca mlx5_1  7 23 > pent3.txt
sudo perfquery -x --Ca mlx5_1  7 25 > pent4.txt




cat pent1.txt  | grep "PortRcvData"  > pen1.txt
cat pent1.txt  | grep "PortRcvPkts"  > pen1P.txt
cat pent2.txt  | grep "PortRcvData"  > pen2.txt
cat pent2.txt  | grep "PortRcvPkts"  > pen2P.txt
cat pent3.txt  | grep "PortRcvData"  > pen3.txt
cat pent3.txt  | grep "PortRcvPkts"  > pen3P.txt
cat pent4.txt  | grep "PortRcvData"  > pen4.txt
cat pent4.txt  | grep "PortRcvPkts"  > pen4P.txt




val1=$(cat pen1.txt | cut -c 34-)
val2=$(cat pen2.txt | cut -c 34-)
val3=$(cat pen3.txt | cut -c 34-)
val4=$(cat pen4.txt | cut -c 34-)


val1P=$(cat pen1P.txt | cut -c 34-)
val2P=$(cat pen2P.txt | cut -c 34-)
val3P=$(cat pen3P.txt | cut -c 34-)
val4P=$(cat pen4P.txt | cut -c 34-)


echo "scale=10; $val1/164840000000" | bc >  DataFourthScenario$rtng\_$2.txt
echo "scale=10; $val2/164840000000" | bc >> DataFourthScenario$rtng\_$2.txt
echo "scale=10; $val3/164840000000" | bc >> DataFourthScenario$rtng\_$2.txt
echo "scale=10; $val4/164840000000" | bc >> DataFourthScenario$rtng\_$2.txt


echo "scale=10; $val1P/160000000" | bc >  PktsFourthScenario$rtng\_$2.txt
echo "scale=10; $val2P/160000000" | bc >> PktsFourthScenario$rtng\_$2.txt
echo "scale=10; $val3P/160000000" | bc >> PktsFourthScenario$rtng\_$2.txt
echo "scale=10; $val4P/160000000" | bc >> PktsFourthScenario$rtng\_$2.txt


awk 'NR > 19 { print }' < FourthScenario_a_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > FourthScenario_a_$rtng\_$2.txt

awk 'NR > 19 { print }' < FourthScenario_b_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > FourthScenario_b_$rtng\_$2.txt

awk 'NR > 19 { print }' < FourthScenario_c_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > FourthScenario_c_$rtng\_$2.txt

awk 'NR > 19 { print }' < FourthScenario_d_$rtng\_$2.txt  > temp.txt
head -n -2 temp.txt > FourthScenario_d_$rtng\_$2.txt



echo "All done! "





