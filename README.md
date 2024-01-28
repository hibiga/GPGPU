But: Apprendre à jouer avec une image pour la mettreen nuance de gris, la flouter. 

https://drive.google.com/drive/folders/1g_LuE44L4sEuBkS7mArUrImy5kwIy8FU

# Exercice 1: Addition de vecteurs en CUDA avec différentes configurations de blocs de threads et de grilles :

L'objectif de cet exercice est de réaliser une addition de vecteurs en CUDA avec différentes configurations de blocs de threads et de grilles. Trois versions du programme sont demandées :

## Instructions : 
Utiliser un seul bloc de threads.
Utiliser un seul thread par bloc.
Utiliser plusieurs threads par bloc et plusieurs blocs.
Le programme doit être capable de gérer des vecteurs de taille variable sans nécessiter une recompilation. Les étapes comprennent l'allocation de mémoire sur l'hôte et le périphérique, l'initialisation des données, l'invocation du noyau CUDA, la vérification de la correction des résultats, et enfin, la libération de la mémoire du périphérique.

# Exercice 2: Conversion d'image RGB en niveaux de gris en CUDA :

Cet exercice vise à convertir une image RGB en niveaux de gris à l'aide de CUDA. Le programme doit suivre les étapes suivantes :

## Instructions : 
Allouer la mémoire du périphérique.
Copier la mémoire de l'hôte vers le périphérique.
Initialiser les dimensions des blocs de threads et de la grille du noyau.
Appeler le noyau CUDA.
Copier les résultats du périphérique vers l'hôte.
Libérer la mémoire du périphérique.
Le programme prend en entrée deux noms de fichiers d'image en tant qu'arguments du programme et doit être capable de traiter des images RGB de dimensions arbitraires.

# Exercice 3: Flou d'image en CUDA avec filtre de boîte 3x3 :

L'objectif de cet exercice est d'implémenter un flou d'image sur GPU en utilisant un filtre de boîte 3x3. Les étapes à suivre comprennent :

## Instructions : 

Allouer la mémoire du périphérique.
Copier la mémoire de l'hôte vers le périphérique.
Initialiser les dimensions des blocs de threads et de la grille du noyau.
Appeler le noyau CUDA.
Copier les résultats du périphérique vers l'hôte.
Libérer la mémoire du périphérique.
Le programme doit être capable de traiter des images en niveaux de gris ou RGB et appliquer le filtre de boîte 3x3 pour réaliser le flou.
