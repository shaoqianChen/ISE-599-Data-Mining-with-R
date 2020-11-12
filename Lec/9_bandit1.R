# bandit1.r

# install.packages("contextual")
library(contextual)

visits = 250
simulations = 500

# define 4 options give a reward 10% of time, and one option give a reward 90% of the time
prob_per_arm = c(0.1,0.1,0.1,0.1,0.9)
bandit = BasicBernoulliBandit$new(prob_per_arm)

# define policies (they differ by epsilon value)
agents = list(Agent$new(EpsilonGreedyPolicy$new(0.1),bandit,'Epsilon = 0.1'),
              Agent$new(EpsilonGreedyPolicy$new(0.2),bandit,'Epsilon = 0.2'),
              Agent$new(EpsilonGreedyPolicy$new(0.3),bandit,'Epsilon = 0.3'),
              Agent$new(EpsilonGreedyPolicy$new(0.4),bandit,'Epsilon = 0.4'),
              Agent$new(EpsilonGreedyPolicy$new(0.5),bandit,'Epsilon = 0.5'))
simulation = Simulator$new(agents,visits,simulations)
history = simulation$run()

# probability of selecting the best design (arm) 
# fraction of times the algorithm chooses best design
plot(history,type = 'optimal',legend_position='bottomright', ylim = c(0,1))
#
# increasing curve means the algorithm is learning
#
# average reward at each visit
plot(history,type = 'average',regret = F, legend_position='bottomright', ylim = c(0,1))
#
# average reward up to visit t
plot(history,type = 'cumulative',regret =F)
# fix legend overlay
plot(history,type = 'cumulative',regret =F,ylim = c(0,300))
#













