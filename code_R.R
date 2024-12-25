# Définition des stratégies
gentille <- function(history_self, history_opponent) { return("Split") }
mechante <- function(history_self, history_opponent) { return("Steal") }
lunatique <- function(history_self, history_opponent) { return(sample(c("Split", "Steal"), 1)) }
donnant_donnant <- function(history_self, history_opponent) { 
  if (length(history_opponent) == 0) return("Split")
  return(tail(history_opponent, 1))
}
rancuniere <- function(history_self, history_opponent) { 
  if ("Steal" %in% history_opponent) return("Steal")
  return("Split")
}
majorite_mou <- function(history_self, history_opponent) { 
  if (length(history_opponent) == 0) return("Split")
  if (sum(history_opponent == "Split") > sum(history_opponent == "Steal")) return("Split")
  return("Steal")
}
majorite_dur <- function(history_self, history_opponent) { 
  if (length(history_opponent) == 0) return("Steal")
  if (sum(history_opponent == "Steal") > sum(history_opponent == "Split")) return("Steal")
  return("Split")
}
sondeur <- function(history_self, history_opponent) { 
  if (length(history_self) %% 3 == 0) return("Steal")
  return("Split")
}

# Liste des stratégies
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

# Fonction de simulation d'un jeu
simulate_game <- function(strategy1, strategy2, rounds = 10, initial_money = 10) {
  money1 <- initial_money
  money2 <- initial_money
  history1 <- character(0)
  history2 <- character(0)
  
  for (i in 1:rounds) {
    choice1 <- strategy1(history1, history2)
    choice2 <- strategy2(history2, history1)
    history1 <- c(history1, choice1)
    history2 <- c(history2, choice2)
    
    if (choice1 == "Split" && choice2 == "Split") {
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
  
  # Retourner les montants finaux
  return(list(money1 = money1, money2 = money2))
}

# Simulation pour les montants restants
simulate_type_money <- function(strategies_list, n_simulations = 1000) {
  results <- data.frame(
    Stratégie1 = character(),
    Stratégie2 = character(),
    Argent1 = numeric(),
    Argent2 = numeric()
  )
  
  for (strat1_name in names(strategies_list)) {
    for (strat2_name in names(strategies_list)) {
      if (strat1_name != strat2_name) {
        argent1_total <- 0
        argent2_total <- 0
        
        for (i in 1:n_simulations) {
          game_result <- simulate_game(strategies_list[[strat1_name]], strategies_list[[strat2_name]])
          argent1_total <- argent1_total + game_result$money1
          argent2_total <- argent2_total + game_result$money2
        }
        
        # Ajouter les résultats
        results <- rbind(results, data.frame(
          Stratégie1 = strat1_name,
          Stratégie2 = strat2_name,
          Argent1 = argent1_total / n_simulations,
          Argent2 = argent2_total / n_simulations
        ))
      }
    }
  }
  
  return(results)
}

# Simulation pour toutes les stratégies
results_money <- simulate_type_money(strategies)

# Résumer les résultats
summarize_money_results <- function(results) {
  summary <- results %>%
    group_by(Stratégie1) %>%
    summarise(ArgentMoyen = mean(Argent1), .groups = "drop")
  
  # Ordonner par argent moyen décroissant
  summary <- summary[order(-summary$ArgentMoyen), ]
  return(summary)
}

summary_money <- summarize_money_results(results_money)

# Graphique des montants restants
library(ggplot2)

create_money_graph <- function(summary, title) {
  ggplot(summary, aes(x = reorder(Stratégie1, -ArgentMoyen), y = ArgentMoyen)) +
    geom_point(stat = "identity", fill = "steelblue") +  # Une seule couleur
    labs(
      title = title,
      x = "Stratégies",
      y = "Argent restant moyen"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.title = element_text(size = 14, face = "bold")
    )
}

# Générer le graphique
graph_money <- create_money_graph(summary_money, "Argent restant moyen des stratégies après 1000 matchs")
print(graph_money)
