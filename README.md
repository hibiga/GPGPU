# Premier exercice:

Objectif: Implémenter un noyau de multiplication de matrices denses de base. Il s'agit de la première version d'une série d'optimisations à venir (voir les exercices suivants). Le programme calcule : C = AB où A, B et C sont des matrices rectangulaires générales.

## Instructions:

Modifier le code fourni pour effectuer les opérations suivantes :

- Allocation de la mémoire du périphérique
- Copie de la mémoire hôte sur le périphérique
- Initialisation des dimensions du bloc de threads et du réseau de threads
- Appel du noyau CUDA
- Copie des résultats du périphérique vers l'hôte
- Désallocation de la mémoire du périphérique
- Le programme ne nécessite que les dimensions de la matrice A et le nombre de colonnes de la matrice B. Ces paramètres sont lus à partir des arguments du programme.

Votre programme doit fonctionner avec des matrices rectangulaires de n'importe quelle taille.

# Deuxième exercice:

Objectif: Implémenter un noyau de multiplication de matrices denses de base avec un algorithme en tuiles utilisant la mémoire partagée du périphérique.

## Instructions:

Créer une deuxième version de votre programme à partir de l'exercice 1 et l'ajuster pour effectuer un algorithme en tuiles avec mémoire partagée.

Dans cet exercice, nous utilisons une taille de tuile de 8x8. Pour simplifier, nous nous concentrons sur des matrices carrées de taille égale à un multiple de 8 (taille de tuile).

Une fois que le programme est correct, produire une version finale qui prend en charge les matrices carrées de n'importe quelle taille.
