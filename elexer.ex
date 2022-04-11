defmodule Elexer do
    def nothing do
    end
    

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
    @doc """
    `tag` describes the token.
    Lex takes in the following:
    input_str: String,
    singlecharh: Function/1,
    multicharh: Function/1,
    otherwise: Function/0, # optional


    input_str: the program to lex
    singlecharh: the function that returns `{bool, atom}` where `bool` is given when a match is made,
                 and `atom` is given as the argument for the tag to the match.
                 For example, a function that matches "(" to return {true, :oparen}
                              while also matching ")" to return {true, :cparen}
                 `singlecharh` should contain what tokens to match and their tag.
                 Code example (of a function taking `character` as its sole argument)
                 ```elixir
                 cond do
                    char == "(" ->
                        {true, :oparen}
                    char == ")"->
                        {true, :cparen}
                    char == "!" ->
                        {true, :not}
                    true ->
                        {false, :pass}
                 end
                 ```
                 Example on repository.
                 This will allow the lexer to lex these characters. Given a string "()" the lexer will
                 be able to lex that into:
                 ```elixir
                 [{"(", :oparen}, {")", :cparen}]
                 ```

    multicharh: the function that returns `{bool, atom}` where `bool` is given as `true` when the character satisfies the required
                condition, and `atom` is the tag.
                For example, a function that matches alphanumeric characters or underscore
                             while also matching another multi-character pattern.
                Effectively used the same way as `singlecharh`. Example in repository.

    otherwise: what to execute if elexer encounters a foreigh character.
               For example, if `otherwise` is a function that prints an error, it will print the error when a foreigh character is found.


    To give `lex` these arguments, you should use the `&function/arity` syntax, where `arity` is the number of arguments. 
    """
    def lex(input_str, singlecharh, multicharh, otherwise \\ &nothing/0) do
        uglex(0, [], String.length(input_str), input_str, singlecharh, multicharh, otherwise, "")
    end
end
