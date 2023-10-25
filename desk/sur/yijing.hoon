::/sur/yijing.hoon

|%
+$  id    @
+$  who   @p
+$  when  @da

+$  intention  @t
+$  position   @ud
+$  momentum   @ud
+$  entropy    @uvj

::  research message structure samples

+$  cast  [=when =entropy =intention =position =momentum]
+$  casts  (list cast)
+$  log  (jar who cast)
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

+$  action
  $%  [%cast =intention]
      :: [%del =who]
  ==

+$  update
  $%  
    ::share log
    [%sngl =who =cast]
    [%mult =who =casts]
  ==

+$  send
  $%  
    ::share log
    [%sngl =cast]
    [%mult =casts]
  ==

+$  scry
  $% 
    [%log =log]
    [%shiplog =who =casts]
  ==
--
