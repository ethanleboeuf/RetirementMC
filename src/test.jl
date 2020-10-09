using Random, Distributions, Plots

include("financialFunctions.jl")
include("MCFunctions.jl")
d = Normal(0.09, 0.09)
n = 1000
startYear = 2030
endYear = 2060
x = portfolio(0, startYear, 100000, 19500, d, [], [])
y = Vector{portfolio}(undef, 0)
for i = 1 : n
    push!(y, portfolio(i, startYear, 100000, 19500, d, [], []))
    futureValue(y[i], endYear)

end
fvalues, fhist = processPortfolios(y)
p = plot(startYear:endYear+1, fhist[1], formatter=identity, legend=false)
for i = 2:n
    plot!(p, startYear:endYear+1, fhist[i], linecolor=:blue)
end
plot!(p, startYear:endYear+1, mean(fhist), lw=3)
display(p)
# s = scatter(1:n, fvalues)
# display(s)