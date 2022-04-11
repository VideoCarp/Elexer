defmodule Lexer do
    def nothing do
    end
    # lex int, list, int, string -> [{string, atom}]
    def uglex(current \\ 0, tokenstream \\ [], len, input_str, singlecharh, multicharh, otherwise, tmp) do
        char = String.at(input_str, current)
        {boolch, tag} = singlecharh.(char)
        {boolmh, tagm} = multicharh.(char)
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
            # we do this because tokens were prepended rather than appended
            # this is due to some complications within Elixir.
            Enum.reverse(tokenstream)
        end
    end
    # to save you from the ugliness of uglex -> 
    def lex(len, input_str, singlecharh, multicharh, otherwise \\ &nothing/0) do
        uglex(0, [], len, input_str, singlecharh, multicharh, otherwise, "")
    end
end
