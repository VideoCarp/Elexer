defmodule Lexer do
    def nothing do
    end
    # lex int, list, int, string -> [{string, atom}]
    def uglex(current \\ 0, tokenstream \\ [], len, input_str, singlecharh, multicharh, otherwise, tmp) do
        char = String.at(input_str, current)
        {boolch, tag} = singlecharh.(char)
        {boolmh0, tagm0} = multicharh.(char)
        {boolmh, tagm} = 
            unless tagm0 == :pass do
                {boolmh0, tagm0}
            else
                {false, tagm0}
            end
        unless current >= len do
            cond do


                boolmh ->
                    uglex(current + 1, tokenstream, len, input_str, singlecharh, multicharh, otherwise, tmp <> char)


                boolch ->
                    if tmp == "" do
                        uglex(current + 1, [{char, tag} | tokenstream], len, input_str, singlecharh, multicharh, otherwise, "")
                    else
                        uglex(current, [{tmp, tagm} | tokenstream], len, input_str, singlecharh, multicharh, otherwise, "")
                    end


                true -> 
                    otherwise.()
                    uglex(current + 1, tokenstream, len, input_str, singlecharh, multicharh, otherwise, "")
            end
        else
            # Prepending then reversing is allegedly faster than concatenation
            Enum.reverse(tokenstream)
        end
    end
    # To save you from uglex.
    def lex(input_str, singlecharh, multicharh, otherwise \\ &nothing/0) do
        uglex(0, [], String.length(input_str), input_str, singlecharh, multicharh, otherwise, "")
    end
end

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
Lexer.lex(inp, &Handlers.singlechars/1, &Handlers.multichars/1) |> IO.inspect()
