#!/bin/bash

#clt1="n050"
clt2="n054"
clt3="n055"
clt4="n057"
clt5="n052"

srv1="n060"

#Kill clients
sudo ssh $clt2 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt3 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt4 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt5 "pidof ib_write_bw | xargs sudo kill -9"



sleep 3



#Init servers
sudo ssh $srv1 "ib_write_bw -d mlx5_1 -p 17  > /dev/null" &
sudo ssh $srv1 "ib_write_bw -d mlx5_1 -p 21  > /dev/null" &
sudo ssh $srv1 "ib_write_bw -d mlx5_1 -p 15  > /dev/null" &
sudo ssh $srv1 "ib_write_bw -d mlx5_1 -p 13  > /dev/null" &

sleep 3

#Init clients
sudo ssh $clt2 "ib_write_bw -d mlx5_1 $srv1 -F --run_infinitely -p 21" &
sudo ssh $clt3 "ib_write_bw -d mlx5_1 $srv1 -F --run_infinitely -p 17" &
sudo ssh $clt4 "ib_write_bw -d mlx5_1 $srv1 -F --run_infinitely -p 15" &
sudo ssh $clt5 "ib_write_bw -d mlx5_1 $srv1 -F --run_infinitely -p 13" &



#Wait processes in background
echo "Press 'q' to exit"

count=0

while : 
	do
	read -n 1 k <&1
	if [[ $k = q ]] ; then
		printf "\nQuitting from the program\n"
		break
	else
		((count=$count+1))
		printf "\nIterate for $count times\n"
		echo "Press 'q' to exit"
	fi
done

#Kill clients
sudo ssh $clt2 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt3 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt4 "pidof ib_write_bw | xargs sudo kill -9"
sudo ssh $clt5 "pidof ib_write_bw | xargs sudo kill -9"


echo "All done"




