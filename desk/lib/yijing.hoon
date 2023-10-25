/-  *yijing
|%
+$  element  ?(%heaven %lake %fire %thunder %wind %water %mountain %earth)
+$  name  ?(%qian %dui %li %zhen %xun %kan %gen %kun)
+$  trigram  [element name]
+$  trikey  [(list @ud) trigram]
+$  trilist  (list trikey)

++  trigrams
    |=  key=(list @ud)
    ^-  trigram
    =/  =trilist
    :~
        [~[1 1 1] [%heaven %qian]]
        [~[1 1 0] [%lake %dui]]
        [~[1 0 1] [%fire %li]]
        [~[1 0 0] [%thunder %zhen]]
        [~[0 1 1] [%wind %xun]]
        [~[1 0 1] [%water %kan]]
        [~[0 0 1] [%mountain %gen]]
        [~[0 0 0] [%earth %kun]]
    ==
    (~(got by (malt trilist)) key)

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
    ?-  -.upd 
      %sngl
        %-  pairs
        :~  ['who' (ship who.upd)]
            ['when' (time when.cast.upd)]
            ['entropy' (numb entropy.cast.upd)]
            ['intention' s+intention.cast.upd]
            ['position' (numb position.cast.upd)]
            ['momentum' (numb momentum.cast.upd)]   
        ==  
      %mult  ~
    ==

++  enjs-scry
    =,  enjs:format
    |=  scr=scry
    ^-  json    
    ::  combine logs?
    ?-  -.scr
        %shiplog
        :: list
        %-  frond
        :-  `@t`(scot %p who.scr)
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
        %log
        :: map
    
        %-  pairs
        %+  turn  ~(tap by log.scr)
        |=  [p=who q=casts]
        :-  `@t`(scot %p p)
        :-  %a
        %+  turn  q
        |=  cst=cast
        %-  pairs
        :~  ['when' (time when.cst)]
            ['entropy' (numb entropy.cst)]
            ['intention' s+intention.cst]
            ['position' (numb position.cst)]
            ['momentum' (numb momentum.cst)]
        == 
    ==
--

