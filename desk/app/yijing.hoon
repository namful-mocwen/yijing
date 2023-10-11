/-  *yijing
/+  default-agent, dbug, agentio
|%
+$  versioned-state
  $%  state-0
  ==
:: init=entropy pals
:: public/private
+$  state-0  [%0 =log]
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -  
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
  |=  old-vase=vase
  ^-  (quip card _this)
  `this(state !<(versioned-state old-vase))
:: ::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
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
      =/  change  `cast`[when=now.bowl entropy=eny.bowl intention.act position=hexagram momentum=hexagram]
      :_  state(log (~(add ja log) our.bowl change))
      ~[(fact:io yijing-update+!>(`update`[%share who=our.bowl change]) ~[/updates])]
   ==
  --
:: ::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  ?+  path  (on-watch:def path)
    [%updates ~]  `this
  ==
:: :: 
:: scry for log (map)/shiplog (list)
++  on-peek
  |=  pol=(pole knot)
  ^-  (unit (unit cage))
  ?>  (team:title our.bowl src.bowl)
  ?+    pol  (on-peek:def pol)
    :: [%x %log ~]   ``yijing-scry+!>([%log log)])
    [%x %log ship=@ ~]   ``yijing-scry+!>([%shiplog who=ship:pol casts=(~(get by log) ship:pol)])
  ==

:: ++  on-peek   on-peek:def
:: ::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
