#!/bin/bash
#SBATCH -p rome16q # partition (queue)
#SBATCH --ntasks-per-node=1 # number of nodes
#SBATCH --ntasks=7  # number of cores
#SBATCH --hint=nomultithread
#SBATCH --cpus-per-task=16
#	#SBATCH -w, --nodelist=n051,n058
#SBATCH -w, --nodelist=n049,n050,n051,n053,n056,n058,n059
#SBATCH -t 0-4:00 # time (D-HH:MM)
#       #SBATCH --exclusive                    
#SBATCH -o /home/jorocgon/output/rome16q/slurm.%N.%j.out # STDOUT
#SBATCH -e /home/jorocgon/output/rome16q/slurm.%N.%j.err # STDERR
#	#SBATCH --constraint=IB
#	#SBATCH --reservation=jorocgon_49

ulimit -s 10240

mkdir ~/bin/output/rome16q

module purge
module load slurm/21.08.8
module load gcc/11.2.0
module load openblas/dynamic/0.3.17
module load openmpi/gcc/64/4.1.4

export OMPI_MCA_opal_common_ucx_opal_mem_hooks=1
export OMPI_MCA_opal_warn_on_missing_libcuda=0
export OMPI_MCA_pml_ucx_verbose=100

export OMPI_MCA_btl_openib_warn_no_device_params_found=1
export OMPI_MCA_btl_openib_if_include=mlx5_1:1
# export OMPI_MCA_btl=self,openib
# export OMPI_MCA_btl_tcp_if_include=ib2   # Not working together with _exclude
# export OMPI_MCA_btl_tcp_if_exclude=lo,dis0,eno1,eno2

echo "HPCC  "
echo "mpirun -np $SLURM_NTASKS /home/jorocgon/bin/hpcc"

for i in {1..10}
do
	srun /home/jorocgon/hpcc/hpcc-1.5.0/hpcc
        #mpirun -n 7 -N 16 --mca orte_base_help_aggregate 0 --allow-run-as-root -mca pml ucx -x UCX_NET_DEVICES=mlx5_1:1 --hostfile /home/jorocgon/hpcc/hpcc-1.5.0/HFT1B.txt -x HCOLL_RCACHE=^ucs /home/jorocgon/hpcc/hpcc-1.5.0/hpcc
	mv /home/jorocgon/hpcc/hpcc-1.5.0/hpccoutf.txt "/home/jorocgon/bin/congestion_web_ARNOCTNOCCT1B/hpccoutf$i.txt"
done



