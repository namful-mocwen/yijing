::/sur/yijing.hoon

|%
+$  id    @
+$  who   @p
+$  when  @da

+$  intention  @t
+$  position   @ud
+$  changing   (list @ud)
+$  momentum   @ud
+$  entropy    @uvj

::  research message structure samples


::+$  log  (list cast)

:: search with this 
:: +$  casts  (map id cast)
::  can we get cast by searching ship 
:: ??  +$ shipcasts (map who [cast ~])
:: +$ private map who casts
:: look up by ship 

:: encryption
:: sharing where stored?
:: maybe all shared to start

+$  cast  [=when =entropy =intention =position =changing =momentum]
+$  casts  (list cast)
+$  log  (jar who cast)


+$  element  ?(%heaven %lake %fire %thunder %wind %water %mountain %earth)
+$  name  ?(%qian %dui %li %zhen %xun %kan %gen %kun)
+$  trigram  [element name]
+$  trikey  [(list @ud) trigram]
+$  trilist  (list trikey)
+$  hexlist  (list [(list @ud) @ud])

+$  hexagram  [num=@ud hc=tape nom=tape c=tape jud=tape img=tape l1=tape l2=tape l3=tape l4=tape l5=tape l6=tape]
+$  hxgrms  (map (list @ud) hexagram)

+$  hexkey  [(list @ud) hexagram]
+$  hexkeylist  (list hexkey)  
+$  action
  $%  [%cast =intention]
      :: [%del =who]
  ==

+$  update
  $%  
    [%sngl =who =cast]
    [%mult =who =casts]
  ==

+$  send
  $%  
    [%sngl =cast]
    [%mult =casts]
  ==

+$  scry
  $% 
    [%log =log]
    [%shiplog =who =casts]
    [%hexa =hxgrms]
  ==
--
