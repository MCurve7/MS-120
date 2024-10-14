# You may need to add these packages the first time you run this
# add Dash, DashBootstrapComponents, Base64, PrettyTables, SpecialFunctions, Format, Statistics, DataFrames, Plots, Printf, SymPy, PyCall, LaTeXStrings

# import Pkg; Pkg.add("Formatting")
# import Pkg; Pkg.add("LaTeXStrings")

using Dash

using DashBootstrapComponents
using Base64
# using Revise
# includet("JSUMS120-dash.jl")
include("JSUMS120-dash.jl")

if !isdir("./assets/")
    mkdir("./assets/")
end

# have to convert exp(x) to just exp (etc.) 
# fcn_re = r"^\s*(exp|ln|log|sin|cos|tan)\(\w\)\s*$"
fcn_re = r"^\s*(exp|ln|log|sin|cos|tan|abs)\(\w\)\s*$"

app = dash()

# dcc_markdown("""\$\\displaystyle{\\lim_{x \\to """*(string(val))*"""}} f(x) = """*(string(limit_result))*"""\$""", mathjax  = true)

app.layout = html_div([
    html_h1("""JSUMS120"""),
    # dcc_confirmdialog(id="missing-info",), Figure out how to use a single one need allow_duplicate = true somehow.
    html_div([
        dcc_markdown("""\$f(x) =\$""", 
            mathjax  = true, 
            style=Dict("width" => "4%", "display" => "inline-block")
            ),
            html_div(dcc_input(id = "function", value = "", type = "text", autoFocus = true, placeholder  = "x^3 or exp(x) or ln(x) etc"),
            # html_div(dcc_input(id = "function", value = "x^2", type = "text"),
            # html_div(dcc_input(id = "function", value = "exp(x)", type = "text"),
            # html_div(dcc_input(id = "function", value = "exp(x^2)", type = "text"),
            # html_div(dcc_input(id = "function", value = "sqrt(x)", type = "text"),
            # html_div(dcc_input(id = "function", value = "abs(x)", type = "text"),
            # html_div(dcc_input(id = "function", value = "(x+3)*(x+1)*(x-1)*(x-3)", type = "text"),
            # html_div(dcc_input(id = "function", value = "(x+3)/((x+1)*(x-1))*(x-3)", type = "text"),
            # html_div(dcc_input(id = "function", value = "(x+1)*(x-1)*(x-3)", type = "text"),
            # html_div(dcc_input(id = "function", value = "(x+1)/(x-1)", type = "text"),
                style=Dict("width" => "12%", "display" => "inline-block")
            ),
            html_div("Domain: ",
                    style=Dict("width" => "5%", "display" => "inline-block")
            ),
            html_div(dcc_input(id = "domain", value = "(-∞, ∞)", type = "text"),
                style=Dict("width" => "10%", "display" => "inline-block")
            ),
            # html_div(dcc_input(id = "domain", value = "(-3, 3]", type = "text"),
            #     style=Dict("width" => "10%", "display" => "inline-block")
            # ),
    ]),

    # Limit TAB
    dcc_tabs(id = "tabs", value = "limits", children =[#Can change opening tab with value
        dcc_tab(label="Limits", value = "limits", children=[
            dcc_confirmdialog(id="limits-missing-info",),
            html_h2("""Limits"""),
            html_div([
                html_div("Choose type of limit: ",
                        style=Dict("width" => "10%", "display" => "inline-block")
                ),
                dcc_dropdown(
                    id="limit-type",
                    options = [
                        (label = "Limit Table", value = "limittable"),
                        (label = "Limit", value = "limit")
                    ],
                    value = "limittable",
                    style=Dict("width" => "30%", "display" => "inline-block")
                ),
            ]),
            html_hr(),
            html_div([
                html_div("Limit value: ",
                    style=Dict("width" => "6%", "display" => "inline-block")
                ),
                # html_div(dcc_input(id = "limit-value", value = "missing", type = "text"),
                html_div(dcc_input(id = "limit-value", value = "2", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Direction: ",
                        style=Dict("width" => "5%", "display" => "inline-block")
                ),
                html_div(dcc_dropdown(id="limit-dir",
                    options = [
                        (label = "Both", value = ""),
                        (label = "Left", value = "-"),
                        (label = "Right", value = "+")
                    ],
                    value = "",
                    style=Dict("width" => "30%", "display" => "inline-block"))
                ),
            ]),            
            html_button(id = "btn-limit", children = "Take Limit", title = "Shows the first 10 rows"),
            html_div(id = "output-limit"),
            html_hr(),
            html_div([
                html_div("Format: ",
                        style=Dict("width" => "5%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "limit-format", value = "%10.8f", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Rows: ",
                        style=Dict("width" => "5%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "limit-rows", value = 5, type = "number", min = 5, step = 1),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Variable: ",
                        style=Dict("width" => "5%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "limit-variable", value = "x", type = "text"),
                    style=Dict("width" => "10%", "display" => "inline-block")
                ),
            ]),
            ]),




        # Signchart table TAB
        dcc_tab(label="Sign Charts", value = "signchart", children=[
            dcc_confirmdialog(id="signchart-missing-info",),
            html_div([
                html_div("Label: ",
                        style=Dict("width" => "5%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "signchart-label", value = "y", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                
            ]),
            html_hr(),
            html_div([
            html_div("Image format: ",
                        style=Dict("width" => "6%", "display" => "inline-block")
                ),
            html_div(dcc_dropdown(id="signchart-image-format",
                    options = [
                        "png",    
                        "svg",
                        "pdf"
                    ],
                    value = "png",
                    style=Dict("width" => "30%", "display" => "inline-block"))
                ),
            dcc_radioitems(id = "signchart-single-multiple",
                options = [
                    (label = "Single", value = "single"),
                    (label = "Multiple", value = "multiple")
                ],
                value = "single",
                labelStyle = Dict("display" => "inline-block")
            ),
            ]),
            html_button(id = "signchart-btn", children = "Make signchart", title = "Generates sign chart"),
            html_div(id = "signchart-img"),
            html_hr(),
            html_div([
                html_div("Horizontal jog: ",
                        style=Dict("width" => "7%", "display" => "inline-block")
                ),
                # html_div(dcc_input(id = "signchart-horiz-jog", value = "0.2", type = "text"),
                html_div(dcc_input(id = "signchart-horiz-jog", value = 0.2, type = "number"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Size horizontal: ",
                        style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "signchart-size-horizontal", value = 1000, type = "number", min = 500, step = 10),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Size vertical: ",
                        style=Dict("width" => "6%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "signchart-size-vertical", value = 500, type = "number", min = 100, step = 10),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Dot vertical jog: ",
                        style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "signchart-dotverticaljog", value = 0, type = "number"),
                # html_div(dcc_input(id = "signchart-dotverticaljog", value = "0", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
            ]),
            html_div([
                html_div("Marksize: ",
                        style=Dict("width" => "6%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "signchart-marksize", value = 8, type = "number", min = 1, step = 1),
                # html_div(dcc_input(id = "signchart-marksize", value = "8", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Tick font size: ",
                        style=Dict("width" => "8%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "signchart-tickfontsize", value = 18, type = "number", min = 1, step = 1),
                # html_div(dcc_input(id = "signchart-tickfontsize", value = "18", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                # html_div(dcc_input(id = "signchart-image-format", value = "svg", type = "text"),
                #     style=Dict("width" => "12%", "display" => "inline-block")
                # ),
                html_div("x range: ",
                        style=Dict("width" => "4%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "signchart-xrange", value = "missing", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                # html_div(": ",
                #         style=Dict("width" => "5%", "display" => "inline-block")
                # ),
                # html_div(dcc_input(id = "signchart-", value = "", type = "text"),
                #     style=Dict("width" => "10%", "display" => "inline-block")
                # ),
            ]),
        ]),




        # Function plot TAB
        dcc_tab(label="Plot Function", value = "functionplot", children=[
            dcc_confirmdialog(id="functionplot-missing-info",),
            html_div([
                html_div("Left plot endpoint: ",
                        style=Dict("width" => "8%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-left-endpoint", value = -5, type = "number"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Right plot endpoint: ",
                        style=Dict("width" => "9%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-right-endpoint", value = 5, type = "number"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
            ]),
            html_div([
                html_div("Label: ",
                        style=Dict("width" => "5%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-label", value = "", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
            ]),
            html_hr(),
            html_div([
                html_div("Image format: ",
                            style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_dropdown(id="functionplot-image-format",
                        options = [
                            "png",    
                            "svg",
                            "pdf"
                        ],
                        value = "png",
                        style=Dict("width" => "30%", "display" => "inline-block"))
                ),
            ]),
            html_button(id = "functionplot-btn", children = "Graph function", title = "Graphs function"),
            html_div(id = "functionplot-img"),
            html_hr(),
            html_div([
                html_div("Horizontal ticks: ",
                        style=Dict("width" => "8%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-horiz-ticks", value = "missing", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Vertical ticks: ",
                        style=Dict("width" => "6%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-vertical-ticks", value = "missing", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("y range: ",
                        style=Dict("width" => "6%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-yrange", value = "missing", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("x steps: ",
                        style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-xsteps", value = 0.01, type = "number"),
                    style=Dict("width" => "6%", "display" => "inline-block")
                ),
            ]),
            html_div([
                html_div("Size horizontal: ",
                        style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-size-horizontal", value = 1000, type = "number", min = 500, step = 10),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Size vertical: ",
                        style=Dict("width" => "6%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-size-vertical", value = 500, type = "number", min = 100, step = 10),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Tick font size: ",
                        style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-tickfontsize", value = 20, type = "number", min = 10, step = 1),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Mark size: ",
                        style=Dict("width" => "6%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionplot-marksize", value = 8, type = "number", min = 1, step = 1),
                    style=Dict("width" => "6%", "display" => "inline-block")
                ),
            ]),
        ]),




        # Function summary TAB
        dcc_tab(label="Function Summary", value = "functionsummary", children=[
            dcc_confirmdialog(id="functionsummary-missing-info",),
            html_div([
                html_div("Label: ",
                        style=Dict("width" => "5%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionsummary-label", value = "y", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
            ]),
            html_div([
                html_div("Image format: ",
                            style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_dropdown(id="functionsummary-image-format",
                        options = [
                            "png",    
                            "svg",
                            "pdf"
                        ],
                        value = "png",
                        style=Dict("width" => "30%", "display" => "inline-block"))
                ),
            ]),
            html_button(id = "functionsummary-btn", children = "Make summary", title = "Finds function summary"),
            html_hr(),
            html_h5("Summary:"),
            dcc_markdown(id = "functionsummary-summary"),
            html_div(id = "functionsummary-summary-html"),
            html_div(id = "functionsummary-img"),
            html_hr(),
            html_h5("Advanced Settings"),
            html_div([
                html_div("Dot vertical jog: ",
                        style=Dict("width" => "7%", "display" => "inline-block")
                ),
                # html_div(dcc_input(id = "functionsummary-dotverticaljog", value = "0", type = "text"),
                html_div(dcc_input(id = "functionsummary-dotverticaljog", value = 0, type = "number"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Mark size: ",
                style=Dict("width" => "6%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionsummary-marksize", value = 8, type = "number", min = 1, step = 1),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Tick font size: ",
                        style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionsummary-tickfontsize", value = 20, type = "number", min = 5, step = 1),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Digits: ",
                        style=Dict("width" => "4%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionsummary-digits", value = 2, type = "number", min = 2, step = 1),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
            ]),
            html_div([
                html_div("Size horizontal: ",
                style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionsummary-size-horizontal", value = 1000, type = "number", min = 500, step = 10),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Size vertical: ",
                        style=Dict("width" => "6%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionsummary-size-vertical", value = 500, type = "number", min = 100, step = 10),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                #horiz_jog
                html_div("Horizontal jog: ",
                        style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "functionsummary-horiz-jog", value = 0.2, type = "number"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
            ]),
        ]),





        # Calculus TAB
        dcc_tab(label="Calculus", value = "calculus", children=[
            dcc_confirmdialog(id="derivative-missing-info",),
            dcc_confirmdialog(id="indefinite-missing-info",),
            dcc_confirmdialog(id="definite-missing-info",),
            html_h2("Derivative"),
            html_div([
                html_div("Derivative order: ",
                        style=Dict("width" => "5%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "derivative-order", value = "1", type = "text"),
                    style=Dict("width" => "10%", "display" => "inline-block")
                ),
            ]),
            html_button(id = "derivative-btn", children = "Differentiate", title = "Takes the derivative"),
            dcc_markdown(id = "derivative-result", children = "Click Differentiate button"),
            html_hr(),
            html_h2("Integral"),
            html_div([
                html_div("Variable: ",
                        style=Dict("width" => "5%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "integral-variable", value = "x", type = "text"),
                    style=Dict("width" => "10%", "display" => "inline-block")
                ),
            ]),

            html_h3("Indefinite"),
            html_button(id = "indefinite-integral-btn", children = "Integrate", title = "Takes the indefinite integral"),
            dcc_markdown(id = "indefinite-integral-result", children = "Click Integrate button"),
            html_hr(),

            html_h3("Definite"),
            html_div([
                html_div("Lower limit: ",
                style=Dict("width" => "7%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "calculus-lower-limit", value = "0", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                html_div("Upper limit: ",
                        style=Dict("width" => "6%", "display" => "inline-block")
                ),
                html_div(dcc_input(id = "calculus-upper-limit", value = "1", type = "text"),
                    style=Dict("width" => "12%", "display" => "inline-block")
                ),
                
            ]),
            html_button(id = "definite-integral-btn", children = "Integrate", title = "Takes the definite integral"),
            dcc_markdown(id = "definite-integral-result", children = "Click Integrate button"),
            
            dcc_radioitems(id = "definite-integral-unreduced", 
                options = [
                    (label = "Reduced", value = "reduced"),
                    (label = "Unreduced", value = "unreduced")
                ],
                value = "reduced",
                labelStyle = Dict("display" => "inline-block")
            ),
        ]),








        # Help TAB
        dcc_tab(label="Help", value = "help", children=[
            html_h1("Help"),
            html_hr(),
            dcc_markdown("""
            Not all options are working at this time.

            This help section needs to be adjusted for this format.
            It is copied from the code documentaion.
            """),
            html_hr(),
            html_h2("How to enter functions"),
            dcc_markdown("""
            Not 
            """),
            html_hr(),
            html_h2("Limits"),
            html_hr(),
            dcc_markdown("""
                limittable(f, a; rows::Int=5, dir::String="", format="%10.8f")

            a: a finite number\n
            rows: number of rows to compute (default is 5 rows)\n
            dir: a string indicating which side to take the limit from\n
            format: a string that specifies c-style printf format for numbers (default is %10.8f)
            
            |dir|meaning|
            |---|-------|
            |""|approach from both sides (default)|
            |"-"|approach from the left|
            |"+"|approach from the right|
            """),
            html_hr(),
            dcc_markdown("""
                limittable(f, a::Sym; rows::Int=5, format="%10.2f")

            a: is either oo (meaning ∞) or -oo (meaning -∞)\n
            rows: number of rows to compute (default is 5 rows)\n
            format: a string that specifies c-style printf format for numbers (default is %10.2f)
            """
            ),
            html_hr(),
            dcc_markdown("""
                lim(f(x), var, c; dir = "")
            
            ``\\lim_{x \\to c} f(x) = L``\n
            var: the variable\n
            c: the value to approach including -∞ (-oo) and ∞ (oo)\n
            dir: a string indicating which side to take the limit from. Default is "" which takes the two sided limit, "+" takes the limit from the right, "-" takes the limit from the left
            """
            ),
            html_hr(),
            html_h2("Sign charts"),
            html_hr(),
            dcc_markdown("""
                signchart(a::T; label="", domain = "(-oo, oo)", horiz_jog = 0.2, size=(500, 200), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing) where {T <: Real}
            
            label: makes label for sign chart along left side\n
            domain: of the funtion the sign chart is being made for\n
            horiz_jog: \n
            size: of the sign chart\n
            dotverticaljog: \n
            marksize: \n
            tickfontsize: \n
            imageFormat: choices include :svg, :jpg, :eps, :png, :gif, maybe more need to look up again\n
            xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits
            """ 
            ),
            html_hr(),
            dcc_markdown("""
                signchart(f(x); label="", domain = "(-∞, ∞)", horiz_jog = 0.2, size=(500, 200), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)
            
            label: makes label for sign chart along left side\n
            domain: of the funtion the sign chart is being made for\n
            horiz_jog: moves the signchart horizontally\n
            size: of the sign chart\n
            dotverticaljog: moves the dot on the axis vertically\n
            marksize: changes the size of the dot\n
            tickfontsize: changes the font size of the tick labels\n
            imageFormat: choices include :svg, :jpg, :eps, :png, :gif, maybe more need to look up again\n
            xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits
            """
            ),
            html_hr(),
            dcc_markdown("""
                signcharts(f(x); labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(400, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing)
            
            xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits
            
            Generate stacked sign charts for the given function and its first and second derivative. 
            """ 
            ),
            html_hr(),
            dcc_markdown("""
                signcharts(a::T; labels="y", domain = "(-oo, oo)", horiz_jog = 0.2, size=(400, 500), dotverticaljog = 0, marksize = 8, tickfontsize = 20, imageFormat = :svg, xrange = missing) where {T <: Real}
            
            xrange: sets the limits of the x-axis if given as a pair otherwise automatically uses the critical points to set the limits
            
            Generate stacked sign charts for the given function and its first and second derivative. 
            """ 
            ),
            html_hr(),
            html_h2("Function plot"),
            dcc_markdown("""
                functionplot(f, xrange; label = "", domain = "(-oo, oo)", horiz_ticks = missing, vert_ticks = missing, yrange = missing, xsteps = .01, size = (1000, 500), imageFormat = :svg, tickfontsize = 20, marksize = 8)
            
            Required:\n
            f(x): the function to be ploted
            xrange: a pair giving the ``x`` limits of the plot\n
            Optional:\n
            label: a string usually the name of the function\n
            domain: an interval whritten as a string, e.g. "(-∞, 10]". It overrides xrange.\n
            horiz_ticks: a range giving the horizontal ticks to be displayed\n
            vert_ticks: a range giving the horizontal ticks to be displayed\n
            yrange: a pair giving the ``y`` limits of the plot\n
            xsteps: the step size for the ``x`` values (`xrange[1]:xsteps:xrange[2]`). Defaults to 0.01.\n
            size: size of the graph as an ordered pair. Defaults to (1000, 500)\n
            imageFormat: Only :svg and :png have any effect for now. Choices are :pdf, :png, :ps, :svg.\n
            tickfontsize: \n
            marksize: \n
            """                
            ),
            html_hr(),
            html_h2("Summary"),
            dcc_markdown("""
                function_summary(f; domain::String = "(-∞, ∞)", labels = "y", fig_width = 200, dotverticaljog=0, marksize=8, tickfontsize = 20, format = :side, format_num="%3.2f", horiz_jog = 0.2, size=(1000, 400), imageFormat = :svg, xrange = missing)
            
            Takes a function f and outputs the:\n
            y-intercept,\n
            local max,\n
            local min,\n
            inflection points,\n
            behaviour at infinites/endpoints\n
            function sign chart, derivative sign chart, second derivative sign charts
            as a named tuple with names (:y_intercept, :max, :min, :inflection, :left_behavior, :right_behavior, :signcharts).
            
            
            The inputs are:\n
            f: is the function to summarize,\n
            domain: the domain of the function entered as a string (default "(-∞, ∞)"),\n
            labels: is applied to the sign charts (default "y"),\n
            dotverticaljog: changes the height of the points on the sign chart (default 0),\n
            marksize: changes the diamater of the points on the sign chart (default 8),\n
            tickfontsize: changes the font size of the tick marks (default 20),\n
            digits: number of digits to round values to,\n
            horiz_jog: ?\n
            size: size of the signchart (default (1000, 400)),\n
            imageFormat: image format for the sign charts (default :svg),\n
            xrange: ?
            """                
            ),
            html_hr(),
        ]),

        
    ])
])



# Functions ###########################################################################

# Callbacks ###########################################################################

# Limits ##########################################################################################################################################
callback!(#, allow_duplicate = true
    app,
    Output("limits-missing-info", "message"),
    Output("limits-missing-info", "displayed"),
    Output("output-limit", "children"),
    Input("btn-limit", "n_clicks"),
    State("limit-type", "value"),
    State("function", "value"),
    State("limit-value", "value"),
    State("limit-rows", "value"),
    State("limit-dir", "value"),
    State("limit-format", "value"),
    State("limit-variable", "value"),
    # allow_duplicate = true, # yeah that didn't work...
    prevent_initial_call=true,
) do clicks, limit_type, fcn, lim_value, num_rows, lim_dir, format, limit_var
    if isnothing(clicks)
        throw(PreventUpdate())
    else
        # can I catch veriables that are not x?
        #Error: error handling request
        #exception =
        #ArgumentError: variable must have no free symbols
        if isempty(fcn) && isempty(lim_value)
            ("Please enter a function and the limit value.", true, "")
        elseif isempty(fcn)
            ("Please enter a function. E.g. x^3", true, "")
        elseif isempty(lim_value)
            ("Please enter the limit value. E.g. 2", true, "")
        else
            fcn = replace(fcn, "^" => "**")
            if lim_value == "oo"
                val = ∞
            elseif lim_value == "-oo"
                val = -∞
            elseif lim_value == "pi" || lim_value == "π"
                val = π
            elseif lim_value == "e" || lim_value == "E"
                val = ℯ
            else
                val = parse(Float64, lim_value)
            end
            if limit_type == "limittable"
                m = match(fcn_re, fcn)
                # println("m = $m")
                if !isnothing(m)
                    # fcn = m[1]
                    fcn = "$(m[1])(x)+0"
                    # println("fcn = $fcn")
                end
                if lim_value == "oo" || lim_value == "-oo"
                    return ("", false, limittable(sympy.parse_expr(fcn), val; rows = num_rows, format = format))
                else
                    return ("", false, limittable(sympy.parse_expr(fcn), val; rows = num_rows, dir = lim_dir, format = format))
                end
            else
                limit_result = lim(sympy.parse_expr(fcn), limit_var, val; dir = lim_dir)  
                ("", false, dcc_markdown("""\$\\displaystyle{\\lim_{x \\to """*(string(val))*"""}} f(x) = """*(Printf.format(Printf.Format(format), limit_result))*"""\$""", mathjax  = true))
                # ("", false, dcc_markdown("""\$\\displaystyle{\\lim_{x \\to """*(string(val))*"""}} f(x) = """*(string(limit_result))*"""\$""", mathjax  = true))
            end
        end
    end
end

callback!(
    app,
    Output("limit-variable", "disabled"),
    Output("limit-rows", "disabled"),
    Input("limit-type", "value")
) do limit_type
    show_limit_var = limit_type == "limittable" ? true : false
    show_limit_rows = limit_type == "limittable" ? false : true
    show_limit_var, show_limit_rows 
end

# Signchart ########################################################################################################################################
callback!(
    app,
    Output("signchart-missing-info", "message"),
    Output("signchart-missing-info", "displayed"),
    Output("signchart-img", "children"),
    Input("signchart-btn", "n_clicks"),
    State("function", "value"),
    State("domain", "value"),
    State("signchart-label", "value"),
    State("signchart-horiz-jog", "value"),
    State("signchart-size-horizontal", "value"),
    State("signchart-size-vertical", "value"),
    State("signchart-dotverticaljog", "value"),
    State("signchart-marksize", "value"),
    State("signchart-tickfontsize", "value"),
    State("signchart-image-format", "value"),
    State("signchart-xrange", "value"),
    State("signchart-single-multiple", "value"),
    prevent_initial_call=true,
)do clicks, fcn, domain, label, horiz_jog, size_horizontal, size_vertical, dotverticaljog, marksize, tickfontsize, imageFormat, xrange, howmany
    if isnothing(clicks)
        throw(PreventUpdate())
    else # Also need to check if domain is formatted correctly
        if isempty(fcn) && isempty(domain)
            ("Please enter a function and a domain.", true, "")
        elseif isempty(fcn)
            ("Please enter a function. E.g. x^3", true, "")
        elseif isempty(domain)
            ("Please enter the domian. E.g. [-oo, 5)", true, "")
        else
            fcn = replace(fcn, "^" => "**")
            size = (size_horizontal, size_vertical)
            imageFormat_symbol = Symbol(imageFormat)
            xrange = xrange == "missing" ? missing : xrange
            if howmany == "single"
                p = signchart(sympy.parse_expr(fcn); label, domain, horiz_jog, size, dotverticaljog, marksize, tickfontsize, imageFormat = imageFormat_symbol, xrange)
                figname = "./assets/signchart."*imageFormat
            else
                p = signcharts(sympy.parse_expr(fcn); labels = label, domain, horiz_jog, size, dotverticaljog, marksize, tickfontsize, imageFormat = imageFormat_symbol, xrange)
                figname = "./assets/signcharts."*imageFormat
            end
            savefig(p, figname)
            return ("", false, html_img(src = "data:image/$imageFormat;base64,$(open(base64encode, figname))"))
        end
    end
end

# Function plot ###################################################################################################################################
callback!(
    app,
    Output("functionplot-missing-info", "message"),
    Output("functionplot-missing-info", "displayed"),
    Output("functionplot-img", "children"),
    Input("functionplot-btn", "n_clicks"),
    State("function", "value"),
    State("domain", "value"),
    State("functionplot-left-endpoint", "value"),
    State("functionplot-right-endpoint", "value"),
    State("functionplot-label", "value"),
    State("functionplot-image-format", "value"),
    State("functionplot-horiz-ticks", "value"),
    State("functionplot-vertical-ticks", "value"),
    State("functionplot-yrange", "value"),
    State("functionplot-xsteps", "value"),
    State("functionplot-size-horizontal", "value"),
    State("functionplot-size-vertical", "value"),
    State("functionplot-tickfontsize", "value"),
    State("functionplot-marksize", "value")
) do clicks, fcn, domain, left_endpt, right_endpt, label, imageFormat, horiz_ticks, vert_ticks, yrange, xsteps, size_horizontal, size_vertical, tickfontsize, marksize
    if isnothing(clicks)
        throw(PreventUpdate())
    else
        if isempty(fcn)
            ("Please enter a function. E.g. x^3", true, "")
        elseif isempty(domain)
            ("Please enter the domian. E.g. [-oo, 5)", true, "")
        elseif isempty(left_endpt) || isempty(right_endpt)
            ("Please enter an endpoint. E.g. 3", true, "")
        else
            fcn = replace(fcn, "^" => "**")
            # xrange = (parse(Float64, left_endpt), parse(Float64, right_endpt))
            xrange = (left_endpt, right_endpt)
            # size = (parse(Int64, size_horizontal), parse(Int64, size_vertical))
            size = (size_horizontal, size_vertical)
            horiz_ticks = missing #horiz_ticks... split and reform? Eg 0:0.1:3
            vert_ticks = missing #vert_ticks... split and reform? Eg 0:0.1:3
            if yrange != "missing"
                ymin, ymax = split(yrange, ",")
                yrange = (parse(Float64, ymin), parse(Float64, ymax))
            else
                yrange = missing #yrange is a pair so split and reform
            end
            # xsteps = parse(Float64, xsteps)
            # tickfontsize = parse(Int64, tickfontsize)
            # marksize = parse(Int64, marksize)
            imageFormat_symbol = Symbol(imageFormat)
            p = functionplot(sympy.parse_expr(fcn), xrange; label, domain, horiz_ticks, vert_ticks, yrange, xsteps, size, imageFormat = imageFormat_symbol, tickfontsize, marksize)
            figname = "./assets/functionplot."*imageFormat
            savefig(p, figname)
            return ("", false, html_img(src = "data:image/$imageFormat;base64,$(open(base64encode, figname))"))
        end
    end
end

# Summary #########################################################################################################################################
callback!(
    app,
    # Output("functionsummary-summary", "children"),
    Output("functionsummary-missing-info", "message"),
    Output("functionsummary-missing-info", "displayed"),
    Output("functionsummary-summary-html", "children"),
    Output("functionsummary-img", "children"),
    Input("functionsummary-btn", "n_clicks"),
    State("function", "value"),
    State("domain", "value"),
    State("functionsummary-label", "value"),
    State("functionsummary-dotverticaljog", "value"),
    State("functionsummary-marksize", "value"),
    State("functionsummary-tickfontsize", "value"),
    State("functionsummary-digits", "value"),
    State("functionsummary-horiz-jog", "value"),
    State("functionsummary-size-horizontal", "value"),  
    State("functionsummary-size-vertical", "value"),
    State("functionsummary-image-format", "value")
    # State("functionsummary-xrange", "value")
) do clicks, fcn, domain, labels, dotverticaljog, marksize, tickfontsize, digits, horiz_jog, size_horizontal, size_vertical, imageFormat
    if isnothing(clicks)
        throw(PreventUpdate())
    else
        if isempty(fcn)
            ("Please enter a function. E.g. x^3", true, "", "")
        elseif isempty(domain)
            ("Please enter the domian. E.g. [-oo, 5)", true, "", "")
        else
            fcn = replace(fcn, "^" => "**")
            labels = isempty(labels) ? "y" : labels
            # xrange = (parse(Int64, left_endpt),parse(Int64, right_endpt))
            # dotverticaljog = parse(Int64, dotverticaljog)
            # marksize = parse(Int64, marksize)
            # tickfontsize = parse(Int64, tickfontsize)
            # digits = parse(Int64, digits)
            # horiz_jog = parse(Float64, horiz_jog)
            size = (size_horizontal, size_vertical)
            # size = (parse(Int64, size_horizontal), parse(Int64, size_vertical))
            imageFormat_symbol = Symbol(imageFormat)
            summary = function_summary(sympy.parse_expr(fcn); domain, labels, dotverticaljog, marksize, tickfontsize, digits, horiz_jog, size, imageFormat = imageFormat_symbol, xrange = missing)
            figname = "./assets/summarysignchart."*imageFormat
            savefig(summary.signcharts, figname)
            # println(summary)
            # summary_md = """
            # | Property | Value(s) |
            # | -------- | ---------|
            # | *y*-intercept | $(summary.y_intercept) |
            # | Local Maxiumum | $(summary.max[1]) |
            # | Local Minimum | $(summary.min[1]) |
            # | Inflection point(s) | $(summary.inflection[1]) |
            # | Left behavior | $(summary.left_behavior) |
            # | Right behavior | $(summary.right_behavior) |
            # """
            summary_max = isempty(summary.max) ? "None" : join(string.(summary.max), ", ")
            summary_min = isempty(summary.min) ? "None" : join(string.(summary.min), ", ")
            summary_inflection = isempty(summary.inflection) ? "None" : join(string.(summary.inflection), ", ")
            summary_html = 
            html_table([
                html_tr([html_td("y-intercept", style = Dict("border"=>"1px solid black")), html_td("$(summary.y_intercept)", style = Dict("border"=>"1px solid black"))]),
                html_tr([html_td("Local Maxiumum", style = Dict("border"=>"1px solid black")), html_td(summary_max, style = Dict("border"=>"1px solid black"))]),
                html_tr([html_td("Local Minimum", style = Dict("border"=>"1px solid black")), html_td(summary_min, style = Dict("border"=>"1px solid black"))]),
                html_tr([html_td("Inflection point(s)", style = Dict("border"=>"1px solid black")), html_td(summary_inflection, style = Dict("border"=>"1px solid black"))]),
                html_tr([html_td("Left behavior", style = Dict("border"=>"1px solid black")), html_td("$(summary.left_behavior)", style = Dict("border"=>"1px solid black"))]),
                html_tr([html_td("Right behavior", style = Dict("border"=>"1px solid black")), html_td("$(summary.right_behavior)", style = Dict("border"=>"1px solid black"))]),
                ],
                style = Dict("border"=>"1px solid black")
            )
            # return summary_md, summary_html, html_img(src = "data:image/$imageFormat;base64,$(open(base64encode, figname))")
            return ("", false,summary_html, 
                    html_div([
                        html_h6("Sign charts:")
                        html_img(src = "data:image/$imageFormat;base64,$(open(base64encode, figname))")
                    ]))
        end
    end
end

# Calculus #######################################################################################################################################
callback!(
    app,
    Output("derivative-missing-info", "message"),
    Output("derivative-missing-info", "displayed"),
    Output("derivative-result", "children"),
    Input("derivative-btn", "n_clicks"),
    State("function", "value"),
    State("derivative-order", "value")
) do clicks, fcn, n
    if isnothing(clicks)
        throw(PreventUpdate())
    else
        if isempty(fcn)
            ("Please enter a function. E.g. x^3", true, "")
        elseif isempty(n)
            ("Please enter the order of the derivative (first, second, etc) as an positive integer. E.g. 1", true, "")
        else
            fcn = replace(fcn, "^" => "**")
            return ("", false, "$(diff(sympy.parse_expr(fcn), x, n))")
        end
    end
end

callback!(
    app,
    Output("indefinite-missing-info", "message"),
    Output("indefinite-missing-info", "displayed"),
    Output("indefinite-integral-result", "children"),
    Input("indefinite-integral-btn", "n_clicks"),
    State("function", "value"),
    State("integral-variable", "value")
) do clicks, fcn, integral_var
    if isnothing(clicks)
        throw(PreventUpdate())
    else
        if isempty(fcn)
            ("Please enter a function. E.g. x^3", true, "")
        elseif isempty(integral_var)
            ("Please enter the variable. E.g. x", true, "")
        else
            fcn = replace(fcn, "^" => "**")
            return ("", false, "$(int(sympy.parse_expr(fcn), sympy.parse_expr(integral_var)))")
        end
    end
end

callback!(
    app,
    Output("definite-missing-info", "message"),
    Output("definite-missing-info", "displayed"),
    Output("definite-integral-result", "children"),
    Input("definite-integral-btn", "n_clicks"),
    Input("definite-integral-unreduced", "value"),
    State("function", "value"),
    State("integral-variable", "value"),
    State("calculus-lower-limit", "value"),
    State("calculus-upper-limit", "value")
) do clicks, reduce, fcn, integral_var, a, b
    if isnothing(clicks)
        throw(PreventUpdate())
    else
        if isempty(fcn)
            ("Please enter a function. E.g. x^3", true, "")
        elseif isempty(integral_var)
            ("Please enter the variable. E.g. x", true, "")
        elseif isempty(a) || isempty(b)
            ("Please enter the lower or upper limit of the integral. E.g. 2", true, "")
        else
            fcn = replace(fcn, "^" => "**")
            if reduce == "reduced"
                return ("", false, "$(N(int(sympy.parse_expr(fcn), (sympy.parse_expr(integral_var), a, b))))")
            else
                return ("", false, "$(int(sympy.parse_expr(fcn), (sympy.parse_expr(integral_var), a, b)))")
            end
        end
    end
end

println("\nOpen your browswer to: http://127.0.0.1:8050/\n")

run_server(app, "0.0.0.0", debug=true, dev_tools_hot_reload = false)
# run_server(app, "0.0.0.0", debug=true)