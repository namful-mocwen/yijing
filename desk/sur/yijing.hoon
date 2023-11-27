::/sur/yijing.hoon
::
:: some names need adjusting
:: some types can be changed
::

|%

+$  who   @p
+$  when  @da

+$  intention  @t
+$  position   @ud
+$  changing   (list @ud)
+$  momentum   @ud
+$  entropy    @uvj
:: +$  charge  map @p @ud

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

+$  rumor   [when=@da what=@t]
+$  rumors  (list rumor)

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
    [%rumors =rumors]
    [%entropy =entropy]
    [%cast =cast]
  ==
--
