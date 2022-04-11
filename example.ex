use elexer

# interfacing
defmodule Handlers do
    def alphanumeric(character) do
        character >= "a" && character <= "z" # incomplete alphanumeric; more like lowercase
    end
    def singlechars(char) do
        cond do
            char == "(" ->
                {true, :oparen}
                # You should return {bool, tag}
                # bool should be true when you want the token to be added. false otherwise.
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
# Lexer.lex takes a string to lex, your handlers for single-character tokens, and your handlers for multiple-character tokens.
# Read docs for further info (when they come out, if they aren't there)
# Elexer simplifies everything for you, so that you can just return a boolean and a tag.
# Whether it's for multiple or single character tokens.
Lexer.lex(inp, &Handlers.singlechars/1, &Handlers.multichars/1) |> IO.inspect()
