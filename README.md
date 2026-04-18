# Analyse Stratégique du Jeu Split or Steal 🎮

Projet académique réalisé dans le cadre du BUT Science des Données
à l'IUT d'Aurillac – Université de Clermont Auvergne.

## Description

Modélisation et simulation de stratégies dans une variante du jeu
**Split or Steal**, inspirée de la théorie des jeux et du tournoi
de Robert Axelrod.

Chaque stratégie (bot) est confrontée à toutes les autres dans un
format Round Robin sur **1000 parties de 10 tours**, avec une mise
d'1€ par tour et un budget initial de 10€.

## Stratégies implémentées

- **Gentille** – coopère systématiquement
- **Méchante** – trahit systématiquement
- **Lunatique** – choix aléatoire
- **Donnant/Donnant** – imite le dernier choix adverse
- **Rancunière** – coopère jusqu'à la première trahison
- **Sondeur** – teste occasionnellement l'adversaire
- **Majorité Mou / Dur** – adapte selon le comportement majoritaire

## Résultats

La stratégie **Donnant/Donnant** obtient le meilleur score global (1.00),
confirmant les conclusions du tournoi d'Axelrod : la réciprocité et
l'adaptabilité dominent dans les interactions répétées.

## Analyses réalisées

- Tournoi Round Robin entre toutes les stratégies
- Calcul de scores pondérés (gain, coopération, robustesse, flexibilité)
- Matrice des gains et équilibre de Nash
- Corrélation entre taux de coopération et gains moyens
- Visualisation des résultats (barplots, graphiques de régression)

## Technologies

![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)

- Langage : **R**
- Visualisation : **ggplot2**
- Simulation : **Round Robin, 1000 itérations**

Encadrant : Paul Marie GROLLEMUND
