Fall 2024 we will be using the Dash version of JSUMS120.

The JSUMS120.jl file is my frontend to the SymPy.jl package.
It is intended to make it easier for my Applied Calculus students to learn calculus. 
I first planned to use it in a Pluto.jl notbook,
but it was too slow.

I then rewrote it to run in VS Code.
That works fine,
but the output doesn't look as nice.

So my currect iteration is to use Dash.
You will need to save JSUMS120-dash.jl and JSUMS120-dashapp.jl in the same directory,
then open and run the code in JSUMS120-dashapp.jl.

To use this in Pluto you need to download and save the JSUMS120.jl file in the same directory as where you will save your Pluto notebook. 
Your Pluto notebook has some required code that can be found in the file MS120Template.jl. 
The codeblock of html is not necesary,
but makes the notebook look better (in my opinion).

The file Test_MS200_Pluto.jl runs all the commands in the JSUMS120.jl file to test if it is working correctly.

**Note:** Due to some updates to some packages I am having to update JSUMS120.jl 
and may not work correctly depending on what version of the required packages are being used.