defmodule Lexer do
    def nothing do
    end
    # -> [{string, atom}]
    def uglex(current, tokenstream, len, input_str, singlecharh, multicharh, otherwise, tmp) do
        char = String.at(input_str, current)
        {boolch, tag} = singlecharh.(char)
        {boolmh, _} = multicharh.(char) # We don't need tagm here. We'll get it later.
        unless current >= len do
            cond do


                boolmh ->
                    uglex(current + 1, tokenstream, len, input_str, singlecharh, multicharh, otherwise, tmp <> char)


                boolch ->
                    if tmp == "" do
                        uglex(current + 1, [{char, tag} | tokenstream], len, input_str, singlecharh, multicharh, otherwise, "")
                    else
                        {_, tagm1} = multicharh.(String.at(input_str, current - 1))
                        uglex(current, [{tmp, tagm1} | tokenstream], len, input_str, singlecharh, multicharh, otherwise, "")
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
    # String, function, function, [function] -> [{string, atom}]
    def lex(input_str, singlecharh, multicharh, otherwise \\ &nothing/0) do
        uglex(0, [], String.length(input_str), input_str, singlecharh, multicharh, otherwise, "")
    end
end
