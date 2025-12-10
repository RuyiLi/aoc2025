# disclaimer: comments were not made to be comprehensible
# L = 76    R = 82    0 = 48    \n = 10   EOF = 0

>                                     # [0, ^0, 0, 0, 0]
>+++++[<++++++++++>-]                 # [0, 50, ^0, 0, 0]
!initial
  >>+                                 # set up continuereading bit
  [
    <<,                               # [password, dial, ^C, 0, 1] C := getchar
    [>]>                              # active cell represents continuereading
    [                                 # if continuereading then [password, dial, C, 0, ^1]
      # read direction
      -<<                             # [password, dial, ^C, 0, 0] clean up continuereading bit
      >++++[<------------------->-]   # [2] := [2] - 'L'
      
      # start reading the number
      ,>++++++[<-------->-]           # [num, ^0, 0, 0] read first digit
      >+                              # [num, 0, ^1, 0] set shouldreadnext bit
      [                               # read digit loop (c := getchar); expect tape to be at shouldreadnext loc
        <,                            # [num, ^c, 1, 0]
        >->+<<                        # [num, ^c, 0, 1]
        ----------[>]>                # active cell represents shouldreaddigit
                                      # if c - 10 == 0 then [num, 0, ^0, 1]
        [                             # if c - 10 != 0 then [num, c - 10, 0, ^1]
          <<++>+++++[<-------->-]<    # [num, ^d, 0, 1] d := c - 48
          <[>>++++++++++<<-]          # [^0, d, num * 10, 1] this can overflow, but i am genuinely not dealing with that, offloading to interpreter
          >[<+>-]                     # [d, ^0, num * 10, 1]
          >[<<+>>-]                   # [d + num * 10, 0, ^0, 1] 
          >+<                         # [d + num * 10, 0, ^0, 2] now, rightmost represents shouldreadnext_tmp + 1; stay on 0 to exit
        ]
        >-                            # [res, 0, ^0, 1|2] -> [res, 0, 0, ^0|1] 
        [-<+>]<                       # [res, 0, ^0|1, 0] set shouldreadnext = shouldreadnext_tmp if necessary
      ]                               # [password, dial, L|R, num, 0, ^0, 0] done reading number
      # !readnum

      +                               # [password, dial, L|R, num, 0, ^1, 0]
      <<<[------>>+<<]>>>             # [password, dial, 0, num, 0|1, ^1, 0] clear rot cell, set isrightrot bit
      <<[>>>>+<<<<-]                  # [password, dial, 0, ^0, 0|1, 1, 0, num] swap num to right
      >[<+>-]<                        # [password, dial, 0, ^0|1, 0, 1, 0, num] move isrightrot bit
      [->]>>                          # active cell is isleftrot, clear isrightrot

      [                               # if isleftrot then [password, dial, 0, 0, 0, ^1, 0, num]
        >>                            # [password, dial, 0, 0, 0, 1, 0, ^num] i := 0
        [
          <<<<<<                      # [password, ^dial, 0, 0, 0, 1, 0, num - i]
          [>]>>>>                     # check if dial == 0, active cell represents shouldoverflow
          [                           # if shouldoverflow then [password, 0, 0, 0, 0, ^1, 0, num - i]
            <<<++++++++++             # [password, 0, ^10, 0, 0, 1, 0, num - i]
            [<++++++++++>-]           # [password, 100, ^0, 0, 0, 1, 0, num - i]
            >>>>
          ]
          <<<<<-                      # decr dial
          [>]>>>>                     # check if dial == 0 after decr
          [<<<<<+>>>>>>]              # incr password if so
          >-                          # decr num
        ]                             # [password, (dial -% num), 0, 0, 0, 1, 0, ^0]
        # !rotleft
      ]

      <                               # if isleftrot then [password, dial, 0, 0, 0, 1, ^0, 0]
      [                               # if !isleftrot then [password, dial, 0, 0, 0, ^1, 0, num]
        >>                            # [password, dial, 0, 0, 0, 1, 0, ^num] i := 0
        [
          <<<<<<                      # [password, ^dial, 0, 0, 0, 1, 0, num - i]
          [>+>+<<-]                   # [password, ^0, dial, dial, 0, 1, 0, num - i] copy dial
          ++++++++++                  # [password, ^10, dial, dial, 0, 1, 0, num - i]
          [>>----------<<-]>>+        # [password, 0, dial, ^dial - 99, 0, 1, 0, num - i]
          [>]>                        # active cell represents isdialsub99
          [                           # if isdialsub99 then [password, 0, dial, dial - 99, 0, ^1, 0, num - i]
                                      # write dial + 1 to the cell where dial - 99 currently is
            <<[-]+                    # [password, 0, dial, ^1, 0, 1, 0, num - i]
            <[>+<-]>                  # [password, 0, 0, ^dial + 1, 0, 1, 0, num - i]
            >                         # [password, 0, 0, dial + 1, ^0, 1, 0, num - i]
          ]                           # dont need to handle else, dial - 99 is correct
          <[<<+>>-]                   # [password, newdial, 0, ^0, 0, 1, 0, num - i] write back to dial location
          <[-]>                       # [password, newdial, 0, ^0, 0, 1, 0, num - i] zero the dial copy

          <<
          [>]>>>>                     # check if dial == 0 after incr
          [<<<<<+>>>>>>]              # incr password if so

          >-                          # i := i + 1
        ]                             # [password, (dial + num) % 100, 0, 0, 0, 1, 0, ^0]
        # !rotright
        <
      ]

      # [password, (dial +- num) % 100, 0, 0, 0, 1, ^0, 0]
      # [password, dial, 0, 0, 0, 1, ^0, 0]
      <-                              # zero out scratch cell
      <+                              # set up continuereading bit
      <<                              # end loop
    ]

    >>                                # pointer invariant
    !output
  ]

  # split answer into digits (max 4 digits, hardcoded)
  <[-]<<<[-]<                         # goto 0 and zero other cells
  >>>>>+<<<<<                         # boolcheck
  
  # divmod (hardcode denom = 10), manually run this four times (assume max answer length is 4 digits)
  [                                   # [^n, 0, 0 (quo), 0 (rem), 0, 1, 0, 0 (remcpy1), 0 (remcpy2), 0 (dig0), 0 (dig1), 0 (dig2), 0 (dig3)]
    ->                                
    >>+                               # incr rem
    [>>>>+>+<<<<<-]>>>>               # copy rem
    ----------[<]<<                   # check if remcpy1 == 10
    [                                 # [n, whichdig, quo, 0, 0, ^1, 0, remcpy1, remcpy2]
      <<<+>>>>>>[-]                   # incr quo and reset remcpy2
      <<<<
    ]
    >>>>[<<<<<+>>>>>-]                # copy remcpy2 to rem
    <[-]                              # [n, whichdig, quo, rem, 0, 1, 0, ^0, 0]
    <<<<<<<
  ]
  >>[<<+>>-]                          # n := quo
  >[>>>>>+<<<<<-]                     # move rem to remcpy2
  >>>>>[>>>>+<<<<-]                   # move remcpy2 to dig3
  <<<<<<<<
  !dig3

  # repeat this process for dig0/1/2
  [->>>+[>>>>+>+<<<<<-]>>>>----------[<]<<[<<<+>>>>>>[-]<<<<]>>>>[<<<<<+>>>>>-]<[-]<<<<<<<]>>[<<+>>-]>[>>>>>+<<<<<-]
  >>>>>[>>>+<<<-]<<<<<<<<
  !dig2

  [->>>+[>>>>+>+<<<<<-]>>>>----------[<]<<[<<<+>>>>>>[-]<<<<]>>>>[<<<<<+>>>>>-]<[-]<<<<<<<]>>[<<+>>-]>[>>>>>+<<<<<-]
  >>>>>[>>+<<-]<<<<<<<<
  !dig1

  [->>>+[>>>>+>+<<<<<-]>>>>----------[<]<<[<<<+>>>>>>[-]<<<<]>>>>[<<<<<+>>>>>-]<[-]<<<<<<<]>>[<<+>>-]>[>>>>>+<<<<<-]
  >>>>>[>+<-]<<<<<<<<
  !dig0

  # print the 4 digits, including leading 0s
  >>>>>>>>>
  <++++++[>++++++++<-]>.[-]>          # use left cell as scratch
  <++++++[>++++++++<-]>.[-]>
  <++++++[>++++++++<-]>.[-]>
  <++++++[>++++++++<-]>.[-]>
