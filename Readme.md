# RISC-V Verilog Processor 

## Vue d'ensemble
Ce projet est une implémentation simple d'un processeur RISC-V utilisant Verilog. Il prend en charge l'ISA RV32I. L'objectif est de créer un cœur synthétisable sur FPGA optimisé en taille.

## Fonctionnalités
- Implémentation de l'ISA Integer de RISC-V (RV32I)
- Opérations de base de l'ALU
- Fichier de registres
- Récupération et décodage des instructions

## Structure de core
Le design est basé sur le coeur de professeur Alain Merigot de l'université de Paris-Saclay et des explications de *livre Computer Organization and Design RISC-V Edition*, c'est un coeur riscv 32bit non pipeliné avec une memoire données/instructions unifié.

__Figure 1: RISCV 32bit Core__

![](./Core_design.png)

## Pour Commencer
### Prérequis
- oss-cad-suite pour synthesisez le design et la verification formelle inclus pour chaque element
- Toolchain GNU gcc RISC-V pour compiler le code assembleur de test
- riscv-formal (fait partie de oss-cad-suite) pour verifier formellement l'adherance a l'ISA.

## Structure du Répertoire
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
## Licence
Ce projet est sous licence MIT.

## Remerciements
- Professeur Alain Merigot de l'université Paris-Saclay
- [Fondation RISC-V](https://riscv.org/)
- [Verilog HDL](https://en.wikipedia.org/wiki/Verilog)
- *Computer Organization and Design RISC-V Edition: The Hardware Software Interface* (2nd Edition, 11 décembre 2020) par David A. Patterson et John L. Hennessy. ISBN: 9780128203316 (broché).

