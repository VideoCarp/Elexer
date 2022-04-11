defmodule Lexer do
    def nothing do
       # does nothing
    end
    # lex int, list, int, string -> [{string, atom}]
    def lex(current \\ 0, tokenstream \\ [], len, input_str, singlecharh, multicharh, otherwise, tmp) do
        char = String.at(input_str, current)
        {boolch, tag} = singlecharh.(char)
        {boolmh, tagm} = multicharh.(char)
        unless current >= len do
            cond do

                boolmh ->
                    lex(current + 1, tokenstream, len, input_str, singlecharh, multicharh, otherwise, tmp <> char)


                boolch ->
                    if tmp == "" do
                        lex(current + 1, [{char, tag} | tokenstream], len, input_str, singlecharh, multicharh, otherwise, "")
                    else
                        lex(current, [{tmp, tagm} | tokenstream], len, input_str, singlecharh, multicharh, otherwise, "")
                    end


                true -> 
                    otherwise.()
                    lex(current + 1, tokenstream, len, input_str, singlecharh, multicharh, otherwise, "")
            end
        else
            # we do this because tokens were prepended rather than appended
            # it is actually faster than appending
            Enum.reverse(tokenstream)
        end
    end
end
