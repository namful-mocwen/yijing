::  yijing

:: wip

:: further todo:

:: init entropy
:: public/private
:: cast pals comments
:: charge pals casts like likes but not can be done daily
:: hark
:: cast from pals urbit eny (poke for eny?)
:: remote scry?
:: generators
:: nested core?
:: shas for entropy?
:: chat/groups
:: add update front for real time pals

:: suggestions welcome

/-  *yijing, *pals
/+  *yijing, gossip, default-agent, dbug, agentio

/$  grab-send  %noun  %yijing-send

|%
+$  versioned-state
  $%  state-0
  ==

+$  state-0  [%0 =log]
+$  card  card:agent:gall

+$  cast  [now=@da eny=@ud intention=tape pos=@ud chg=(list @ud) mom=@ud public=@]
--

=|  state-0
=*  state  -

%-  %+  agent:gossip
      [1 %mutuals %mutuals |]
    %-  ~(gas in *(map mark $-(* vase)))
      :~  [%yijing-send |=(n=* !>((grab-send n)))]
      ==

%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    io    ~(. agentio bowl)
:: ::
++  on-init
  ^-  (quip card _this)
  ~&  >  "%yijing installed. . ."
  :_  this
  :~  
      [%pass /pals/leeche %agent [our.bowl %pals] %watch /leeches]
      [%pass /pals/target %agent [our.bowl %pals] %watch /targets]
  ==
  :: `this

:: ::
++  on-save
  ^-  vase
  !>(state)
:: ::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  ~&  >>   [%load vase]
  :_   this(state !<(versioned-state ole))
  :~  
      :: check if subrscribed?
      [%pass /pals/leeche %agent [our.bowl %pals] %watch /leeches]
      [%pass /pals/target %agent [our.bowl %pals] %watch /targets]
  ==
:: ::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ~&  >>>  [%poke mark]
  |^
  ?>  (team:title our.bowl src.bowl)
  ?.  ?=(%yijing-action mark)  (on-poke:def mark vase)
  =/  act  !<(action vase)
  =^  cards  state
    (handle-action act)
  [cards this]
  ::
  ++  handle-action
    |=  act=action
    ^-  (quip card _state)
    ?-    -.act
      %cast
      =/  coins=(list @ud)  (cast6 eny.bowl) 
      :: =/  hexagram  `@ud`(~(rad og eny.bowl) 64)
      =/  pos  (hex-to-num (beinghex coins))
      =/  mom  (hex-to-num (becominghex coins))
      =/  chg  (changing-lines coins)
      ~&  >  [pos mom chg]
      =/  change  `cast`[now.bowl eny.bowl intention.act pos chg mom public.act]
      :_  state(log (~(add ja log) our.bowl change))
      :~  [(fact:io yijing-update+!>([%sngl our.bowl change]) ~[/updates])]
          [(invent:gossip %yijing-send !>([%sngl change]))]
      ==
      :: %del  :: temp solution
      :: [~ state(log (~(del by log) who.act))]
   ==
  --
:: ::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  :: ~&  >>>  [%watch path]
  ::   ~&  >>  [%source src.bowl]
  ::     ~&  >>  [%dap dap.bowl]
  ?+  path  (on-watch:def path)
    [%updates ~]  
      ?.  (team:title our.bowl src.bowl)  
       (on-watch:def path)  `this 
    [%~.~ %gossip %source ~]
      ~&  >>>  [%watch path]
      :_  this
      [%give %fact ~ %yijing-send !>([%mult (~(got by log) our.bowl)])]~
  ==
:: :: 
++  on-peek
  |=  pol=(pole knot)
  ^-  (unit (unit cage))
  ~&  >>  [%peek pol]
  ?>  (team:title our.bowl src.bowl)
  ?+    pol  (on-peek:def pol)
    [%x %log ~]   ``yijing-scry+!>([%log log])
    [%x %log ship=@ ~]
      =/  shp=who  (slav %p ship:pol)
      =/  hashp=(unit casts)   (~(get by log) shp)
      ?~  hashp  ~&  >>>  "yijing: ship {<shp>} not found"  ~
      =/  filtered-casts  (turn ~(tap by u.hashp) |=(a=cast ?:(=(public.a %.y) a ~)))
    ``yijing-scry+!>([%shiplog shp filtered-casts])
    [%x %hexa ~]  
      =/  =hxgrms  (hexagrams)
    ``yijing-scry+!>([%hexa hxgrms])
  ==


++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ~&  >>  [%sign sign]
   ~&  >>  [%wire wire]
  ?+  wire  (on-agent:def wire sign)
      [%~.~ %gossip %gossip ~]
    ?+  -.sign  ~|([%unexpected-gossip-sign -.sign] !!)
          %fact
        ?+   p.cage.sign  (on-agent:def wire sign)
            %yijing-send
          =/  sh  !<(send q.cage.sign)
            ~&  >>>  [%send +.sh]
            ?-    -.sh
                %sngl
              ~&  >>    "%yijing:  new cast {<+.sh>} from {<src.bowl>}"
            `this(log (~(put by log) src.bowl (weld ~[+.sh] (~(gut by log) src.bowl ~))))
                %mult 
              ~&  >>   "%yijing:  new casts {<+.sh>} from {<src.bowl>}"
            `this(log (~(put by log) src.bowl +.sh))
            ==
        ==
      ==
      [%pals *]
      :: pals deleted cannot share same again (gossip lib)
    ?+   -.sign  (on-agent:def wire sign)
          %fact
      ?+   p.cage.sign  (on-agent:def wire sign)
          %pals-effect
        =/  peff  !<(effect q.cage.sign)
        ~&  >>  [%pals "pals agent update: {<peff>}"]
          ?-    -.peff
            ?(%part %away)
            `this(log (~(del by log) +.peff))
            ?(%meet %near)
             `this
        ==
      ==
    ==
  ==

++  on-leave  on-leave:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
