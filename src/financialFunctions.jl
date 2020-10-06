
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
