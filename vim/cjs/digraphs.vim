" ===== Digraphs =====================================================
"   Input with Ctrl-K followed by two chars.
"   (Ctrl-K space CHAR enters CHAR with high bit set.)
"
"   :digraph takes only decimal values, but you can convert hex in input
"   mode with <C-R>=0xNNNN<CR>.

"   Commonly used digraphs to remember:
"
"      .M ·   1m ○   0M ●       (but see custom digraphs below)
"      OK ✓   /\ ×
"      *X ×   :- ÷
"      FA ∀   TE ∃   AN ∧   OR ∨   .: ∴
"      (- ∈   -) ∋
"      00 ∞

"   -1,-N,-M,NS   hyphen,en-dash,em-dash,nb-space
"   Greek letters end in *: G*‐Γ  g*‐γ
"   Second char s/S = superscript/subscript: 1s=₁ 2S=²
"   Also see: http://www.alecjacobson.com/weblog/?p=443
"
"   Bullet somehow seems to be a regular problem. 0m produces diamonds...
"   Check https://unicode-table.com/en/2022/

"   Built-in digraphs (for documentation)
"        .P 8901    " ·  U+22c5 Dot Operator                        built in
"        .M  183    " ·  U+00b7 Middle Dot (interpunct)             built in
"        0M 9679    " ●  U+25cf Black Circle (not in some fonts)    built in

"   Punctuation
digraph  oo 8226    " •  U+2022 Bullet (built in in Vim ≥8.2)

"   Mathematical Symbols
digraph  ** 0981    " ϕ  U+03D5 Greek Phi Symbol (φ for math/sci contexts)
                    "    `f%` would make more sense, but harder to type.
digraph  xx  215    " ×  Multiplication Sign
digraph  0+ 8853    " ْْࣷ⊕  Circled Plus Operator (overrides Arabic Sukun)
digraph  XO 8891    " ⊻  XOR
digraph  XR 8891    " ⊻  XOR
digraph  NA 8892    " ⊼  NAND
digraph  NR 8893    " ⊽  NOR
digraph \|> 8614    " ↦  Rightwards Arrow From Bar (maplet, \mapsto)
digraph \|- 8866    " ⊢  Right Tack (turnstyle)
digraph -\| 8867    " ⊣  Left Tack
digraph  -T 8868    " ⊤  Down Tack
digraph  -t 8869    " ⊥  Up Tack
digraph \|= 8872    " ⊨  True (double turnstile)
digraph  <m 10216   " ⟨  Mathematical Left Angle Bracket
digraph  >m 10217   " ⟩  Mathematical Right Angle Bracket

"   Graphic and Engineering Symbols
digraph  -^ 8593    " ↑  Upwards Arrow (alternative to -!)
digraph  CR 8629    " ↵  Keyboard Enter or carriage return key symbol
digraph  cm 8984    " ⌘  Place of Interest Sign (Mac Command Key)
digraph  om 8997    " ⌥  Option Key (Mac)
digraph  cl 8452    " ℄ Centre Line Symbol
digraph  D0 8960    " ⌀  Diameter Sign
digraph  DC 9107    " ⎓  Direct Current Symbol Form Two
"   e[a-z]: Electronics symbols (overrides some Bopomofo)
digraph ep 9101     " ⎍ "pulse" Monostable Symbol
digraph eh 9102     " ⎎ Hysteresis Symbol
digraph eg 9178     " ⏚ Electronic/Earth Ground

"   Box Drawing
digraph  !@ 8214    " ‖  Double vertical line (duplicates !2 digraph)
digraph  BC 9587    " ╳　Box Drawing Light Diagonal Cross

"   Superscripts
digraph  dS 7496    " ᵈ  Latin Superscript Small Letter D
digraph  hS 0688    " ʰ  Latin Superscript Small Letter H
digraph  iS 8305    " ⁱ  Latin Superscript Small Letter I
digraph  nS 8319    " ⁿ  Latin Superscript Small Letter N
digraph  oS 7506    " ᵒ  Latin Superscript Small Letter O

"   Subscripts
digraph  bs 7526    " ᵦ  Greek Subscript Small Letter Beta
digraph  is 7522    " ᵢ  Latin Subscript Small Letter I
digraph  ns 8345    " ₙ  Latin Subscript Small Letter N
digraph  xs 8339    " ₓ  Latin Subscript Small Letter X

"   Misc
digraph  '/  773    " a̅  Combining Overbar (like / for "active low")


