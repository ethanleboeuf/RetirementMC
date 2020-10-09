using Plots

function retirementScatter(n, retirementYears, meanYear, birthYear)

    scatter(1:n, retirementYears .- birthYear, label="", legend = :outertopright)
    plot!(1:n, (meanYear .-birthYear) * ones(n), color=:red, label="Mean Retirement Age", lw=3)
    plot!(1:n, (meanYear .-birthYear + 3 * stdYear) * ones(n), color=:blue, label="Mean + 3 sigma", lw=3)
    plot!(1:n, (meanYear .-birthYear - 3 * stdYear) * ones(n), color=:blue, label="Mean - 3 sigma", lw=3)
    xlabel!("Run #")
    ylabel!("Retirement Age")
    title!("Retirement Age")

end

function portfolioValue(n, pData::processedData, startYear)
    retirementAges = pData.retirementYears
    hist = pData.valueHistory
    p=plot(startYear : retirementAges[1] + 1, hist[1], legend=false)
    for i = 2 : n
        plot!(p, startYear : retirementAges[i] + 1, hist[i], color=:blue)
    end
    vline!(p, [mean(retirementAges)], lw=3, color=:red)
    meanRetirement = ceil(mean(pData.retirementYears))
    numYears = Integer(meanRetirement - startYear + 1)
    means = pData.meanByYear[1:numYears]
    meansP3sig = means + pData.stdByYear[1:numYears] * 3
    meansM3Sig = means - pData.stdByYear[1:numYears] * 3

    plot!(p, startYear : startYear + numYears-1,  means, lw=3, color=:purple)
    plot!(p, startYear : startYear + numYears-1,  means, ribbon=(pData.stdByYear[1:numYears] * 3,pData.stdByYear[1:numYears] * 3), lw=3, color=:purple)
    # plot!(p, startYear : startYear + numYears-1,  meansM3Sig, lw=3, color=:purple)
    display(p)
end