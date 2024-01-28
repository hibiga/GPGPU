# Exercice 1 : Première utilisation d'OpenACC

Objectifs :
- Écrire une version simple du code vectorAdd en utilisant OpenACC.
- Écrire une deuxième version en utilisant les directives OpenACC avec des directives explicites pour le déplacement des données.

## Instructions :
- Écrire une version CPU du code vectorAdd à partir du Chapitre 3.
- Écrire une deuxième version en utilisant les directives OpenACC, en particulier les directives explicites de mouvement de données.

# Projet

Objectif : Optimiser le code de l'exercice précédent en utilisant OpenACC avec des tuiles pour améliorer le parallélisme et la gestion de la mémoire.

## Instructions :
1. Revoir le code OpenACC écrit dans le premier exercice.
2. Intégrer l'utilisation de tuiles dans le code OpenACC pour exploiter au mieux la hiérarchie de la mémoire et améliorer le parallélisme de données.
3. Utiliser les directives OpenACC appropriées pour décomposer le traitement en unités de tuiles (`gang`, `worker`, `vector`, etc.).
4. Expliquer comment l'utilisation de tuiles a été appliquée pour optimiser le code.
5. Mesurer et comparer les performances avant et après l'ajout des tuiles en utilisant des métriques telles que le temps d'exécution total et l'utilisation de la mémoire.

*Note :* L'utilisation de tuiles doit être justifiée par des gains de performances mesurables. Les tuiles doivent être adaptées à la taille des données et à la configuration matérielle pour maximiser l'efficacité du parallélisme.
