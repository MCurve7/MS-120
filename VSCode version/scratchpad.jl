# include("JSUMS120-vscode.jl")
using Revise
includet("JSUMS120-vscode.jl")

begin
	x = symbols("x", real = true)
	h = Sym("h")
	C = Sym("C")
	∞ = oo
end

### Your code goes below ########################################################

f(x) = x^3-4x
functionplot(f(x), (-4,4))
signcharts(f(x))
plot_function_sign_chart(f(x), (-4,4))

functionplot(f(x), (-4,4);  domain = "[-4,4]")
signcharts(f(x); domain = "[-4,4]")
plot_function_sign_chart(f(x), (-4,4);  domain = "[-4,4]")

g(x) = x^2-4
signchart(g(x))

solve(f(x))[1]
real(solve(f(x))[3])
imag(solve(f(x))[3])
N(solve(f(x))[3])
