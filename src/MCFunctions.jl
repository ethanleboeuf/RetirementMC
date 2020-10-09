include("financialFunctions.jl")


struct MCSet
    nRuns::Integer
    yearlyExpense::Float64
    startingSum::Float64
    inflationAssump::Float64
    returnDist::Normal{Float64}
    startYear::Integer
    deathYear::Integer
    retirementReturnAssump::Float64
    payment::Float64
end

mutable struct mcData
    id::Integer
    startingValue::Float64
    payment::Float64
    rateDist::Normal{Float64}
    valueHist::Vector{Float64}
    rateHist::Vector{Float64}
    startingYear::Integer
    retirementYear::Integer
end

mutable struct processedData
    finalValues::Vector{Float64}
    valueHistory::Vector{Vector{Float64}}
    retirementYears::Vector{Float64}
    histByYear::Vector{Vector{Float64}}
    meanByYear::Vector{Float64}
    stdByYear::Vector{Float64}
end

function generateMcIcs(sett::MCSet)
    ICs = Vector{mcData}(undef, sett.nRuns)
    for i = 1 : sett.nRuns
        ICs[i] = mcData(i, sett.startingSum, sett.payment, sett.returnDist, [], [], sett.startYear, 0)
    end

    return ICs
end

function runMCSets(sett::MCSet, ps::Vector{mcData})
    for i = 1 : length(ps)
        calculateRetirementAge(sett, ps[i])
    end

    return ps
end

function calculateRetirementAge(sett::MCSet, p::mcData)
    currentYear = sett.startYear
    push!(p.valueHist, p.startingValue)

    while p.retirementYear == 0
        stepRetirementCalc(p, currentYear, sett)
        currentYear += 1
    end

    return p
end

function stepRetirementCalc(p::mcData, year::Integer, sett::MCSet)

    yearsRetired = sett.deathYear - year
    rate = rand(p.rateDist)
    realRate = (1 + sett.retirementReturnAssump) / (1 + sett.inflationAssump) - 1
    
    push!(p.rateHist, rate)

    push!(p.valueHist, p.valueHist[end] * (1 + rate) + p.payment)

    yearlyNeedAtRetirement = fv(sett.inflationAssump, year - sett.startYear, sett.yearlyExpense, 0)
    retirementNeeded = presentValueAnnuities(yearsRetired, realRate, yearlyNeedAtRetirement, )

    if p.valueHist[end] >= retirementNeeded || yearsRetired <= 0
        p.retirementYear = year
    end
end

function processPortfolios(ps::Vector{mcData})

    # finalValues = Vector{Float64}(undef, 0)
    # fullHist = Vector{Vector{Float64}}(undef, 0)
    # fullRetirementAge = Vector{Float64}(undef, 0)
    pOut = processedData([], [], [], [], [], [])
    for i = 1 : length(ps)
       push!(pOut.finalValues, ps[i].valueHist[end])
       push!(pOut.valueHistory, ps[i].valueHist)
       push!(pOut.retirementYears, ps[i].retirementYear)
    end

    pOut = returnStats(pOut)

    return pOut
end

function returnStats(data::processedData)
    fullHist = data.valueHistory
   
    for i = 1 : length(fullHist)
        
        for j = 1 : length(fullHist[i])
            if j > length(data.histByYear)
                push!(data.histByYear, [])
            end
            push!(data.histByYear[j], fullHist[i][j])
        end
    end
   
    for i = 1 : length(data.histByYear)
        push!(data.meanByYear, mean(data.histByYear[i]))
        push!(data.stdByYear, std(data.histByYear[i]))
    end
    return data
end

function futureValue(p::mcData, finalYear::Integer; when="end")
    periods = finalYear - p.startingYear + 1
    fv = p.startingValue
    push!(p.valueHist, p.startingValue)
    push!(p.rateHist, 0)
    for i = 1 : periods
        rate = rand(p.rateDist)
        fv = stepFV(rate, fv, p.payment)
        push!(p.valueHist, fv)
        push!(p.rateHist, rate)
    end
    return fv

end