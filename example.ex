# Make sure to include the following in your mix.exs file.
"""
defmodule Proj.MixProject do # name it anything, too
    use Mix.Project
    def depends() do
        [{:elexer, "~>0.0.2"}]
    end
    def project do
        [
            app: :proj, # name this anything
            version: "0.0.1",
            elixir: "~> 1.13.4",
            deps: depends(),
        ]
    end
    def application, do: []
end
"""

import Lexer
defmodule Handlers do
    def alphanumeric(character) do
        character >= "a" && character <= "z"
    end
    def singlechars(char) do
        cond do
            char == "(" ->
                {true, :oparen}
            char == ")" ->
                {true, :cparen}
            true ->
                {false, :pass}
        end
    end

    def multichars(char) do
        cond do
            alphanumeric(char) ->
                {true, :identifier}
            true ->
                {false, :pass}
        end
    end
end
# len, input_str, singlecharh, multicharh, otherwise (optional)
inp = IO.gets("Input your program: ")
Lexer.lex(inp, &Handlers.singlechars/1, &Handlers.multichars/1) |> IO.inspect()
