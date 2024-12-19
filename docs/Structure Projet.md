# Structure Projet
les fichiers de ce projet sont organisé comme décrit ci-dessous

```plaintext
RISV-VERILOG-PROCESSOR/
│
├── src/                # Fichiers source pour les modules Verilog/SystemVerilog
│   ├── core/           # Modules principaux du processeur
│   │   ├── top.sv      # Module principal pour le processeur
│   │   ├── alu.sv      # Unité Arithmétique et Logique (ALU)
│   │   ├── register_file.sv  # Fichier de registres
│   │   ├── control.sv  # Unité de contrôle (décodage des instructions) et Micro-séquenceur / Machine à États Finis
│   │   ├── datapath.sv # Chemin de données reliant ALU, registres, mémoire, etc.
│   │   ├── pc.sv       # Compteur de programme (PC)
│   │   └── types.sv    # contient les types commun entre les différents modules pour meilleur lisibilité
│   │  
│   └── memory/         # Modules liés à la mémoire
│       ├── imem.sv     # Mémoire des instructions (ROM simple)
│       └── dmem.sv     # Mémoire des données
│
├── test/               # Fichiers de bancs d’essai (testbench)
│   ├── alu_tb.sv       # Banc d’essai de l’ALU
│   ├── control_tb.sv   # Banc d’essai de l’unité de contrôle
│   └── memory_tb.sv    # Banc d’essai des modules mémoire
│
├── SBYScripts/                       # Fichiers de bancs d’essai (testbench)
│   └── <nom_de_module>_formal.sby    #script pour la verification formelle de chaque module
│
├── docs/                     # Documentation
│   └── <nom_de_module>.md    # details sur implementation et test de chaque module
│
└── README.md           # Aperçu du projet et instructions pour l'exploitation
```

---

## **Description des Fichiers**

### **Fichiers Source (`src/`)**

#### 1. **Modules Principaux (`src/core/`)**
- **`top.sv`** :
  - Module principal qui instancie tous les sous-modules principaux.
  - Connecte le chemin de données, l'unité de contrôle et les mémoires.
  - Expose les entrées/sorties pour les connexions externes (horloge, réinitialisation, interfaces mémoire).

- **`alu.sv`** :
  - Implémente les opérations arithmétiques et logiques de RV32I (`add`, `sub`, `and`, `or`, `sll`, etc.).
  - Paramétrable pour permettre des extensions futures (par exemple, pour l'extension B).

- **`register_file.sv`** :
  - Implémente les 32 registres généraux (`x0` à `x31`).
  - Applique la règle où `x0` est câblé à `0`.
  - Prend en charge deux ports de lecture et un port d’écriture pour une exécution en un cycle.

- **`control.sv`** :
  - Décode les instructions RISC-V en signaux de contrôle.
  - Combine les fonctions de décodage et la logique de machine à états pour orchestrer l'exécution.

- **`datapath.sv`** :
  - Combine le fichier de registres, l’ALU, le compteur de programme et l’interface mémoire.
  - Implémente les mouvements de données, les branchements et l’accès mémoire conformément aux signaux de contrôle.

- **`pc.sv`** :
  - Implémente la logique du compteur de programme (PC).
  - Prend en charge l’incrémentation, les sauts et les branchements basés sur les entrées de contrôle.

- **`types.sv`** :
  - Contient des définitions de types utilisées dans plusieurs modules pour améliorer la lisibilité et la maintenance du code.


#### 2. **Modules Mémoire (`src/memory/`)**
- **`imem.sv`** :
  - Mémoire des instructions pour récupérer les instructions.
  - Peut être implémentée comme une ROM simple ou un tableau en lecture seule.

- **`dmem.sv`** :
  - Mémoire des données pour les opérations de charge/stockage (`load/store`).
  - Prend en charge les lectures et écritures alignées sur les mots.

---

### **Tests (`test/`)**
- Fournir des bancs d’essai auto-vérifiants pour chaque module à l’aide d’assertions ou de tâches SystemVerilog.
- **`alu_tb.sv`** :
  - Tester les opérations arithmétiques et logiques, y compris les cas limites.
- **`control_tb.sv`** :
  - Valider le décodage des instructions et la génération des signaux de contrôle.
- **`memory_tb.sv`** :
  - Vérifier les lectures/écritures alignées et la gestion des accès mémoire.

---

### **Scripts pour Vérification Formelle (`SBYScripts/`)**
- **`<nom_de_module>_formal.sby`** :
  - Fichiers pour la vérification formelle de chaque module individuel.
  - Utiliser `SymbiYosys` pour vérifier des propriétés telles que l'absence de deadlocks et la conformité aux spécifications.

---

### **Documentation (`docs/`)**
- **`<nom_de_module>.md`** :
  - Inclure des détails sur l'implémentation et les tests de chaque module.
  - Ajouter des diagrammes et des explications pour améliorer la clarté.

---

## **Recommandations Générales**
1. **Pratiques de Codage Propres** :
   - Utiliser des paramètres (`parameter`) pour les valeurs configurables (taille des mots, types d'opérations, etc.).
   - Structurer les modules pour une réutilisation facile.
   - Ajouter des types commun au fichier `types.sv` ou possible.

2. **Synthèse FPGA** :
   - S'assurer que tous les designs sont synthétisables.
