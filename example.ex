use elexer
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
# current, tokenstream, len, input_str, singlecharh, multicharh, otherwise, tmp
inp = IO.gets("Input your program: ")
Lexer.lex(0, [], String.length(inp), inp, &Handlers.singlechars/1, &Handlers.multichars/1, &Lexer.nothing/0, "") |> IO.inspect()
# Needs prettification. So, we may define a macro to make this look something like: 
# Lexer.lex(&Handlers.singlechars/1, &Handlers.multichars/1, &Lexer.nothing/0)
