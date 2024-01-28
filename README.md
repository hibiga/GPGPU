# Exercice 1: Utilisation de CUDA Streams pour l'Addition de Vecteurs

Objectif : Se familiariser avec l'utilisation de l'API de streaming CUDA en réimplémentant le laboratoire d'addition de vecteurs pour utiliser les streams CUDA.

## Instructions :
1. Remplacer l'allocation de mémoire hôte par calloc par une allocation de mémoire hôte épinglée.
2. Créer des tableaux de pointeurs pour les allocations de mémoire du périphérique et un tableau de cudaStream_t pour les streams. Utiliser STREAM_NB=4 streams au début.
3. Créer les streams en utilisant la fonction cudaStreamCreate.
4. Allouer la mémoire du périphérique pour chaque tampon dans chaque stream.
5. Diviser les calculs dans une boucle sur STREAM_NB*STREAM_SIZE éléments. Chaque séquence de TransferA, TransferB, le noyau d'addition et TransferC traite STREAM_NB*STREAM_SIZE éléments.
   
*Indications :* Utiliser deux variables pour l'indice de départ et la longueur du bloc actuel d'éléments. Assurer que tous les accès mémoire sont dans les limites des tableaux.

# Exercice 2: Optimisation du Noyau de Flou avec Streams et Mémoire Épinglée

Objectifs :
1. Profiler le code du chapitre 3 avec un noyau de convolution utilisant une moyenne des pixels voisins 7 × 7 (au lieu de 3 × 3 dans le chapitre 3) sur une image 4k.
2. Adapter l'algorithme pour traiter l'image entière avec des streams et une mémoire épinglée. Expliquer la stratégie.
3. Profiler la nouvelle version et rapporter le temps d'exécution total du début de la première copie à la fin de la dernière copie. Comparer avec la version initiale.

*Indications :* Commencer par chevaucher la copie des résultats vers l'hôte et l'exécution du noyau.
