#!/bin/bash

#FLOWS=('FairFirst' 'FairSecond' 'FairThird' 'FairFour' 'FairFive' 'First'  'Second' 'Third' 'CtreeFirst' 'CtreeSecond' 'CtreeThird' 'CtreeFour' 'JPDC' 'new_scenario_fair')
FLOWS=('FairFour' 'Third' 'CtreeFirst' 'CtreeThird'  'JPDC' 'new_scenario_fair')
ROUTING=(adapCC detCC adap det)
BWTH=('200')

for flows in "${FLOWS[@]}"
do
	for routing in "${ROUTING[@]}"
	do
		for bwth in "${BWTH[@]}"
		do
			echo "$flows-$routing$bwth.plt"
                        FILE_INI="$flows-$routing$bwth.plt"
			gnuplot $FILE_INI
			epstopdf $flows-$routing$bwth.eps
			mv $flows-$routing$bwth.pdf graphicsNew/
			rm $flows-$routing$bwth.eps
		done
	done
done
