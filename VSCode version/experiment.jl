using Revise
includet("JSUMS120-vscode.jl")

using Latexify, LaTeXStrings
latexify(L"\Huge\int_0^\infty \frac{x^3}{e^x-1},dx = \frac{\pi^4}{15}", render=true);

c(x) = 2
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


stemp = sympy.latex(expand((x-3)^2))
stemp2 = sympy.latex(stemp)
latexify(L"$stemp", render=true)
sympy.print_latex(stemp)
latexify(sympy.print_latex(stemp), render=true)

strip(stemp,' ')
latexify(stemp, render=true)

latexify(stemp, env = :raw)