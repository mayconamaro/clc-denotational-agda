module Syntax where

infix 4 _⊢_
infix 4 _∋_
infix 5 _,_

data Type : Set where
    γ    : Type
    Z    : Type   --- Zero
    I    : Type   --- One
    _×_  : Type → Type → Type
    _+_  : Type → Type → Type
    T    : Type → Type
    _⇒_  : Type → Type → Type
    
data Context : Set where
    ∅  : Context
    _,_  : Context → Type → Context

data _∋_ : Context → Type → Set where
    here   : ∀ {Γ A} → Γ , A ∋ A
    there  : ∀ {Γ A B} → Γ ∋ A → Γ , B ∋ A

data _⊢_ : Context → Type → Set where
    var   : ∀ {Γ A} → Γ ∋ A → Γ ⊢ A
    abs   : ∀ {Γ A B} → Γ , A ⊢ B → Γ ⊢ A ⇒ B
    app   : ∀ {Γ A B} → Γ ⊢ A ⇒ B 
                          → Γ ⊢ A 
                          → Γ ⊢ B
    top   : ∀ {Γ} → Γ ⊢ I
    bot   : ∀ {Γ A} → Γ ⊢ Z → Γ ⊢ A
    prod  : ∀ {Γ A B} → Γ ⊢ A → Γ ⊢ B → Γ ⊢ A × B
    fst   : ∀ {Γ A B} → Γ ⊢ A × B → Γ ⊢ A
    snd   : ∀ {Γ A B} → Γ ⊢ A × B → Γ ⊢ B
    inl   : ∀ {Γ A B} → Γ ⊢ A → Γ ⊢ A + B
    inr   : ∀ {Γ A B} → Γ ⊢ B → Γ ⊢ A + B
    case  : ∀ {Γ A B C} → Γ ⊢ A + B
                            → Γ , A ⊢ C
                            → Γ , B ⊢ C
                            → Γ ⊢ C
    val   : ∀ {Γ A} → Γ ⊢ A → Γ ⊢ T A
    bind  : ∀ {Γ A B} → Γ ⊢ T A 
                          → Γ , A ⊢ T B 
                          → Γ ⊢ T B
