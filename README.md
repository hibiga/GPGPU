# GPGPU

## Fichiers
Voir dans branches pour les différents exos dépendants des chapitres que l'on voyait en cours.

### Compiler fichier C : 

gcc example.c


blockIdx.x : id du block 

blockDim.x : dimension du block (nombre de processus) 

threadIdx.x : id du processus


## CUDA
### Compiler fichier: 

nvcc example.c -o nom_du_programme_compiler

++ -Xcompiler -rdynamic -lineinfo -g -G


nvcc compile le programme avec gcc (Compilateur C classique) et les parties (mykernel avec compilateur Cuda)


### Voir erreur (gpu exécute même si y a des erreurs) : 

cuda-memcheck ./example2_compile

### avoir kernel execution time : 

nsys profile --stats=true -t cuda ./1-vectorAdd 1000.

vu détaillé : nsys stats --report=gputrace report1.sqlite


### Make: 

make

./<fichier>


### Profilage/Occupation CUDA : 

nsys profile -t cuda ./leprogramme

nsys-ui


## OpenACC
### Compile OpenACC : 

nvc++ -acc=gpu -Minfo=accel 0-example-openacc.c matmul_utils.cxx


→ vector(x) : block de taille x 

→ copyout : copie du gpu vers cpu (device to host)


### Profilage/Occupation: 

nsys profile -t openacc ./leprogramme

nsys-ui

Exécution fichier .out

Executer fichier :

./nom_du_programme_compiler

(si nom par défaut) : ./a.out


## Profiler
### profilage : 

nsys profile -t cuda ./leprogramme

Ensuite il faut ouvrir le fichier qui a été généré dans le logiciel 

nsys-ui

Zoomer sur le temps de CUDA : mettre curseur pour mieux voir le temps d'exécution


### Profilage/Occupation OpenACC : 
![Screenshot](Capture1.png)
– si veut faire profilage (détail intérieur des kernels), faut remplir les infos dans 1er partie 

cliquer sur occupancy calculator : 

- faut renseigner le premier cadre tout en haut : 
![Screenshot](Capture2.png)

- Aide pour remplir ce tableau :
![Screenshot](Capture3.png)
32 registres et 512 bytes de mémoire partagée 

Tables : peut voir si occupe bien toutes les ressources ou non 

Graphs : des 3 paramètres (visualiser thread par block, registre et mémoire partagée) 

ATTENTION : occupation à 100% ne veut pas dire meilleure performance (tuile plus petite, plus de wrap disponible [des wraps peuvent faire des calculs pendant que certains attendent] : tourne plus vite) → trouver compromis entre perfo et occupation 
