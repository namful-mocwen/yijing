/-  *yijing

|%
++  linelist
    |=  [eny=entropy count=@ud]
    ^-  (list @ud)
    :: temporary entropy solution
    =+  rng=~(. og (div eny count))
        =^  r1  rng  (rads:rng 2)
        =^  r2  rng  (rads:rng 2)
        =^  r3  rng  (rads:rng 2)
    :~(r1 r2 r3)
    
++  add2
    |=  line=(list @ud)
    =/  a2  |=(a=@ud (add a 2))
    (turn line a2)

++  linesum
    |=  x=(list @ud)
    (roll x add)

++  cast6
    |=  eny=entropy  
    ^-  (list @ud) 
    =/  counter  6
    =/  hexagram  `(list @ud)`~
    |-
     ~&  >>  [%hex hexagram]
    ?:  =(counter 0)  hexagram
        %=  $
         counter  (dec counter)
         hexagram  (flop (weld (limo [(linesum (add2 (linelist eny counter))) ~]) hexagram))
        
    ==
       
++  beinghex
    |=  cast=(list @ud)
    =/  n  6
    =/  x  (snag (dec n) cast)
    |-
    ::  is n=0? if yes return cast
    ?:  =(n 0)  cast
    ::  if no, make the following changes
    =/  x  (snag (dec n) cast)
    %=  $
    ::  To cast first ask: Is it a 6?
    cast  ?:  |(=(x 6) =(x 8))
    ::  %.y --> 0
        (snap cast (dec n) 0)
    ::  %.n --> 1
    (snap cast (dec n) 1)
    n  (dec n)


    ==
++  becominghex
    |=  cast=(list @ud)
    =/  n  6
    =/  x  (snag (dec n) cast)
    |-
    ::  is n=0? if yes return cast6
             
    ?:  =(n 0)  cast
    ::  if no, make the following changes
    =/  x  (snag (dec n) cast)
    %=  $
    cast  ?:  |(=(x 8) =(x 9)) 
    ::  %.y --> 0
        (snap cast (dec n) 0)
    ::  %.n --> 1
    (snap cast (dec n) 1)
    n  (dec n)

    ==

++  changing-lines
    |=  cast=(list @ud)
    %+  turn
    %+  sort  
    %+  weld 
        (fand `(list @ud)`~[6] cast) 
        (fand `(list @ud)`~[9] cast)
    lth
    |=(a=@ud (add a 1))

++  trigrams
    |=  key=(list @ud)
    ^-  trigram
    =/  =trilist
    :~
        [~[1 1 1] [%heaven %qian]]
        [~[0 1 1] [%lake %dui]]
        [~[1 0 1] [%fire %li]]
        [~[1 0 0] [%thunder %zhen]]
        [~[0 1 1] [%wind %xun]]
        [~[0 1 0] [%water %kan]]
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
            ['changing' a+(turn changing.cast.upd |=(chg=@ud (numb chg)))]
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
        :: lis
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
            ['changing' a+(turn changing.cst |=(chg=@ud (numb chg)))]
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
            ['changing' a+(turn changing.cst |=(chg=@ud (numb chg)))]
            ['momentum' (numb momentum.cst)]
        == 
        %hexa
        ::map
        :-  %a
        %+  turn  ~(tap by hxgrms.scr)
        ::  numbers dont work as keys
        |=  [key=(list @ud) hxa=hexagram]
        %-  pairs
        :~  ['num' (numb num.hxa)]
            ['hc' (tape hc.hxa)]
            ['nom' (tape nom.hxa)]
            ['c' (tape c.hxa)]
            ['jud' (tape jud.hxa)]
            ['img' (tape img.hxa)]
            ['l1' (tape l1.hxa)]
            ['l2' (tape l2.hxa)]
            ['l3' (tape l3.hxa)]
            ['l4' (tape l4.hxa)]
            ['l5' (tape l5.hxa)]
            ['l6' (tape l6.hxa)]
        == 
    ==

++  hex-to-num
    |=  key=(list @ud)
    ^-  @ud
    =/  =hexlist
    :~
    [~[1 1 1 1 1 1] 1]      ::  qian
    [~[0 0 0 0 0 0] 2]      ::  kun
    [~[1 0 0 0 1 0] 3]      ::  zhun
    [~[0 1 0 0 0 1] 4]      ::  meng
    [~[1 1 1 0 1 0] 5]      ::  xu
    [~[0 1 0 1 1 1] 6]      ::  song
    [~[0 1 0 0 0 0] 7]      ::  shi
    [~[0 0 0 0 1 0] 8]      ::  bi
    [~[1 1 1 0 1 1] 9]      ::  xiao xu
    [~[1 1 0 1 1 1] 10]     ::  lu
    [~[1 1 1 0 0 0] 11]     ::  tai
    [~[0 0 0 1 1 1] 12]     ::  pi
    [~[1 0 1 1 1 1] 13]     ::  tong ren
    [~[1 1 1 1 0 1] 14]     ::  da you
    [~[0 0 1 0 0 0] 15]     ::  qia'n
    [~[0 0 0 1 0 0] 16]     ::  yu
    [~[1 0 0 1 1 0] 17]     ::  sui
    [~[0 1 1 0 0 1] 18]     ::  gu
    [~[1 1 0 0 0 0] 19]     ::  lin
    [~[0 0 0 0 1 1] 20]     ::  guan
    [~[1 0 0 1 0 1] 21]     ::  shi ke
    [~[1 0 1 0 0 1] 22]     ::  bi
    [~[0 0 0 0 0 1] 23]     ::  bo
    [~[1 0 0 0 0 0] 24]     ::  fu
    [~[1 0 0 1 1 1] 25]     ::  wu wang
    [~[1 1 1 0 0 1] 26]     ::  da xu
    [~[1 0 0 0 0 1] 27]     ::  yi
    [~[0 1 1 1 1 0] 28]     ::  da guo
    [~[0 1 0 0 1 0] 29]     ::  kan
    [~[1 0 1 1 0 1] 30]     ::  li
    [~[0 0 1 1 1 0] 31]     ::  xian
    [~[0 1 1 1 0 0] 32]     ::  heng
    [~[0 0 1 1 1 1] 33]     ::  dun
    [~[1 1 1 1 0 0] 34]     ::  da zhuang
    [~[0 0 0 1 0 1] 33]     ::  jin
    [~[1 0 1 0 0 0] 36]     ::  ming yi
    [~[1 0 1 0 1 1] 37]     ::  jia ren
    [~[1 1 0 1 0 1] 38]     ::  kui
    [~[0 0 1 0 1 0] 39]     ::  jian
    [~[0 1 0 1 0 0] 40]     ::  xie
    [~[1 1 0 0 0 1] 41]     ::  sun
    [~[1 0 0 0 1 1] 42]     ::  yi
    [~[1 1 1 1 1 0] 43]     ::  guai
    [~[0 1 1 1 1 1] 44]     ::  gou
    [~[0 0 0 1 1 0] 45]     ::  cui
    [~[0 1 1 0 0 0] 46]     ::  sheng
    [~[0 1 0 1 1 0] 47]     ::  kun
    [~[0 1 1 0 1 0] 48]     ::  jing
    [~[1 0 1 1 1 0] 49]     ::  ge
    [~[0 1 1 1 0 1] 50]     ::  ding
    [~[1 0 0 1 0 0] 51]     ::  zhen
    [~[0 0 1 0 0 1] 52]     ::  gen
    [~[0 0 1 0 1 1] 53]     ::  jian
    [~[1 1 0 1 0 0] 54]     ::  gui mei
    [~[1 0 1 1 0 0] 55]     ::  feng
    [~[0 0 1 1 0 1] 56]     ::  lu
    [~[0 1 1 0 1 1] 57]     ::  xun
    [~[1 1 0 1 1 0] 58]     ::  dui
    [~[0 1 0 0 1 1] 59]     ::  huan
    [~[1 1 0 0 1 0] 60]     ::  jie
    [~[1 1 0 0 1 1] 61]     ::  zhong fu
    [~[0 0 1 1 0 0] 62]     ::  xiao guo
    [~[1 0 1 0 1 0] 63]     ::  ji ji
    [~[0 1 0 1 0 1] 64]     ::  wei ji
    ==  
    (~(got by (malt hexlist)) key)
    
++  hexagrams
    |=  key=(list @ud)
    ^-  hxgrms
    =/  =hexkeylist
    :~
        :-  ~[1 1 1 1 1 1]  
            :*
                num=1
                hc="䷀"
                nom="Initiating"
                c="乾"
                jud="The creative works sublime success, furthering through perseverance."
                img="The movement of heaven is full of power. Thus the superior man makes himself strong and untiring."
                l1="Hidden dragon. Do not act."
                l2="Dragon appearing in the field. It furthers one to see the great man."
                l3="All day long the superior man is creatively active. At nightfall his mind is still beset with cares. Danger. No blame."
                l4="Wavering flight over the depths. No blame."
                l5="Flying dragon in the heavens. It furthers one to see the great man."
                l6="Arrogant dragon will have cause to repent."
            ==
        :-  ~[0 0 0 0 0 0]
            :*
                num=2
                hc="䷁"
                nom="Responding"
                c="坤"
                jud="The receptive brings about sublime success, furthering through the perseverance of a mare. Quiet perseverance brings good fortune."
                img="The earth's condition is receptive devotion: Thus the superior man who has breadth of character carries the outer world."
                l1="When there's hoarfrost underfoot, solid ice isn't far off."
                l2="Straight, square, great. Without purpose, yet nothing remains unfurthered."
                l3="Hidden lines. One is able to remain persevering. If by chance you're in the service of a king, seek not works, but bring to completion."
                l4="A tied-up sack. No blame, no praise."
                l5="A yellow lower garment brings supreme good fortune."
                l6="Dragons fight in the meadow. Their blood is black and yellow."
            ==
        :-  ~[1 0 0 0 1 0]
            :*
                num=3
                hc="䷂"
                nom="Beginning"
                c="屯"
                jud="Difficulty at the beginning works supreme success, Furthering through perseverance. Nothing should be undertaken. It furthers one to appoint helpers."
                img="Clouds and thunder: Thus the superior man brings order out of confusion."
                l1="Hesitation and hindrance. It furthers one to remain persevering. It furthers one to appoint helpers."
                l2="Difficulties pile up. Horse and wagon part. He's not a robber; He wants to woo when the time comes. The maiden is chaste, she doesn't pledge herself. Ten years - then she pledges herself."
                l3="Whoever hunts deer without the forester only loses his way in the forest. The superior man understands the signs of the time and prefers to desist. To go on brings humiliation."
                l4="Horse and wagon part. Strive for union. To go brings good fortune. Everything acts to further."
                l5="Difficulties in blessing. A little perseverance brings good fortune. Great perseverance brings misfortune."
                l6="Horse and wagon part. Bloody tears flow."
            ==
        :-  ~[0 1 0 0 0 1]
            :*
                num=4
                hc="䷃"
                nom="Childhood"
                c="蒙"
                jud="Youthful folly has success. It's not I who seek the young fool; the young fool seeks me. At the first oracle I inform him. If he asks two or three times, it's importunity. If he importunes, I give him no information. Perseverance furthers."
                img="A spring wells up at the foot of the mountain: Thus the superior man fosters his character by thoroughness in all that he does."
                l1="To make a fool develop it furthers one to apply discipline. The fetters should be removed. To go on in this way brings humiliation."
                l2="To bear with fools in kindliness brings good fortune. To know how to take women brings good fortune. The son is capable of taking charge of the household."
                l3="Take not a maiden who, when she sees a man of bronze, loses possession of herself. Nothing furthers."
                l4="Entangled folly bring humiliation."
                l5="Childlike folly brings good fortune."
                l6="In punishing folly it doesn't further one to commit transgressions. The only thing that furthers is to prevent transgressions."
            ==
        :-  ~[1 1 1 0 1 0]
            :*
                num=5
                hc="䷄"
                nom="Needing"
                c="需"
                jud="Waiting. If you're sincere, you have light and success. Perseverance brings good fortune. It furthers one to cross the great water."
                img="Clouds rise up to heaven: Thus the superior man eats and drinks, Is joyous and of good cheer."
                l1="Waiting in the meadow. It furthers one to abide in what endures. No blame."
                l2="Waiting on the sand. There's some gossip. The end brings good fortune."
                l3="Waiting in the mud brings about the arrival of the enemy."
                l4="Waiting in blood. Get out of the pit."
                l5="Waiting at meat and drink. Perseverance brings good fortune."
                l6="One falls into the pit. Three uninvited guests arrive. Honor them, and in the end there will be good fortune."
            ==
        :-  ~[0 1 0 1 1 1]
            :*
                num=6
                hc="䷅"
                nom="Contention"
                c="訟"
                jud="Conflict. You are sincere and are being obstructed. A cautious halt halfway brings good fortune. Going through to the end brings misfortune. It furthers one to see the great man. It doesn't further one to cross the great water."
                img="Heaven and water go their opposite ways: Thus in all his transactions the superior man carefully considers the beginning."
                l1="If one doesn't perpetuate the affair, There's a little gossip. In the end, good fortune comes."
                l2="One can't engage in conflict; One returns home, gives way. The people of his town, Three hundred households, Remain free of guilt."
                l3="To nourish oneself on ancient virtue induces perseverance. Danger. In the end, good fortune comes. If by chance you're in the service of a king, Seek not works."
                l4="One can't engage in conflict. One turns back and submits to fate, changes one's attitude, and finds peace in perseverance. Good fortune."
                l5="To contend before him brings supreme good fortune."
                l6="Even if by chance a leather belt is bestowed on one, by the end of a morning it will have been snatched away three times."
            ==
        :-  ~[0 1 0 0 0 0]
            :*
                num=7
                hc="䷆"
                nom="Multitude"
                c="師"
                jud="The army. The army needs perseverance and a strong man. Good fortune without blame."
                img="In the middle of the earth is water: Thus the superior man increases his masses by generosity toward the people."
                l1="An army must set forth in proper order. If the order isn't good, misfortune threatens."
                l2="In the midst of the army. Good fortune. No blame. The king bestows a triple decoration."
                l3="Perchance the army carries corpses in the wagon. Misfortune."
                l4="The army retreats. No blame."
                l5="There's game in the field. It furthers one to catch it. Without blame. Let the eldest lead the army. The younger transports corpses; Then perseverance brings misfortune."
                l6="The great prince issues commands, founds states, vests families with fiefs. Inferior people shouldn't be employed."
            ==
        :-  ~[0 0 0 0 1 0]
            :*
                num=8
                hc="䷇"
                nom="Union"
                c="比"
                jud="Holding together brings good fortune. Inquire of the oracle once again whether you possess sublimity, constancy, and perseverance; No blame. Those who are uncertain gradually join. Whoever comes too late meets with misfortune."
                img="On the earth is water: Thus the kings of antiquity bestowed the different states as fiefs and cultivated friendly relations with the feudal lords."
                l1="Hold to him in truth and loyalty; This is without blame. Truth, like a full earthen bowl. Thus in the end good fortune comes from without."
                l2="Hold to him inwardly. Perseverance brings good fortune."
                l3="You hold together with the wrong people."
                l4="Hold to him outwardly also. Perseverance brings good fortune."
                l5="Manifestation of holding together. In the hunt the king uses beaters on three sides only and forgoes game that runs off in front. The citizens need no warning. Good fortune."
                l6="He finds no head for holding together. Misfortune."
            ==
        :-  ~[1 1 1 0 1 1]
            :*
                num=9
                hc="䷈"
                nom="Little Accumulation"
                c="小畜"
                jud="The taming power of the small has success. Dense clouds, no rain from our western region."
                img="The wind drives across heaven: Thus the superior man refines the outward aspect of his nature."
                l1="Return to the way. How could there be blame in this? Good fortune."
                l2="He allows himself to be drawn into returning. Good fortune."
                l3="The spokes burst out of the wagon wheels. Man and wife roll their eyes."
                l4="If you're sincere, blood vanishes and fear gives way. No blame."
                l5="If you're sincere and loyally attached, you are rich in your neighbor."
                l6="The rain comes, there's rest. This is due to the lasting effect of character. Perseverance brings the woman into danger. The moon is nearly full. If the superior man persists, misfortune comes."
            ==
        :-  ~[1 1 0 1 1 1]
            :*
                num=10
                hc="䷉"
                nom="Fulfillment"
                c="履"
                jud="Treading on the tail of the tiger. It doesn't bite the man. Success."
                img="Heaven above, the lake below: Thus the superior man discriminates between high and low, and thereby fortifies the thinking of the people."
                l1="Simple conduct. Progress without blame."
                l2="Treading a smooth, level course. The perseverance of a dark man brings good fortune."
                l3="A one-eyed man is able to see, a lame man is able to tread. He treads on the tail of the tiger. The tiger bites the man. Misfortune."
                l4="He treads on the tail of the tiger. Caution and circumspection lead ultimately to good fortune."
                l5="Resolute conduct. Perseverance with awareness of danger."
                l6="Look to your conduct and weigh the favorable signs. When everything is fulfilled, supreme good fortune comes."
            ==
        :-  ~[1 1 1 0 0 0]
            :*
                num=11
                hc="䷊"
                nom="Advance"
                c="泰"
                jud="Peace. The small departs, The great approaches. Good fortune. Success."
                img="Heaven and earth unite: Thus the ruler divides and completes the course of heaven and earth, and so aids the people."
                l1="When ribbon grass is pulled up, the sod comes with it. Each according to his kind. Undertakings bring good fortune."
                l2="Bearing with the uncultured in gentleness, fording the river with resolution, not neglecting what's distant, not regarding one's companions: Thus one may manage to walk in the middle."
                l3="No plain not followed by a slope. No going not followed by a return. He who remains persevering in danger is without blame. Do not complain about this truth; Enjoy the good fortune you still possess."
                l4="He flutters down, not boasting of his wealth, together with his neighbor, guileless and sincere."
                l5="The sovereign I gives his daughter in marriage. And supreme good fortune."
                l6="The wall falls back into the moat. Use no army now. Make your commands known within your own town. Perseverance brings humiliation."
            ==
        :-  ~[0 0 0 1 1 1]
            :*
                num=12
                hc="䷋"
                nom="Hindrance"
                c="否"
                jud="Standstill. Evil people don't further the perseverance of the superior man. The great departs; the small approaches."
                img="Heaven and earth don't unite: The image of STANDSTILL. Thus the superior man falls back on his inner worth in order to escape the difficulties."
                l1="When ribbon grass is pulled up, the sod comes with it. Each according to his kind. Perseverance brings good fortune and success."
                l2="They bear and endure; This means good fortune for inferior people. The standstill serves to help the great man to attain success."
                l3="They bear shame."
                l4="He who acts at the command of the highest remains without blame. Those of like mind partake of the blessing."
                l5="Standstill is giving way. Good fortune for the great man. What if it should fail, what if it should fail? In this way he ties it to a cluster of mulberry shoots."
                l6="The standstill comes to an end. First standstill, then good fortune."
            ==
        :-  ~[1 0 1 1 1 1]
            :*
                num=13
                hc="䷌"
                nom="Seeking Harmony"
                c="同人"
                jud="Fellowship with men in the open. Success. It furthers one to cross the great water. The perseverance of the superior man furthers."
                img="Heaven together with fire: Thus the superior man organizes the clans and makes distinctions between things."
                l1="Fellowship with men at the gate. No blame."
                l2="Fellowship with men in the clan. Humiliation."
                l3="He hides weapons in the thicket; He climbs the high hill in front of it. For three years he doesn't rise up."
                l4="He climbs up on his wall; he can't attack. Good fortune."
                l5="Men bound in fellowship first weep and lament, but afterward they laugh. After great struggles they succeed in meeting."
                l6="Fellowship with men in the meadow. No remorse."
            ==
        :-  ~[1 1 1 1 0 1]
            :*
                num=14
                hc="䷍"
                nom="Great Harvest"
                c="大有"
                jud="Possession in great measure. Supreme success."
                img="Fire in heaven above: Thus the superior man curbs evil and furthers good, and thereby obeys the benevolent will of heaven."
                l1="No relationship with what's harmful; There's no blame in this. If one remains conscious of difficulty, one remains without blame."
                l2="A big wagon for loading. One may undertake something. No blame."
                l3="A prince offers it to the Son of Heaven. A petty man can't do this."
                l4="He makes a difference between himself and his neighbor. No blame."
                l5="He whose truth is accessible, yet dignified, has good fortune."
                l6="He's blessed by heaven. Good fortune. Nothing that doesn't further."
            ==
        :-  ~[0 0 1 0 0 0]
            :*
                num=15
                hc="䷎"
                nom="Humbleness"
                c="謙"
                jud="Modesty creates success. The superior man carries things through."
                img="Within the earth, a mountain: Thus the superior man reduces that which is too much, and augments that which is too little. He weighs things and makes them equal."
                l1="A superior man modest about his modesty may cross the great water. Good fortune."
                l2="Modesty that comes to expression. Perseverance brings good fortune. Out of the fullness of the heart the mouth speaks."
                l3="A superior man of modesty and merit carries things to conclusion. Good fortune."
                l4="Nothing that wouldn't further modesty in movement."
                l5="No boasting of wealth before one's neighbor. It's favorable to attack with force. Nothing that wouldn't further."
                l6="Modesty that comes to expression. It's favorable to set armies marching to chastise one's own city and one's country."
            ==
        :-  ~[0 0 0 1 0 0]
            :*
                num=16
                hc="䷏"
                nom="Delight"
                c="豫"
                jud="Enthusiasm. It furthers one to install helpers and to set armies marching."
                img="Thunder comes resounding out of the earth: Thus the ancient kings made music in order to honor merit, and offered it with splendor to the Supreme Deity, inviting their ancestors to be present."
                l1="Enthusiasm that expresses itself brings misfortune."
                l2="Firm as a rock. Not a whole day. Perseverance brings good fortune."
                l3="Enthusiasm that looks upward creates remorse. Hesitation brings remorse."
                l4="The source of enthusiasm. He achieves great things. Doubt not. You gather friends around you as a hair clasp gathers the hair."
                l5="Persistently ill, and still doesn't die."
                l6="Deluded enthusiasm. But if after completion one changes, there's no blame."
            ==
        :-  ~[1 0 0 1 1 0]
            :*
                num=17
                hc="䷐"
                nom="Following"
                c="隨"
                jud="Following has supreme success. Perseverance furthers. No blame."
                img="Thunder in the middle of the lake: Thus the superior man at nightfall goes indoors for rest and recuperation. In the autumn electricity withdraws into the earth again and rests."
                l1="The standard is changing. Perseverance brings good fortune. To go out of the door in company produces deeds."
                l2="If one clings to the little boy, One loses the strong man."
                l3="If one clings to the strong man, one loses the little boy. Through following one finds what one seeks. It furthers one to remain persevering."
                l4="Following creates success. Perseverance brings misfortune. To go one's way with sincerity brings clarity. How could there be blame in this?"
                l5="Sincere in the good. Good fortune."
                l6="He meets with firm allegiance and is still further bound. The king introduces him to the Western Mountain."
            ==
        :-  ~[0 1 1 0 0 1]
            :*
                num=18
                hc="䷑"
                nom="Remedying"
                c="蠱"
                jud="Work on what has been spoiled has supreme success. It furthers one to cross the great water. Before the starting point, three days. After the starting point, three days."
                img="The wind blows slow on the mountain: Thus the superior man stirs up the people and strengthens their spirit."
                l1="Setting right what has been spoiled by the father. If there's a son, no blame rests on the departed father. Danger. In the end good fortune."
                l2="Setting right what has been spoiled by the mother. One must not be too persevering."
                l3="Setting right what has been spoiled by the father. There will be little remorse. No great blame."
                l4="Tolerating what has been spoiled by the father. In continuing one sees humiliation."
                l5="Setting right what has been spoiled by the father. One meets with praise."
                l6="He doesn't serve kings and princes, sets himself higher goals."
            ==
        :-  ~[1 1 0 0 0 0]
            :*
                num=19
                hc="䷒"
                nom="Approaching"
                c="臨"
                jud="Approach has supreme success. Perseverance furthers. When the eighth month comes, there will be misfortune."
                img="The earth above the lake: Thus the superior man is inexhaustible in his will to teach, and without limits in his tolerance and protection of the people."
                l1="Joint approach. Perseverance brings good fortune."
                l2="Joint approach. Good fortune. Everything furthers."
                l3="Comfortable approach. Nothing that would further. If one is induced to grieve over it, one becomes free of blame."
                l4="Complete approach. No blame."
                l5="Wise approach. This is right for a great prince. Good fortune."
                l6="Great hearted approach. Good-hearted approach. Good fortune. No blame."
            ==
        :-  ~[0 0 0 0 1 1]
            :*
                num=20
                hc="䷓"
                nom="Watching"
                c="觀"
                jud="Contemplation. The ablution has been made, but not yet the offering. Full of trust they look up to him."
                img="The wind blows over the earth: Thus the kings of old visited the regions of the world, contemplated the people, and gave them instruction."
                l1="Boy like contemplation. For an inferior man, no blame. For a superior man, humiliation."
                l2="Contemplation through the crack of the door. Furthering for the perseverance of a woman."
                l3="Contemplation of my life decides the choice between advance and retreat."
                l4="Contemplation of the light of the kingdom. It furthers one to exert influence as the guest of a king."
                l5="Contemplation of my life. The superior man is without blame."
                l6="Contemplation of his life. The superior man is without blame."
            ==
        :-  ~[1 0 0 1 0 1]
            :*
                num=21
                hc="䷔"
                nom="Eradicating"
                c="噬嗑"
                jud="Biting Through has success. It's favorable to let justice be administered."
                img="Thunder and lightning: Thus the kings of former times made firm the laws through clearly defined penalties."
                l1="His feet are fastened in the stocks, So that his toes disappear. No blame."
                l2="Bites through tender meat, So that his nose disappears. No blame."
                l3="Bites on old dried meat and strikes on something poisonous. Slight humiliation. No blame."
                l4="Bites on dried gristly meat. Receives metal arrows. It furthers one to be mindful of difficulties and to be persevering. Good fortune."
                l5="The influence shows itself in the back of the neck. No remorse."
                l6="The influence shows itself in the jaws, cheeks, and tongue."
            ==
        :-  ~[1 0 1 0 0 1]
            :*
                num=22
                hc="䷕"
                nom="Adorning"
                c="賁"
                jud="Grace has success. In small matters it's favorable to undertake something."
                img="Fire at the foot of the mountain: Thus does the superior man proceed when clearing up current affairs. But he dare not decide controversial issues in this way."
                l1="He lends grace to his toes, leaves the carriage, and walks."
                l2="Lends grace to the beard on his chin."
                l3="Graceful and moist. Constant perseverance brings good fortune."
                l4="Grace or simplicity? A white horse comes as if on wings. He's not a robber, he will woo at the right time."
                l5="Grace in the hills and gardens. The roll of silk is meager and small. Humiliation, but in the end good fortune."
                l6="Simple grace. No blame."
            ==
        :-  ~[0 0 0 0 0 1]
            :*
                num=23
                hc="䷖"
                nom="Falling Away"
                c="剝"
                jud="Splitting apart. It doesn't further one to go anywhere."
                img="The mountain rests on the earth: Thus those above can ensure their position only by giving generously to those below."
                l1="The leg of the bed is split. Those who persevere are destroyed. Misfortune."
                l2="The bed is split at the edge. Those who persevere are destroyed. Misfortune."
                l3="He splits with them. No blame."
                l4="The bed is split up to the skin. Misfortune."
                l5="A shoal of fishes. Favor comes through the court ladies. Everything acts to further."
                l6="There's a large fruit still uneaten. The superior man receives a carriage. The house of the inferior man is split apart."
            ==
        :-  ~[1 0 0 0 0 0]
            :*
                num=24
                hc="䷗"
                nom="Turning Back"
                c="復"
                jud="Return. Success. Going out and coming in without error. Friends come without blame. To and fro goes the way. On the seventh day comes return. It furthers one to have somewhere to go."
                img="Thunder within the earth: Thus the kings of antiquity closed the passes at the time of solstice. Merchants and strangers didn't go about, and the ruler didn't travel through the provinces."
                l1="Return from a short distance. No need for remorse. Great good fortune."
                l2="Quiet return. Good fortune."
                l3="Repeated return. Danger. No blame."
                l4="Walking in the midst of others, one returns alone."
                l5="Noble-hearted return. No remorse."
                l6="Missing the return. Misfortune. Misfortune from within and without. If armies are set marching in this way, one will in the end suffer a great defeat, disastrous for the ruler of the country. For ten years it won't be possible to attack again."
            ==
        :-  ~[1 0 0 1 1 1]
            :*
                num=25
                hc="䷘"
                nom="Without Falsehood"
                c="無妄"
                jud="Innocence. Supreme success. Perseverance furthers. If someone isn't as he should be, He has misfortune, And it doesn't further him To undertake anything."
                img="Under heaven thunder rolls: All things attain the natural state of innocence. Thus the kings of old, Rich in virtue, and in harmony with the time, Fostered and nourished all beings."
                l1="Innocent behavior brings good fortune. The original impulses of the heart are always good, so that we may follow them confidently, assured of good fortune and achievement of our aims."
                l2="If one doesn't count on the harvest while plowing, nor on the use of the ground while clearing it, It furthers one to undertake something. We should do every task for its own sake as time and place demand and not with an eye to the result. Then each task turns out well, and anything we undertake succeeds."
                l3="Undeserved misfortune. The cow that was tethered by someone Is the wanderer's gain, the citizen's loss. Sometimes undeserved misfortune befalls a man at the hands of another, as for instance when someone passes by and takes a tethered cow along with him. His gain is the owner's loss. In all transactions, no matter how innocent, we must accommodate ourselves to the demands of the time, otherwise unexpected misfortune overtakes us."
                l4="He who can be persevering Remains without blame. We can't lose what really belongs to us, even if we throw it away. Therefore we need have no anxiety. All that need concern us is that we should remain true to our own natures and not listen to others."
                l5="Use no medicine in an illness Incurred through no fault of your own. It will pass of itself. An unexpected evil may come accidentally from without. If it doesn't originate in one's own nature or have a foothold there, one shouldn't resort to external means to eradicate it, but should quietly let nature take its course. Then improvement will come of itself."
                l6="Innocent action brings misfortune. Nothing furthers. When, in a given situation, the time isn't ripe for further progress, the best thing to do is to wait quietly, without ulterior designs. If one acts thoughtlessly and tries to push ahead in opposition to fate, success won't be achieved."
            ==
        :-  ~[1 1 1 0 0 1]
            :*
                num=26
                hc="䷙"
                nom="Great Accumulation"
                c="大畜"
                jud="The taming power of the great. Perseverance furthers. Not eating at home brings good fortune. It furthers one to cross the great water."
                img="Heaven within the mountain: Thus the superior man acquaints himself with many sayings of antiquity And many deeds of the past, In order to strengthen his character thereby."
                l1="Danger is at hand. It furthers one to desist."
                l2="The axle-trees are taken from the wagon."
                l3="A good horse that follows others. Awareness of danger, With perseverance, furthers. Practice chariot driving and armed defense daily. It furthers one to have somewhere to go."
                l4="The headboard of a young bull. Great good fortune."
                l5="The tusk of a gelded boar. Good fortune."
                l6="One attains the way of heaven. Success."
            ==
        :-  ~[1 0 0 0 0 1]
            :*
                num=27
                hc="䷚"
                nom="Nourishing"
                c="頤"
                jud="The corners of the mouth. Perseverance brings good fortune. Pay heed to the providing of nourishment and to what a man seeks to fill his own mouth with."
                img="At the foot of the mountain, thunder: The image of PROVIDING NOURISHMENT. Thus the superior man is careful of his words and temperate in eating and drinking."
                l1="You let your magic tortoise go, And look at me with the corners of your mouth drooping. Misfortune."
                l2="Turning to the summit for nourishment, Deviating from the path To seek nourishment from the hill. Continuing to do this brings misfortune."
                l3="Turning away from nourishment. Perseverance brings misfortune. Do not act thus for ten years. Nothing serves to further."
                l4="Turning to the summit For provision of nourishment Brings good fortune. Spying about with sharp eyes Like a tiger with insatiable craving. No blame."
                l5="Turning away from the path. To remain persevering brings good fortune. One shouldn't cross the great water."
                l6="The source of nourishment. Awareness of danger brings good fortune. It furthers one to cross the great water."
            ==
        :-  ~[0 1 1 1 1 0]
            :*
                num=28
                hc="䷛"
                nom="Great Exceeding"
                c="大過"
                jud="Preponderance of the Great. The ridge-pole sags to the breaking point. It furthers one to have somewhere to go. Success."
                img="The lake rises above the trees: The image of Preponderance of the Great. Thus the superior man, when he stands alone, is unconcerned, and if he has to renounce the world, he's undaunted."
                l1="To spread white rushes underneath. No blame."
                l2="A dry poplar sprouts at the root. An older man takes a young wife. Everything furthers."
                l3="The ridge-pole sags to the breaking point. Misfortune."
                l4="The ridge-pole is braced. Good fortune. If there are ulterior motives, it's humiliating."
                l5="A withered poplar puts forth flowers. An older woman takes a husband. No blame. No praise."
                l6="One must go through the water. It goes over one's head. Misfortune. No blame."
            ==
        :-  ~[0 1 0 0 1 0]
            :*
                num=29
                hc="䷜"
                nom="Darkness"
                c="坎"
                jud="The Abysmal repeated. If you're sincere, you have success in your heart, and whatever you do succeeds."
                img="Water flows on uninterruptedly and reaches its goal: The image of the Abysmal repeated. Thus the superior man walks in lasting virtue and carries on the business of teaching."
                l1="Six at the beginning means: Repetition of the Abysmal. In the abyss one falls into a pit. Misfortune."
                l2="The abyss is dangerous. One should strive to attain small things only."
                l3="Forward and backward, abyss on abyss. In danger like this, pause at first and wait, otherwise you will fall into a pit in the abyss. Do not act this way."
                l4="A jug of wine, a bowl of rice with it; Earthen vessels simply handed in through the Window. There's certainly no blame in this."
                l5="The abyss isn't filled to overflowing, it's filled only to the rim. No blame."
                l6="Bound with cords and ropes, shut in between thorn-hedged prison walls: For three years one doesn't find the way. Misfortune."
            ==
        :-  ~[1 0 1 1 0 1]
            :*
                num=30
                hc="䷝"
                nom="Brightness"
                c="離"
                jud="The Clinging. Perseverance furthers. It brings success. Care of the cow brings good fortune."
                img="That which is bright rises twice: Thus the great man, by perpetuating this brightness, illumines the four quarters of the world."
                l1="The footprints run criss-cross. If one is seriously intent, no blame."
                l2="Yellow light. Supreme good fortune."
                l3="In the light of the setting sun, men either beat the pot and sing or loudly bewail the approach of old age. Misfortune."
                l4="Its coming is sudden; It flames up, dies down, is thrown away."
                l5="Tears in floods, sighing and lamenting. Good fortune."
                l6="The king used him to march forth and chastise. Then it's best to kill the leaders and take captive the followers. No blame."
            ==
        :-  ~[0 0 1 1 1 0]
            :*
                num=31
                hc="䷞"
                nom="Mutual Influence"
                c="咸"
                jud="Influence. Success. Perseverance furthers. To take a maiden to wife brings good fortune."
                img="A lake on the mountain: Thus the superior man encourages people to approach him by his readiness to receive them."
                l1="The influence shows itself in the big toe."
                l2="The influence shows itself in the calves of the legs. Misfortune. Tarrying brings good fortune."
                l3="The influence shows itself in the thighs. Holds to that which follows it. To continue is humiliating."
                l4="Perseverance brings good fortune. Remorse disappears. If a man is agitated in mind, and his thoughts go hither and thither, only those friends on whom he fixes his conscious thoughts will follow."
                l5="The influence shows itself in the back of the neck. No remorse."
                l6="The influence shows itself in the jaws, cheeks, and tongue."
            ==
        :-  ~[0 1 1 1 0 0]
            :*
                num=32
                hc="䷟"
                nom="Long Lasting"
                c="恆"
                jud="Duration. Success. No blame. Perseverance furthers. It furthers one to have somewhere to go."
                img="Thunder and wind: Thus the superior man stands firm and doesn't change has direction."
                l1="Seeking duration too hastily brings misfortune persistently. Nothing that would further."
                l2="Remorse disappears."
                l3="He who doesn't give duration to his character meets with disgrace. Persistent humiliation."
                l4="No game in the field."
                l5="Giving duration to one's character through perseverance. This is good fortune for a woman, misfortune for a man."
                l6="Restlessness as an enduring condition brings misfortune."
            ==
        :-  ~[0 0 1 1 1 1]
            :*
                num=33
                hc="䷠"
                nom="Retreat"
                c="遯"
                jud="Retreat. Success. In what's small, perseverance furthers."
                img="Mountain under heaven: Thus the superior man keeps the inferior man at a distance, not angrily but with reserve."
                l1="At the tail in retreat. This is dangerous.One must not wish to undertake anything."
                l2="He holds him fast with yellow ox-hide. No one can tear him loose."
                l3="A halted retreat is nerve-wracking and dangerous. To retain people as men and maid servants brings good fortune."
                l4="Voluntary retreat brings good fortune to the superior man and downfall to the inferior man."
                l5="Friendly retreat. Perseverance brings good fortune."
                l6="Cheerful retreat. Everything serves to further."
            ==
        :-  ~[1 1 1 1 0 0]
            :*
                num=34
                hc="䷡"
                nom="Great Strength"
                c="大壯"
                jud="The power of the great. Perseverance furthers."
                img="Thunder in heaven above: Thus the superior man doesn't tread on paths that don't accord with established order."
                l1="Power in the toes. Continuing brings misfortune. This is certainly true."
                l2="Perseverance brings good fortune."
                l3="The inferior man works through power. The superior man doesn't act thus. To continue is dangerous. A goat butts against a hedge and gets its horns entangled."
                l4="Perseverance brings good fortune. Remorse disappears. The hedge opens; there's no entanglement. Power depends on the axle of a big cart."
                l5="Loses the goat with ease. No remorse."
                l6="A goat butts against a hedge. It can't go backward, it can't go forward. Nothing serves to further."
            ==
        :-  ~[0 0 0 1 0 1]
            :*
                num=35
                hc="䷢"
                nom="Proceeding Forward"
                c="晉"
                jud="Progress. The powerful prince is honored with horses in large numbers. In a single day he's granted audience three times."
                img="The sun rises over the earth: The image of PROGRESS. Thus the superior man himself brightens his bright virtue."
                l1="Progressing, but turned back. Perseverance brings good fortune. If one meets with no confidence, one should remain calm. No mistake."
                l2="Progressing, but in sorrow. Perseverance brings good fortune. Then one obtains great happiness from one's ancestress."
                l3="All are in accord. Remorse disappears."
                l4="Progress like a hamster. Perseverance brings danger."
                l5="Remorse disappears. Take not gain and loss to heart. Undertakings bring good fortune. Everything serves to further."
                l6="Making progress with the horns is permissible only for the purpose of punishing one's own city. To be conscious of danger brings good fortune. No blame. Perseverance brings humiliation."
            ==
        :-  ~[1 0 1 0 0 0]
            :*
                num=36
                hc="䷣"
                nom="Brilliance Injured"
                c="明夷"
                jud="Darkening of the light. In adversity it furthers one to be persevering."
                img="The light has sunk into the earth: Thus does the superior man live with the great mass: He veils his light, yet still shines."
                l1="Darkening of the light during flight. He lowers his wings. The superior man doesn't eat for three days on his wanderings. But he has somewhere to go. The host has occasion to gossip about him."
                l2="Darkening of the light injures him in the left thigh. He gives aid with the strength of a horse. Good fortune."
                l3="Darkening of the light during the hunt in the south. Their great leader is captured. One must not expect perseverance too soon."
                l4="He penetrates the left side of the belly. One gets at the very heart of the darkening of the light."
                l5="Darkening of the light as with Prince Chi. Perseverance furthers."
                l6="Not light but darkness. First he climbed up to heaven, then plunged into the depths of the earth."
            ==
        :-  ~[1 0 1 0 1 1]
            :*
                num=37
                hc="䷤"
                nom="Household"
                c="家人"
                jud="The Family. The perseverance of the woman furthers."
                img="Wind comes forth from fire: Thus the superior man has substance in his words and duration in his way of life."
                l1="Firm seclusion within the family. Remorse disappears."
                l2="She shouldn't follow her whims. She must attend within to the food. Perseverance brings good fortune."
                l3="When tempers flare up in the family, too great severity brings remorse. Good fortune nonetheless. When woman and child dally and laugh it leads in the end to humiliation."
                l4="She's the treasure of the house. Great good fortune."
                l5="As a king he approaches his family. Fear not. Good fortune."
                l6="His work commands respect. In the end good fortune comes."
            ==
        :-  ~[1 1 0 1 0 1]
            :*
                num=38
                hc="䷥"
                nom="Diversity"
                c="睽"
                jud="Opposition. In small matters, good fortune."
                img="Above, fire; below, The lake: Thus amid all fellowship the superior man retains his individuality."
                l1="Remorse disappears. If you lose your horse, don't run after it; it will come back of its own accord. When you see evil people, guard yourself against mistakes."
                l2="One meets his lord in a narrow street. No blame."
                l3="One sees the wagon dragged back, the oxen halted, a man's hair and nose cut off. Not a good beginning, but a good end."
                l4="Isolated through opposition, one meets a like-minded man with whom one can associate in good faith. Despite the danger, no blame."
                l5="Remorse disappears. The companion bites his way through the wrappings. If one goes to him, how could it be a mistake?."
                l6="Isolated through opposition, one sees one's companion as a pig covered with dirt, as a wagon full of devils. First one draws a bow against him, then one lays the bow aside."
            ==
        :-  ~[0 0 1 0 1 0]
            :*
                num=39
                hc="䷦"
                nom="Hardship"
                c="蹇"
                jud="Obstruction. The south-west furthers. The north-east doesn't further. It furthers one to see the great man. Perseverance brings good fortune."
                img="Water on the mountain: Thus the superior man turns his attention to himself and molds his character."
                l1="Going leads to obstructions, coming meets with praise."
                l2="The King's servant is beset by obstruction on obstruction, but it's not his own fault."
                l3="Going leads to obstructions; hence he comes back."
                l4="Going leads to obstructions, coming leads to union."
                l5="In the midst of the greatest obstructions, friends come."
                l6="Going leads to obstructions, coming leads to great good fortune. It furthers one to see the great man."
            ==
        :-  ~[0 1 0 1 0 0]
            :*
                num=40
                hc="䷧"
                nom="Relief"
                c="解"
                jud="Deliverance. The south-west furthers. If there's no longer anything where one has to go, return brings good fortune. If there's still something where one has to go, hastening brings good fortune."
                img="Thunder and rain set in: Thus the superior man pardons mistakes and forgives misdeeds."
                l1="Without blame."
                l2="One kills three foxes in the field and receives a yellow arrow. Perseverance brings good fortune."
                l3="If a man carries a burden on his back and nonetheless rides in a carriage, he thereby encourages robbers to draw near. Perseverance leads to humiliation."
                l4="Deliver yourself from your great toe. Then the companion comes, And him you can trust."
                l5="If only the superior man can deliver himself, It brings good fortune. Thus he proves to inferior men that he's in earnest."
                l6="The prince shoots at a hawk on a high wall. He kills it. Everything serves to further."
            ==
        :-  ~[1 1 0 0 0 1]
            :*
                num=41
                hc="䷨"
                nom="Decrease"
                c="損"
                jud="Decrease combined with sincerity brings about supreme good fortune without blame. One may be persevering in this. It furthers one to undertake something. How is this to be carried out? One may use two small bowls for the sacrifice."
                img="At the foot of the mountain, the lake: Thus the superior man controls his anger And restrains his instincts."
                l1="Going quickly when one's tasks are finished is without blame. But one must reflect on how much one may decrease others."
                l2="Perseverance furthers. To undertake something brings misfortune. Without decreasing oneself, one is able to bring increase to others."
                l3="When three people journey together, their number decreases by one. When one man journeys alone, he finds a companion."
                l4="If a man decreases his faults, it makes the other hasten to come and rejoice. No blame."
                l5="Someone does indeed increase him. Ten pairs of tortoises can't oppose it. Supreme good fortune."
                l6="If one is increased without depriving others, there's no blame. Perseverance brings good fortune. It furthers one to undertake something. One obtains servants but no longer has a separate home."
            ==
        :-  ~[1 0 0 0 1 1]
            :*
                num=42
                hc="䷩"
                nom="Increase"
                c="益"
                jud="Increase. It furthers one to undertake something. It furthers one to cross the great water."
                img="Wind and thunder: Thus the superior man: If he sees good, he imitates it; If he has faults, he rids himself of them."
                l1="It furthers one to accomplish great deeds. Supreme good fortune. No blame."
                l2="Someone does indeed increase him; Ten pairs of tortoises can't oppose it. Constant perseverance brings good fortune. The king presents him before God. Good fortune."
                l3="One is enriched through unfortunate events. No blame, if you're sincere and walk in the middle, and report with a seal to the prince."
                l4="If you walk in the middle and report the prince, he will follow. It furthers one to be used in the removal of the capital."
                l5="If in truth you have a kind heart, ask not. Supreme good fortune. Truly, kindness will be recognized as your virtue."
                l6="He brings increase to no one. Indeed, someone even strikes him. He doesn't keep his heart constantly steady. Misfortune."
            ==
        :-  ~[1 0 0 0 0 0]
            :*
                num=43
                hc="䷪"
                nom="Breakthrough"
                c="夬"
                jud="Break-through. One must resolutely make the matter known at the court of the king. It must be announced truthfully. Danger. It's necessary to notify one's own city. It doesn't further to resort to arms. It furthers one to undertake something."
                img="The lake has risen up to heaven: Thus the superior man dispenses riches downward and refrains from resting on his virtue."
                l1="Mighty in the forward-striding toes. When one goes and isn't equal to the task, one makes a mistake."
                l2="A cry of alarm. Arms at evening and at night. Fear nothing."
                l3="To be powerful in the cheekbones brings misfortune. The superior man is firmly resolved. He walks alone and is caught in the rain. He's bespattered, and people murmur against him. No blame."
                l4="There's no skin on his thighs, and walking comes hard. If a man were to let himself be led like a sheep, remorse would disappear. But if these words are heard they won't be believed."
                l5="In dealing with weeds, firm resolution is necessary. Walking in the middle remains free of blame."
                l6="No cry. In the end misfortune comes."
            ==
        :-  ~[0 1 1 1 1 1]
            :*
                num=44
                hc="䷫"
                nom="Encountering"
                c="姤"
                jud="Coming to meet. The maiden is powerful. One shouldn't marry such a maiden."
                img="Under heaven, wind: Thus does the prince act when disseminating his commands and proclaiming them to the four quarters of heaven."
                l1="It must be checked with a brake of bronze. Perseverance brings good fortune. If one lets it take its course, one experiences misfortune. Even a lean pig has it in him to rage around."
                l2="There's a fish in the tank. No blame. Does not further guests."
                l3="There's no skin on his thighs, and walking comes hard. If one is mindful of the danger, no great mistake is made."
                l4="No fish in the tank. This leads to misfortune."
                l5="A melon covered with willow leaves. Hidden lines. Then it drops down to one from heaven."
                l6="He comes to meet with his horns. Humiliation. No blame."
            ==
        :-  ~[0 0 0 1 1 0]
            :*
                num=45
                hc="䷬"
                nom="Gathering Together"
                c="萃"
                jud="Gathering together. Success. The king approaches his temple. It furthers one to see the great man. This brings success. Perseverance furthers. To bring great offerings creates good fortune. It furthers one to undertake something."
                img="Over the earth, the lake: Thus the superior man renews his weapons in order to meet the unforeseen."
                l1="If you're sincere, but not to the end, there will sometimes be confusion, sometimes gathering together. If you call out, then after one grasp of the hand you can laugh again. Regret not. Going is without blame."
                l2="Letting oneself be drawn brings good fortune and remains blameless. If one is sincere, it furthers one to bring even a small offering."
                l3="Gathering together amid sighs. Nothing that would further. Going is without blame. Slight humiliation."
                l4="Great good fortune. No blame."
                l5="If in gathering together one has position, this brings no blame. If there are some who are not yet sincerely in the work, sublime and enduring perseverance is needed. Then remorse disappears."
                l6="Lamenting and sighing, floods of tears. No blame."
            ==
        :-  ~[0 1 1 0 0 0]
            :*
                num=46
                hc="䷭"
                nom="Rising"
                c="升"
                jud="Pushing upward has supreme success. One must see the great man. Fear not. Departure toward the south brings good fortune."
                img="Within the earth, wood grows: Thus the superior man of devoted character heaps up small things in order to achieve something high and great."
                l1="Pushing upward that meets with confidence brings great good fortune."
                l2="If one is sincere, it furthers one to bring even a small offering. No blame."
                l3="One pushes upward into an empty city."
                l4="The king offers him Mount Chi. Good fortune. No blame."
                l5="Perseverance brings good fortune. One pushes upward by steps."
                l6="Pushing upward in darkness. It furthers one to be unremittingly persevering."
            ==
        :-  ~[0 1 0 1 1 0]
            :*
                num=47
                hc="䷮"
                nom="Exhaustion"
                c="困"
                jud="Oppression. Success. Perseverance. The great man brings about good fortune. No blame. When one has something to say, it's not believed."
                img="There's not water in the lake: Thus the superior man stakes his life on following his will."
                l1="One sits oppressed under a bare tree and strays into a gloomy valley. For three years one sees nothing."
                l2="One is oppressed while at meat and drink. The man with the scarlet knee bands is just coming. It furthers one to offer sacrifice. To set forth brings misfortune. No blame."
                l3="A man permits himself to be oppressed by stone, and leans on thorns and thistles. He enters the house and doesn't see his wife. Misfortune."
                l4="He comes very quietly, oppressed in a golden carriage. Humiliation, but the end is reached."
                l5="His nose and feet are cut off. Oppression at the hands of the man with the purple knee bands. Joy comes softly. It furthers one to make offerings and libations."
                l6="He's oppressed by creeping vines. He moves uncertainly and says, 'movement brings remorse.' If one feels remorse over this and makes a start, good fortune comes."
            ==
        :-  ~[0 1 1 0 1 0]
            :*
                num=48
                hc="䷯"
                nom="The Well"
                c="井"
                jud="The Well. The town may be changed, but the well can't be changed. It neither decreases nor increases. They come and go and draw from the well. If one gets down almost to the water and the rope doesn't go all the way, or the jug breaks, it brings misfortune."
                img="Water over wood: Thus the superior man encourages the people at their work, and exhorts them to help one another."
                l1="One doesn't drink the mud of the well. No animals come to an old well."
                l2="At the well hole one shoots fishes. The jug is broken and leaks."
                l3="The well is cleaned, but no one drinks from it. This is my heart's sorrow, for one might draw from it. If the king were clear-minded, good fortune might be enjoyed in common."
                l4="The well is being lined. No blame."
                l5="In the well there's a clear, cold spring from which one can drink."
                l6="One draws from the well without hindrance. It's dependable."
            ==
        :-  ~[1 0 1 1 1 0]
            :*
                num=49
                hc="䷰"
                nom="Revolution"
                c="革"
                jud="Revolution. On your own day you are believed. Supreme success, furthering through perseverance. Remorse disappears."
                img="Fire in the lake: Thus the superior man sets the calendar in order and makes the seasons clear."
                l1="Wrapped in the hide of a yellow cow."
                l2="When one's own day comes, one may create revolution. Starting brings good fortune. No blame."
                l3="Starting brings misfortune. Perseverance brings danger. When talk of revolution has gone the rounds three times, one may commit himself, and men will believe him."
                l4="Remorse disappears. Men believe him. Changing the form of government brings good fortune."
                l5="The great man changes like a tiger. Even before he questions the oracle he's believed."
                l6="The superior man changes like a panther. The inferior man molts in the face. Starting brings misfortune. To remain persevering brings good fortune."
            ==
        :-  ~[0 1 1 1 0 1]
            :*
                num=50
                hc="䷱"
                nom="The Cauldron"
                c="鼎"
                jud="The Cauldrom. Supreme good fortune. Success."
                img="Fire over wood: Thus the superior man consolidates his fate by making his position correct."
                l1="A ting with legs upturned. Furthers removal of stagnating stuff. One takes a concubine for the sake of her son. No blame."
                l2="There's food in the ting. My comrades are envious, but they can't harm me. Good fortune."
                l3="The handle of the ting is altered. One is impeded in his way of life. The fat of the pheasant isn't eaten. Once rain falls, remorse is spent. Good fortune comes in the end."
                l4="The legs of the ting are broken. The prince's meal is spilled and his person is soiled. Misfortune."
                l5="The ting has yellow handles, golden carrying rings. Perseverance furthers."
                l6="The ting has rings of jade. Great good fortune. Nothing that wouldn't act to further."
            ==
        :-  ~[1 0 0 1 0 0]
            :*
                num=51
                hc="䷲"
                nom="Thunder"
                c="震"
                jud="Shock brings success. Shock comes - oh, oh! Laughing words - ha, ha! The shock terrifies for a hundred miles, and he doesn't let fall the sacrificial spoon and chalice."
                img="Thunder repeated: Thus in fear and trembling the superior man sets his life in order and examines himself."
                l1="Shock comes - oh, oh! Then follow laughing words - ha, ha! Good fortune."
                l2="Shock comes bringing danger. A hundred thousand times you lose your treasures and must climb the nine hills. Do not go in pursuit of them."
                l3="Shock comes and makes one distraught. If shock spurs to action one remains free of misfortune."
                l4="Shock is mired."
                l5="Shock goes hither and thither. Danger. However, nothing at all is lost. Yet there are things to be done."
                l6="Shock brings ruin and terrified gazing around. Going ahead brings misfortune. If it has not yet touched one's own body but has reached one's neighbor first, there's no blame. One's comrades have something to talk about."
            ==
        :-  ~[0 0 1 0 0 1]
            :*
                num=52
                hc="䷳"
                nom="Mountain"
                c="艮"
                jud="Keeping Still. Keeping his back still so that he no longer feels his body. He goes into his courtyard and doesn't see his people. No blame."
                img="Mountains standing close together: Thus the superior man does not permit his thoughts to go beyond his situation."
                l1="Keeping his toes still. No blame. Continued perseverance furthers."
                l2="Keeping his calves still. He can't rescue him whom he follows. His heart isn't glad."
                l3="Keeping his hips still. Making his sacrum stiff. Dangerous. The heart suffocates."
                l4="Keeping his trunk still. No blame."
                l5="Keeping his jaws still. The words have order. Remorse disappears."
                l6="Noble-hearted keeping still. Good fortune."
            ==
        :-  ~[0 0 1 0 1 1]
            :*
                num=53
                hc="䷴"
                nom="Gradual Progress"
                c="漸"
                jud="Development. The maiden is given in marriage. Good fortune. Perseverance furthers."
                img="On the mountain, a tree: Thus the superior man abides in dignity and virtue, in order to improve the mores."
                l1="The wild goose gradually draws near the shore. The young son is in danger. There's talk. No blame."
                l2="The wild goose gradually draws near the cliff. Eating and drinking in peace and concord. Good fortune."
                l3="The wild goose gradually draws near the plateau. The man goes forth and doesn't return. The woman carries a child but doesn't bring it forth. Misfortune. It furthers one to fight off robbers."
                l4="The wild goose goes gradually, draws near the tree. Perhaps it will find a flat branch. No blame."
                l5="The wild goose gradually draws near the summit. For three years the woman has no child. In the end nothing can hinder her. Good fortune."
                l6="The wild goose gradually draws near the clouds heights. Its feathers can be used for the sacred dance. Good fortune."
            ==
        :-  ~[1 1 0 1 0 0]
            :*
                num=54
                hc="䷵"
                nom="The Maiden"
                c="歸妹"
                jud="The Marrying Maiden. Undertakings bring misfortune. Nothing that would further."
                img="Thunder over the lake: Thus the superior man understands the transitory in the light of the eternity of the end."
                l1="The marrying maiden as a concubine. A lame man who's able to tread. Undertakings bring good fortune."
                l2="A one-eyed man who's able to see. The perseverance of a solitary man furthers."
                l3="The marrying maiden as a slave. She marries as a concubine."
                l4="The marrying maiden draws out the allotted time. A late marriage comes in due course."
                l5="The sovereign I gave his daughter in marriage. The embroidered garments of the princess were not as gorgeous as those of the serving maid. The moon that's nearly full brings good fortune."
                l6="The woman holds the basket, but there are no fruits in it. The man stabs the sheep, but no blood flows. Nothing that acts to further."
            ==
        :-  ~[1 0 1 1 0 0]
            :*
                num=55
                hc="䷶"
                nom="Abundance"
                c="豐"
                jud="Abundance has success. The king attains abundance. Be not sad. Be like the sun at midday."
                img="Both thunder and lightning come: Thus the superior man decides lawsuits and carries out punishments."
                l1="When a man meets his destined ruler, they can be together ten days, and it's not a mistake. Going meets with recognition."
                l2="The curtain is of such fullness that the polestars can be seen at noon. Through going one meets with mistrust and hate. If one rouses him through truth, good fortune comes."
                l3="The underbrush is of such abundance that the small stars can be seen at noon. He breaks his right arm. No blame."
                l4="The curtain is of such fullness that the polestars can be seen at noon. He meets his ruler, who's of like kind. Good fortune."
                l5="Lines are coming, blessing and fame draw near. Good fortune."
                l6="His house is in a state of abundance. He screens off his family. He peers through the gate and no longer perceives anyone. For three years he sees nothing. Misfortune."
            ==
        :-  ~[0 0 1 1 0 1]
            :*
                num=56
                hc="䷷"
                nom="The Wanderer"
                c="旅"
                jud="The Wanderer. Success through smallness."
                img="Fire on the mountain: Thus the superior man is clear-minded and cautious in imposing penalties, and protracts no lawsuits."
                l1="If the wanderer busies himself with trivial things, he draws down misfortune on himself."
                l2="The wanderer comes to an inn. He has his property with him."
                l3="The wanderer's inn burns down. He loses the steadfastness of his young servant. Danger."
                l4="The wanderer rests in a shelter. He obtains his property and an axe. My heart isn't glad."
                l5="He shoots a pheasant. It drops with the first arrow. In the end this brings both praise and office."
                l6="The bird's nest burns up. The wanderer laughs at first, then must needs lament and weep. Through carelessness he loses his cow. Misfortune."
            ==
        :-  ~[0 1 1 0 1 1]
            :*
                num=57
                hc="䷸"
                nom="Wind"
                c="巽"
                jud="The Wanderer. Success through smallness. Perseverance brings good fortune to the wanderer."
                img="Fire on the mountain: Thus the superior man is clear-minded and cautious in imposing penalties, and protracts no lawsuits."
                l1="If the wanderer busies himself with trivial things, he draws down misfortune on himself."
                l2="The wanderer comes to an inn. He has his property with him."
                l3="The wanderer's inn burns down. He loses the steadfastness of his young servant. Danger."
                l4="The wanderer rests in a shelter. He obtains his property and an axe. My heart isn't glad."
                l5="He shoots a pheasant. It drops with the first arrow. In the end this brings both praise and office."
                l6="The bird's nest burns up. The wanderer laughs at first, then must needs lament and weep. Through carelessness he loses his cow. Misfortune."
            ==
        :-  ~[1 1 0 1 1 0]
            :*
                num=58
                hc="䷹"
                nom="Lake"
                c="兌"
                jud="The Joyous. Success. Perseverance is favorable."
                img="Lakes resting one on the other: Thus the superior man joins with his friends for discussion and practice."
                l1="Contented joyousness. Good fortune."
                l2="Sincere joyousness. Good fortune. Remorse disappears."
                l3="Coming joyousness. Misfortune."
                l4="Joyousness that's weighed isn't at peace. After ridding himself of mistakes a man has joy."
                l5="Sincerity toward disintegrating influences is dangerous."
                l6="Seductive joyousness."
            ==
        :-  ~[0 1 0 0 1 1]
            :*
                num=59
                hc="䷺"
                nom="Disintegration"
                c="渙"
                jud="Dispersion. Success. The king approaches his temple. It furthers one to cross the great water. Perseverance furthers."
                img="The wind drives over the water: Thus the kings of old sacrificed to the Lord and built temples."
                l1="He brings help with the strength of a horse. Good fortune."
                l2="At the dissolution he hurries to that which supports him. Remorse disappears."
                l3="He dissolves his self. No remorse."
                l4="He dissolves his bond with his group. Supreme good fortune. Dispersion leads in turn to accumulation. This is something that ordinary men don't think of."
                l5="His loud cries are as dissolving as sweat. Dissolution! A king abides without blame."
                l6="He dissolves his blood. Departing, keeping at a distance, going out, is without blame."
            ==
        :-  ~[1 1 0 0 1 0]
            :*
                num=60
                hc="䷻"
                nom="Limitation"
                c="節"
                jud="Limitation. Success. Galling limitation must not be persevered in."
                img="Water over lake: Thus the superior man creates number and measure, and examines the nature of virtue and correct conduct."
                l1="Not going out of the door and the courtyard is without blame."
                l2="Not going out of the gate and the courtyard brings misfortune."
                l3="He who knows no limitation will have cause to lament. No blame."
                l4="Contented limitation. Success."
                l5="Sweet limitation brings good fortune. Going brings esteem."
                l6="Galling limitation. Perseverance brings misfortune. Remorse disappears."
            ==
        :-  ~[1 1 0 0 1 1]
            :*
                num=61
                hc="䷼"
                nom="Sincerity"
                c="中孚"
                jud="Inner Truth. Pigs and fishes. Good fortune. It furthers one to cross the great water. Perseverance furthers."
                img="Wind over lake: Thus the superior man discusses criminal cases in order to delay executions."
                l1="Being prepared brings good fortune. If there are secret designs, it's disquieting."
                l2="A crane calling in the shade. Its young answers it. I have a good goblet. I will share it with you."
                l3="He finds a comrade. Now he beats the drum, now he stops. Now he sobs, now he sings."
                l4="The moon nearly at the full. The team horse goes astray. No blame."
                l5="He possesses truth, which links together. No blame."
                l6="Cockcrow penetrating to heaven. Perseverance brings misfortune."
            ==
        :-  ~[0 0 1 1 0 0]
            :*
                num=62
                hc="䷽"
                nom="Small Exceeding"
                c="小過"
                jud="Preponderance of the Small. Success. Perseverance furthers. Small things may be done; great things shouldn't be done. The flying bird brings the message: It's not well to strive upward, it's well to remain below. Great good fortune."
                img="Thunder on the mountain: Thus in his conduct the superior man gives preponderance to reverence. In bereavement he gives preponderance to grief. In his expenditures he gives preponderance to thrift."
                l1="The bird meets with misfortune through flying."
                l2="She passes by her ancestor and meets her ancestress. He doesn't reach his prince and meets the official. No blame."
                l3="If one isn't extremely careful, somebody may come up from behind and strike him. Misfortune."
                l4="No blame. He meets him without passing by. Going brings danger. One must be on guard. Do not act. Be constantly persevering."
                l5="Dense clouds, no rain from our western territory."
                l6="He passes him by, not meeting him. The flying bird leaves him. Misfortune. This means bad luck and injury."
            ==
        :-  ~[1 0 1 0 1 0]
            :*
                num=63
                hc="䷾"
                nom="Already Fulfilled"
                c="既濟"
                jud="After Completion. Success in small matters. Perseverance furthers. At the beginning good fortune. At the end disorder."
                img="Water over fire: Thus the superior man takes thought of misfortune and arms himself against it in advance."
                l1="He brakes his wheels. He gets his tail in the water. No blame."
                l2="The woman loses the curtain of her carriage. Do not run after it; on the seventh day you will get it."
                l3="The Illustrious Ancestor disciplines the Devil's Country. After three years he conquers it. Inferior people must not be employed."
                l4="The finest clothes turn to rags. Be careful all day long."
                l5="The neighbor in the east who slaughters an ox does not attain as much real happiness as the neighbor in the west with his small offering."
                l6="He gets his head in the water. Danger."
            ==
        :-  ~[0 1 0 1 0 1]
            :*
                num=64
                hc="䷿"
                nom="Not Yet Fulfilled"
                c="未濟"
                jud="Before Completion. Success. But if the little fox, after nearly completing the crossing, gets his tail in the water, there's nothing that would further."
                img="Fire over water: Thus the superior man is careful in the differentiation of things, so that each finds its place."
                l1="He gets his tail in the water. Humiliating."
                l2="He brakes his wheels. Perseverance brings good fortune."
                l3="Before completion, attack brings misfortune. It furthers one to cross the great water."
                l4="Perseverance brings good fortune. Remorse disappears. Shock, thus to discipline the Devil's Country. For three years, great realms are rewarded."
                l5="Perseverance brings good fortune. No remorse. The light of the superior man is true. Good fortune."
                l6="There's drinking of wine In genuine confidence. No blame. But if one wets his head, he loses it, in truth."
            ==
    ==
    (malt hexkeylist)
--