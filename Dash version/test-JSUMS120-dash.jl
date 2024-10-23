using Revise
includet("JSUMS120-dash.jl")

#function functionplot 861

# f = (x^2+5*x+6)/(x+2)
# f = (x^2+5*x+6)/(x^2-9)
# f = (x^2+5*x+6)/(x^2-25)
# f = x^3
# f = 5*x
# f = 5
# f = (x+3)*(x+1)*(x-1)*(x-3)
# f = (x+3)/((x+1)*(x-1))*(x-3)
# f = (x+1)*(x-1)*(x-3)
# f = (x+1)/(x-1)
# f = (x+1)/((x-1)*(x+1))
f = (x+1)/(x^2-1)
# f = x/(x^2+2)
# f = 33/(x+7)^(2/5)
# f = (2*x^2-3*x)/(x^2+9)
# f = x^3+3*x^2+1
# f = exp(x)
# f = exp(x^2)
# f = sqrt(x)
# f = abs(x)
# f = abs(y)

# begin
#     test_fcns = [(x^2+5*x+6)/(x+2), (x^2+5*x+6)/(x^2-9), (x^2+5*x+6)/(x^2-25), x^3, 5x, 5, (x+3)*(x+1)*(x-1)*(x-3), (x+3)/((x+1)*(x-1))*(x-3), (x+1)*(x-1)*(x-3), (x+1)/(x-1), x/(x^2+2), 33/(x+7)^(2/5), (2*x^2-3*x)/(x^2+9), exp(x), exp(x^2), sqrt(x), abs(x)]
#     println("################## Start testing ##################")
#     for f in test_fcns[1:end]
#         println(f)
#         s = function_summary(f)
#         println("s = $s\n")
#     end
# end

a = function_summary(f)

criticalpoints(f)

functionplot(f, (-5,5))