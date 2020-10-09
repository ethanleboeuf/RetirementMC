"""
    fv(rate::Real, nper::Integer, pv::Real, payment::Real; when="end")

Compute the Future Value of a present value (pv) given a number of periods (nper), a rate, payments, and when the payments occur.

"""
function fv(rate::Real, nper::Integer, pv::Real, payment::Real; when="end")
    onePlusRate = (1 + rate)

    if when == "beginning"
        temp = onePlusRate
    elseif when == "end"
        temp = 1
    else 
        temp = 1
    end

    fv_pv = pv * onePlusRate ^ nper
    fv_payment = payment * (onePlusRate ^ nper - 1) / rate * temp
    return round(fv_pv + fv_payment; digits=2)
end

"""
    stepFV(rate::Real, pv::Real, payment::Real; when="end")

Compute the future value of a present value (pv) one step in the future given rate, payment, and when the payment occurs
"""
function stepFV(rate::Real, pv::Real, payment::Real; when="end")

    if when == "beginning"
        temp = 0
    elseif when == "end"
        temp = rate
    end

    return pv * (1 + rate) + payment * (1 + rate - temp)

end
 



function presentValueAnnuities(nper::Integer, rate::Float64, annuities::Float64)

    return annuities * (1 - (1 / (1 + rate)^nper)) / rate
end