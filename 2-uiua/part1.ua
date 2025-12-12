⊜□⊸≠@, &sc                  # read + split input
⍚(⊜□⊸≠@-)                   # split individual lines
/◇⊂≡(+⊢⟜(□⇡+1/-)⋕)          # flatmap array of ranges
⍚(°⋕)                       # stringify all
▽⊸(◿2+1≡◇⧻)                 # filter out odd length numbers
⍚⊸(/≍⊕□⊸(⊂⊃(↯⟜0)(↯⟜1)÷2⧻))  # build invalid id masks
/+≡⋕▽≡°□                    # filter and sum
