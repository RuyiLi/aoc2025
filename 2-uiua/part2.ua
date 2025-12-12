⊜□⊸≠@, &sc
⍚(⊜□⊸≠@-)                                                                                                                                                                  # split individual lines
/◇⊂≡(+⊢⟜(□⇡+1/-)⋕)                                                                                                                                                         # flatmap array of ranges
⍚(°⋕)                       # same as part 1
▽≡⊸(                        # filter for invalid numbers 
  °□                        # given candidate n
  ⊸(                        # find all factors of length(n) > 1
    (⊃(⇌↘1⇌▽⊃((+1¯◿)⊸(+1⇡))(+1⇡))⇡)⧻
    ⟜(↯⧻)                   # create a matrix of range(length(n)) duplicated (# factors) times
    ≡(≡⌊÷)                  # create group masks (e.g. 0 1 2 3 4 5 -> 0 0 1 1 2 2)
  )
  ⊃(∘)(↯⧻)
  ⍚(⧅∘2(⊕∘))                # apply mask (e.g. above mask + "121212" -> ["12" "12" "12"] )
  ≡(=1⧻◴°□)⋅                # deduplicate
  >0/+
)
/+≡⋕
