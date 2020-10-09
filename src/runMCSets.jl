using Random, Distributions, Plots

include("MCFunctions.jl")
include("plottingFunctions.jl")
rateD = Normal(0.08, 0.08)
inflationD = 0.0225
n = 1000
birthYear = 1995
deathAge = 90

initialLumpSum = 15000.
payment = 19500.
yearlyExpensesAtRetirement = 70000.

MCSettings = MCSet(n, yearlyExpensesAtRetirement, initialLumpSum, inflationD, rateD, 2020, birthYear + deathAge, 0.06, payment)

ICs = generateMcIcs(MCSettings)
MCResults = runMCSets(MCSettings, ICs)

processedMCData = processPortfolios(MCResults)

meanYear = mean(processedMCData.retirementYears)
stdYear = std(processedMCData.retirementYears)

retirementScatter(n, processedMCData.retirementYears, meanYear, birthYear)
portfolioValue(n, processedData, 2020)

