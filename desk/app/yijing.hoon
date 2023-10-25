::  yijing

:: wip
:: init entropy
:: public/private
:: nested core?
:: cast pals comments
:: hark
:: cast from pals urbit eny
:: gen
:: shas?

:: pals deleted cannot share same again
:: add update front for real time pals

/-  *yijing, *pals
/+  gossip, default-agent, dbug, agentio

/$  grab-send  %noun  %yijing-send

|%
+$  versioned-state
  $%  state-0
  ==

+$  state-0  [%0 =log]
+$  card  card:agent:gall
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
  `this
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
      :: originally on-init but in case pals added later
      ::will it fail if no pals app? 
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
      =/  hexagram  `@ud`(~(rad og eny.bowl) 64)
      ~&  >  hexagram
      =/  change  `cast`[now.bowl eny.bowl intention.act hexagram hexagram]
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
       ``yijing-scry+!>([%shiplog shp u.hashp])
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
