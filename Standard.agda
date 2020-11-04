open import Utils

module Standard (S : Monad) where
open Monad S
open import Data.Empty using (⊥; ⊥-elim)
open import Data.Unit using (⊤; tt)
import Data.Product as Prod
open import Data.Sum using (_⊎_; inj₁; inj₂) renaming ([_,_] to ⊎-elim)
open import Syntax

⟦_⟧ : Type → Set
⟦ I ⟧     = ⊤
⟦ Z ⟧     = ⊥
⟦ γ ⟧     = ⊥ ---- tipo básico coringa
⟦ A × B ⟧  = ⟦ A ⟧ Prod.× ⟦ B ⟧
⟦ A + B ⟧  = ⟦ A ⟧ ⊎ ⟦ B ⟧
⟦ A ⇒ B ⟧  = ⟦ A ⟧ → ⟦ B ⟧
⟦ T A ⟧    = M ⟦ A ⟧

⟦_⟧C : Context → Set
⟦ ∅ ⟧C      = ⊤
⟦ Γ , A ⟧C  = ⟦ A ⟧ Prod.× ⟦ Γ ⟧C

semVar : ∀ {A Γ} → Γ ∋ A → ⟦ Γ ⟧C → ⟦ A ⟧
semVar (here)     (v Prod., _)  = v
semVar (there v)  env           = semVar v (Prod.proj₂ env)

eval : ∀ {t Γ} → Γ ⊢ t → ⟦ Γ ⟧C → ⟦ t ⟧
eval (var v) env = semVar v env
eval (top) env = tt
eval (bot e) env = ⊥-elim (eval e env)
eval (prod e e') env = eval e env Prod., eval e' env
eval (fst e) env = Prod.proj₁ (eval e env)
eval (snd e) env = Prod.proj₂ (eval e env)
eval (abs e) env = λ z → eval e (z Prod., env)
eval (app e e') env = (eval e env) (eval e' env)
eval (inl e) env = inj₁ (eval e env)
eval (inr e) env = inj₂ (eval e env)
eval (case e e' e'') env = ⊎-elim (λ v → eval e' (v Prod., env))
                                  (λ v → eval e'' (v Prod., env))
                                  (eval e env)
eval (val e) env = return (eval e env)
eval (bind e e') env = eval e env >>= λ v → eval e' (v Prod., env)
