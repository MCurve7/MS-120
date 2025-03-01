begin
	using Revise
	# using LaTeXStrings
	# import Term: tprintln
	# using Term.TermMarkdown
	# using Markdown
	includet("JSUMS120-vscode.jl")
end


begin
	# x = Sym("x")
	x = symbols("x", real = true)
	h = Sym("h")
	C = Sym("C")
	# x = symbols('x')
	# h = symbols("h")
	# C = symbols("C")
	∞ = oo
end

# Test functions #####################################
begin
	c(x) = 2
	cm(x) = -2
	d(x) = 2x
	f(x) = x^2
	g(x) = x/(x-1)
	g′ = diff(g(x))
	g′′ = diff(g′(x))
	p(x) = (x+2)*(x-1)*(x-3)
	r(x) = 1/(x+3)
	r1(x) = 1/(x-2)+1
	s(x) = sqrt(x)
	sdomain = "[0, ∞)"
	q(x) = (x-1.5)*(x-2.3)
	l(x) = log(x)
	ldomain = "(0, ∞)"
	t(x) = sin(x)
	u(x) = (x+1)/(x-1)
	e(x) = exp(x)
	a(x) = abs(x)
	re(x) = (x-1)^(2//3)
	rei(x) = 1/(x-1)^(2//3)
end

# Test ###################################################
(8)^(1//3)
(8)^(2//3)
(-8)^(1//3)
(-8)^(2//3)

(0.9)^(1//3)
(0.9)^(2//3)
(-0.9)^(1//3)
(-0.9)^(2//3)

# Test ###################################################
limittable(f, 3, rows = 10)
limittable(f(x), 3, rows = 10)
limittable(f, 3, rows = 10, dir="+")
limittable(f, 3, rows = 10, dir="-")
limittable(u, 2)
limittable(e, 1)
limittable(a, 1)
limittable(a, -1)



limittable(re, 1)
limittable(re, 2)

limittable(rei, 1)
limittable(rei, 0)

# Test ###################################################
limittable(f, oo, rows = 10)
limittable(f(x), oo, rows = 10)
limittable(f, -oo, rows = 10)
limittable(e, oo, rows = 10)
limittable(e, -oo, rows = 10)
limittable(a, oo, rows = 10)
limittable(a, -oo, rows = 10)

# Test ###################################################
lim(f, x, 3)
lim(f, x, oo)
lim(1+1/x, x, oo)
lim(sin, x, oo)
lim(e, x, oo)
lim(a, x, oo)
lim(a, x, -oo)

lim(re, x, 1)
lim(re, x, 2)
lim(rei,x, 1)
lim(rei,x, 0) # why complex????


lim(f(x), x, 3)
lim(f(x), x, oo)
lim(sin(x), x, oo) # TypeError("'sin' object is not callable")
lim(e(x), x, oo) # # TypeError("'exp' object is not callable")

# typeof(sin(x))
# typeof(sin)
# typeof(e(x))
# typeof(e)

# typeof(f)
# typeof(f(x))
# limit(f(x), x=> 2)

# Test ###################################################
criticalpoints(g(x))
criticalpoints(s(x))
criticalpoints(g′′(x))
criticalpoints(p(x))
criticalpoints(r(x))
criticalpoints(r1(x))
criticalpoints(e(x))

# ERROR
criticalpoints(a(x))


# criticalpoints(g)
# criticalpoints(s)
# criticalpoints(g′′)
# criticalpoints(p)
# criticalpoints(r)
# criticalpoints(r1)
# criticalpoints(e)

# # solve(abs(x))
# # criticalpoints(a(x))
# criticalpoints(a)

# Test ###################################################
getsign(f, 0)
getsign(s, 1)
getsign(e, 1)
getsign(a, 1)
# getsign(s, -1)
getsign(g, .5)
getsign(g′′, 3)

getsign(f(x), 0)
getsign(e(x), 0)
getsign(a(x), 0)
getsign(g(x), .5)
getsign(g′′(x), 3)

# Test ###################################################
domain_from_str("(-oo, oo)")
domain_from_str("(-∞, ∞)")
domain_from_str("(2, 5)")
domain_from_str("(2.0, 5)")














# Test ###################################################
convert_to_interval("(-2, 2π)") # Ask form on hiw to do this!
convert_to_interval("(-2, $(2π))") #<--
tpattern = r"\s*(\[|\()\s*(-?[\p{Any}|\d]*)\s*,\s*(-?[\p{Any}|\d]*)\s*(\]|\))\s*"
tre_matched = match(tpattern, "(-2, 2π)")
tre_matched[3]
if occursin("π", tre_matched[3])
	tre_split = split(tre_matched[3], "π")
end
tre_split[1]












# Test ###################################################
cp = convert.(Float64, sort(append!(criticalpoints(p(x))[1], criticalpoints(p(x))[2])))
getsigns_aux(p(x), "(-∞, ∞)", cp; xrange = (-4, 5))
getsigns_aux(p(x), "[-4, 5)", cp; xrange = missing)

# Test ###################################################
getsigns(p, [-2, 1, 3])
getsigns(s, [0]; domain = "[0, oo)")
getsigns(s, [0]; domain = "[0, ∞)")

# ERROR VVV
getsigns(g, criticalpoints(g(x))..., domain="(.1, ∞)")
getsigns(g′′, criticalpoints(g′′(x))...) # How to not need to splat!!!
getsigns(g′′, criticalpoints(g′′(x))) # How to not need to splat!!!
getsigns(s, criticalpoints(s(x)), domain="[0,∞)")
getsigns(g, criticalpoints(g(x)))
# ERROR ^^^

getsigns(p, ([1], [2]))

# ERROR VVV
getsigns(c, criticalpoints(c(x))) #ERROR constant function has no critical points
getsigns(d, criticalpoints(d(x)))
getsigns(e, criticalpoints(e(x))) #ERROR TypeError("'exp' object is not callable")
# ERROR ^^^

getsigns(p(x), [-2, 1, 3])
getsigns(s(x), [0]; domain = "[0, oo)")
getsigns(s(x), [0]; domain = "[0, ∞)")

# ERROR VVV
getsigns(g(x), criticalpoints(g(x))..., domain="(.1, ∞)")
getsigns(g′′(x), criticalpoints(g′′(x))...) # How to not need to splat!!!
getsigns(g′′(x), criticalpoints(g′′(x))) # How to not need to splat!!!
getsigns(s(x), criticalpoints(s(x)), domain="[0,∞)")
getsigns(g(x), criticalpoints(g(x)))
# ERROR ^^^

getsigns(p(x), ([1], [2]))

# ERROR VVV
getsigns(c(x), criticalpoints(c(x))) #ERROR constant function has no critical points
getsigns(d(x), criticalpoints(d(x)))
getsigns(e(x), criticalpoints(e(x))) #ERROR TypeError("'exp' object is not callable")
# ERROR ^^^

# Test ###################################################
signchart(c(x), label = "c")
dc = diff(c(x))
signchart(dc(x), label = "dc")

# Test ###################################################
signchart(cm(x), label = "cm")
dcm = diff(cm(x))
signchart(dcm(x), label = "dcm")

# Test ###################################################
signchart(d(x), label = "d")

signchart(re(x), label = "re")
signchart(rei(x), label = "rei")

rep = diff(re(x), x)
rep(2)
rep(0)
N(rep(0))
signchart(rep(x), label = "rep")

#ERROR
dp = diff(d(x))
signchart(dp(x), label = "dp")

signchart(p(x), xrange = (-4, 5))
signchart(p(x), domain = "[-4, 5)")






signchart(p(x), domain = "[-3, 2)") #shows value at 3 so need to remove 3 from values plotted on x-axis






signchart(s(x), domain = "[0, ∞)", label="s")
signchart(c(x), label="c")

# Test ###################################################
signcharts(p(x))
signcharts(p(x), xrange = (-4, 5))
signcharts(q(x); labels="q")
signcharts(l(x), domain = ldomain)

# CHECK
signcharts(re(x))

signcharts(rei(x))

#ERROR
signcharts(d(x))

signcharts(s(x), domain = "[0,oo)")
signcharts(s(x), domain = "[0,oo)", xrange = (-.25, 2))
signcharts(p(x), domain = "(-oo,oo)")
signcharts(g(x))

signcharts(g(x); imageFormat = :pdf)
signcharts(g(x); imageFormat = :png)
signcharts(g(x); imageFormat = :ps)



# Test ###################################################
functionplot(c(x), (-5, 5))
functionplot(c(x), (-5, 5); domain = "[-1, 1]", widen=0.03)
functionplot(c(x), (-5, 5); domain = "[-5, 5]")
functionplot(c(x), (-5, 5); domain = "(-5, 5]")
functionplot(c(x), (-5, 5); domain = "[-5, 5)")
functionplot(c(x), (-5, 5); domain = "(-5, 5)")
functionplot(c(x), (-10, 10); domain = "[-10, 10]", widen=0.2)
functionplot(c(x), (-5, 5); domain = "[-5, 5]", yrange = (0, 3))
functionplot(cm(x), (-5, 5); domain = "[-5, 5]")


functionplot(d(x), (-5, 5))
functionplot(d(x), (-10, 10); domain = "[-5, 5]")
functionplot(d(x), (-10, 10); domain = "(-5, 5]")
functionplot(d(x), (-10, 10); domain = "[-5, 5)")
functionplot(d(x), (-10, 10); domain = "(-5, 5)")
functionplot(f(x), (-5, 5))
functionplot(g(x), (-5, 5))
functionplot(g(x), (-1, 3))

#ERROR
functionplot(g′(x), (0, 2); yrange = (-10, 1), vert_ticks = -10:1)

# ERROR
functionplot(g′′(x), (-1, 3))

functionplot(p(x), (-5, 5))
functionplot(r(x), (-5, -1))
functionplot(r1(x), (-1,4); yrange = (-10, 10), vert_ticks = -10:10)
functionplot(r1(x), (-1,4); domain = "(-2,5)", yrange = (-10, 10), vert_ticks = -10:10) #check if xrange and domain agree and if not how to handle
functionplot(s(x), (0,9); domain = sdomain)
functionplot(s(x), (-1,9); domain = sdomain) #compare xrange with domain and make sure it is no bigger
functionplot(q(x), (1,3))
functionplot(l(x), (-1,5); domain = ldomain)

functionplot(t(x), (0, 2π))
functionplot(t(x), (0, 2π); domain = "(0, 6.28)")
functionplot(t(x), (0, 2π); domain = "(0, 6.28]")
functionplot(t(x), (0, 2π); domain = "[0, 6.28)")
functionplot(t(x), (0, 2π); domain = "[0, 6.28]")
functionplot(u(x), (-1,3))
functionplot(e(x), (-5,5))

# ERROR
functionplot(a(x), (-5,5))

functionplot(re(x), (-1,3))
functionplot(rei(x), (-1,3))



# Test ###################################################
plot_function_sign_chart(p(x), (-4, 5))
plot_function_sign_chart(f(x), (-2,2))
plot_function_sign_chart(g(x), (-1,4), yrange = (-10, 10))
plot_function_sign_chart(s(x), (0,9), domain = "[0, ∞)")
plot_function_sign_chart(p(x), (-3,4))

# Sign charts y' and y'' are wrong 
plot_function_sign_chart(re(x), (-1,3))

plot_function_sign_chart(rei(x), (-1,3))

# Test ###################################################
# Some ERRORS
# extrema(c)
# extrema(d)
# extrema(f)
# extrema(f; domain = "[-2,2]")
# extrema(g)
# extrema(g, domain = "(0, ∞)")
# extrema(g, domain = "(0, 5)")
# extrema(p)
# extrema(r)
# extrema(s, domain = "[0, ∞)") # Needs to check endpoint!
# extrema(q)
# extrema(l, domain = "(0, ∞)")
# extrema(t)
# extrema(t, domain = "(-∞, $(2π)]")

extrema(c(x))
extrema(d(x))
extrema(f(x))
extrema(g(x))
extrema(g(x); domain = "[0,2]") #Error min at 2, but y ≠ 2 there
extrema(p(x))
extrema(r(x))
extrema(s(x), domain = "[0, ∞)") # Needs to check endpoint!
extrema(q(x))
extrema(l(x), domain = "(0, ∞)")
extrema(t(x))
extrema(t(x), domain = "(-∞, $(2π)]")


# Test ###################################################
inflection_points(c(x))
inflection_points(p(x))
inflection_points(t(x))

# ERRORS
# inflection_points(c) # kills solve in criticalpoints function
# inflection_points(p)
# inflection_points(t)

# Test ###################################################
fsum = function_summary(c(x))
fsum.signcharts

# ERRORS
function_summary(d(x))

function_summary(f(x))
function_summary(g(x))
function_summary(p(x))
function_summary(r(x))
function_summary(r1(x))
function_summary(s(x), domain = "[0, ∞)")
function_summary(q(x))
function_summary(l(x), domain = ldomain)
function_summary(t(x))
function_summary(t(x), domain = "[0, ∞)")
function_summary(t(x), domain = "(-∞, 6.283185307179586]")
function_summary(t(x), domain = "[0, 6.283185307179586]")
function_summary(t(x), domain = "(-∞, 6.283185307179586]") 
# function_summary(t(x), domain = "(-∞, $(2π)]") #ERROR with 
# function_summary(t(x), domain = "[0, 2π]")
# function_summary(t(x), domain = "(-∞, 2π]") #ERROR with convert_to_interval, it can't handle π

# ERRORS
# function_summary(c) #ERROR in call to inflection_points which calls criticalpoints which calls solve and that breaks
# function_summary(d)
# function_summary(f)
# function_summary(g)
# function_summary(p)
# function_summary(r)
# function_summary(r1)
# function_summary(s, domain = sdomain)
# function_summary(q)
# function_summary(l, domain = ldomain)
# function_summary(t)

# Test ###################################################
int(f(x), x)

# Goal to make the output look nice in the terminal
ans = int(f(x), x)
println(sympy.latex(ans))
println(sympy.latex(ans, mode="equation*"))

print(L"%$(sympy.latex(ans))")

lans = sympy.latex(ans)
mdans = "``" * L"%$lans" * "``" 
temp = Markdown.parse(raw"\frac{x^{3}}{3}")
tprintln(md"$mdans")

println(L"x^3")



int(f(x), x, 0, 1)

# Test ###################################################
distance((0,0), (1,1))































# Stuff to work on #######################################

# Why was I wanting to do this?
p_sum = function_summary(p(x), -3:.01:4)
p_sum[:y_intercept]
p_sum[:max]
p_sum[:min]
p_sum[:inflection]
p_sum[:left_behavior]
p_sum[:right_behavior]
p_sum[:signcharts]

f_sum = function_summary(f(x), -3:.01:4; domain = "[-2,1)")













function_derivative_plot(d(x), (-2, 2), .8)
function_derivative_plot(f(x), (-2, 2), -.8)
function_derivative_plot(g(x), (0, 2), 1.2) # Check if xval is in domian



function_summary_latex(function_summary(p(x)), "p")


digs = 60

temp = subs(x, x, pi)
N(temp)
for digs in [10, 60]
    println("digits = $digs")
    println(temp.evalf(digs))
    println(N(temp, digs))
    println(round(big(N(temp)), digits = digs))
    println(round(big(pi), digits = digs))
end

digits = 10
3.141592654
3.1415926535846666
3.1415926536
3.1415926536

digits = 60
3.14159265358979323846264338327950288419716939937510582097494
3.14159265358979323846264338327950288419716939937510582097493999999999999999999
3.141592653589793
3.141592653589793

temp = subs(x, x, solve(x^2-2, x)[2])
N(temp)
temp.evalf(60)
N(temp, 60)