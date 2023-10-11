/-  *yijing
|%
++  dejs-action
  =,  dejs:format
  |=  jon=json
  ^-  action
  %.  jon
  %-  of
  :~  [%cast (ot ~[intention+so])]
  ==

++  enjs-update
    =,  enjs:format
    |=  upd=update
    ^-  json
    ~&  >  `@p`who.upd
    :: why is this printing multiple times?
    ::  position times?
    ?-  -.upd 
      %share
        %-  pairs
        :~  ['who' (ship who.upd)]
            ['when' (time when.upd)]
            ['entropy' (numb entropy.upd)]
            ['intention' s+intention.upd]
            ['position' (numb position.upd)]
            ['momentum' (numb momentum.upd)]     :: +?
        ==  
    ==

++  enjs-scry
    =,  enjs:format
    |=  scr=scry
    ^-  json    
    ?-  -.scr
        %shiplog
        :: list
        %-  frond
        :-  `@t`(scot %p who.scr)
        :: ~&  >  +.scr
        :-  %a
        %+  turn  casts.scr
        |=  cst=cast
        :: ~&  >  cst
        %-  pairs
        :~  ['when' (time when.cst)]
            ['entropy' (numb entropy.cst)]
            ['intention' s+intention.cst]
            ['position' (numb position.cst)]
            ['momentum' (numb momentum.cst)]
        == 
    ==
:: --
    ::   %log
    ::     :: full mapmap
    ::     ::    +.scry
    ::     list
    ::     %-  pairs
    ::     :~  ['when' (time when.+.scry)]
    ::         ['entropy' (numb entropy.+.scry)]
    ::         ['intention' s+intention.+.scry]
    ::         ['position' (numb position.+.upd)]
    ::         ['momentum' (numb momentum.scry)]
    ::         ==    
    :: ==
--

