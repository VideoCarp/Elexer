use elexer
# interfacing
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
Lexer.lex(String.length(inp), inp, &Handlers.singlechars/1, &Handlers.multichars/1) |> IO.inspect()
