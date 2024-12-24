# Définition des stratégies
gentille <- function(history_self, history_opponent) {
  # Toujours coopérer
  return("Split")
}

mechante <- function(history_self, history_opponent) {
  # Toujours trahir
  return("Steal")
}

lunatique <- function(history_self, history_opponent) {
  # Choisir aléatoirement entre Split et Steal
  return(sample(c("Split", "Steal"), 1))
}

donnant_donnant <- function(history_self, history_opponent) {
  # Coopérer au premier tour, puis imiter l'adversaire
  if (length(history_opponent) == 0) {
    return("Split")
  }
  return(tail(history_opponent, 1))
}

rancuniere <- function(history_self, history_opponent) {
  # Coopérer jusqu'à la première trahison, puis toujours trahir
  if ("Steal" %in% history_opponent) {
    return("Steal")
  }
  return("Split")
}

majorite_mou <- function(history_self, history_opponent) {
  # Coopérer si l'adversaire a majoritairement coopéré, sinon trahir
  if (length(history_opponent) == 0) {
    return("Split")
  }
  if (sum(history_opponent == "Split") > sum(history_opponent == "Steal")) {
    return("Split")
  } else {
    return("Steal")
  }
}

majorite_dur <- function(history_self, history_opponent) {
  # Trahir si l'adversaire a majoritairement trahi, sinon coopérer
  if (length(history_opponent) == 0) {
    return("Steal")
  }
  if (sum(history_opponent == "Steal") > sum(history_opponent == "Split")) {
    return("Steal")
  } else {
    return("Split")
  }
}

sondeur <- function(history_self, history_opponent) {
  # Trahir occasionnellement pour tester l'adversaire
  if (length(history_self) %% 3 == 0) {
    return("Steal")
  }
  return("Split")
}

# Simulation d'un jeu entre deux stratégies
simulate_game <- function(strategy1, strategy2, rounds = 10, initial_money = 10) {
  money1 <- initial_money
  money2 <- initial_money
  
  history1 <- character(0)  # Historique des choix du joueur 1
  history2 <- character(0)  # Historique des choix du joueur 2
  
  for (i in 1:rounds) {
    choice1 <- strategy1(history1, history2)
    choice2 <- strategy2(history2, history1)
    
    history1 <- c(history1, choice1)
    history2 <- c(history2, choice2)
    
    # Calcul des gains
    if (choice1 == "Split" && choice2 == "Split") {
      # Les joueurs récupèrent leur mise
      next
    } else if (choice1 == "Split" && choice2 == "Steal") {
      money2 <- money2 + 1
      money1 <- money1 - 1
    } else if (choice1 == "Steal" && choice2 == "Split") {
      money1 <- money1 + 1
      money2 <- money2 - 1
    } else if (choice1 == "Steal" && choice2 == "Steal") {
      money1 <- money1 - 1
      money2 <- money2 - 1
    }
  }
  
  return(list(money1 = money1, money2 = money2, history1 = history1, history2 = history2))
}

# Définition des stratégies
strategies <- list(
  "Gentille" = gentille,
  "Méchante" = mechante,
  "Lunatique" = lunatique,
  "Donnant/Donnant" = donnant_donnant,
  "Rancunière" = rancuniere,
  "Majorité Mou" = majorite_mou,
  "Majorité Dur" = majorite_dur,
  "Sondeur" = sondeur
)

# Simulation du tournoi
results <- data.frame(Stratégie1 = character(),
                      Stratégie2 = character(),
                      Gain1 = numeric(),
                      Gain2 = numeric())

for (strat1_name in names(strategies)) {
  for (strat2_name in names(strategies)) {
    result <- simulate_game(strategies[[strat1_name]], strategies[[strat2_name]])
    results <- rbind(results, data.frame(
      Stratégie1 = strat1_name,
      Stratégie2 = strat2_name,
      Gain1 = result$money1,
      Gain2 = result$money2
    ))
  }
}

# Affichage des résultats
print(results)


