using Random, Distributions

include("portfolio.jl")

d = Normal(0.09, 0.15)

x = portfolio(0, 2020, 10000.5, 1000, rand(d))
print(futureValue(x, 2045))
