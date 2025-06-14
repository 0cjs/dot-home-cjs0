"   Semantically this is wrong; `where` is not a constant. But it works
"   for my special case where I use black for Keywords, Structure,
"   Statement, Special, etc because I am one of the few people in the
"   world apparently capable of easily remember my programming languages'
"   keywords.
"
"   In the default config vim90/syntax/haskell.vim they have:
"     syn keyword hsStructure class data deriving instance default where
"     hi def link hsStructure Structure
"   (Kinda ridiculous that `data` is Structure but `type` and `newtype`
"   are Typedef.)
"
syn keyword hsEnumConst where
