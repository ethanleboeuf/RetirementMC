include("financialFunctions.jl")


struct portfolio
    id::Integer
    startingYear::Integer
    startingValue::Float64
    payment::Float64
    rate::Real
end

function futureValue(p::portfolio, finalYear::Integer; when="end")
    periods = finalYear - p.startingYear + 1
    return fv(p.rate, periods, p.startingValue, p.payment; when)

end





