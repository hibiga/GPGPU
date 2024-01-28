# Exercice : Produit scalaire efficace sur GPU avec réduction**

L'objectif de cet exercice est d'implémenter un produit scalaire efficace sur GPU. La définition du produit scalaire est la suivante :
\[ a \cdot b = \sum_{i=0}^{n} a_i \cdot b_i \] où \( a \) et \( b \) sont des vecteurs de longueur \( n \).

## Instructions :

1. **Version de base :**
   - Compléter le code fourni pour mettre en œuvre un noyau de réduction de base.
   - Commencer par calculer le produit scalaire pour \( n = 1024 \) éléments et 512 threads dans un seul bloc en utilisant la mappage naïf des threads.
   
2. **Version adaptative :**
   - Adapter le code pour gérer des vecteurs de n'importe quelle longueur en utilisant un nombre approprié de blocs.
   - Dans ce cas, le résultat du périphérique est un vecteur de longueur égale au nombre de blocs. La taille du bloc doit être le prochain multiple de 32 supérieur à \( n/2 \), avec un maximum de 1024.
   - Enforcer la taille du bloc à 1024 et \( n \) doit être supérieur à 2048. La réduction finale de l'opération est effectuée sur le CPU.

3. **Amélioration avec le noyau de réduction "meilleur" :**
   - Améliorer la deuxième version avec le noyau de réduction "meilleur" en utilisant un meilleur mappage des données et en réduisant la divergence.

L'idée générale est de paralléliser efficacement le calcul du produit scalaire sur le GPU, en exploitant les capacités de parallélisme massif offertes par les architectures CUDA. La première version est une implémentation de base, tandis que la deuxième et la troisième visent à améliorer les performances et à rendre le code plus générique pour des tailles de vecteurs variables.
