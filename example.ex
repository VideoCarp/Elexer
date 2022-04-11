# Make sure to include the following in your mix.exs file.
# def deps do
#    [{:elexer, "~>0.0.2"}]
# end
# And run the file with `mix run example.ex`

# Make sure to also read the docs at https://hexdocs.pm/elexer
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
