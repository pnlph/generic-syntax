{-# OPTIONS --sized-types #-}

module Generic.Examples.NbyE where

open import Size
open import Data.Bool.Base
open import Data.List.Base
open import Data.Maybe
open import Data.Product
open import Data.Unit
open import Function
open import Relation.Unary
open import Relation.Binary.PropositionalEquality

open import Data.Var using (_─Scoped)
open import Data.Var.Varlike
open import Data.Environment hiding (_$$_)
open import Generic.Syntax
open import Generic.Syntax.UTLC
open import Generic.Semantics.NbyE

private
  variable
    I : Set
    𝓥 𝓒 : I ─Scoped
    σ τ : I



pattern LAM  f   = C (false , f , refl)
pattern APP' f t = (true , f , t , refl)


_$$_ : ∀[ Kripke 𝓥 𝓒 (σ ∷ []) τ ⇒ (𝓥 σ ⇒ 𝓒 τ) ]
f $$ t = extract f (ε ∙ t)

norm^LC : ∀[ Tm UTLC ∞ tt ⇒ Maybe ∘ Tm UTLC ∞ tt ]
norm^LC = norm $ λ where
  (APP' (LAM f) t)  → f $$ t  -- redex
  t                 → C t     -- value

open import Relation.Binary.PropositionalEquality hiding ([_] ; refl)


_ : norm^LC (`app id^U (`app id^U id^U)) ≡ just id^U
_ = refl
