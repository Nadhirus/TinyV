# RISC-V Verilog Processor

## Vue d'ensemble
Ce projet est une implémentation simple d'un processeur RISC-V utilisant Verilog. Il prend en charge l'ISA (Architecture de Jeu d'Instructions) Integer. L'objectif est de créer un cœur synthétisable sur FPGA optimisé en taille.

## Fonctionnalités
- Implémentation de l'ISA Integer de RISC-V (I)
- Opérations de base de l'ALU
- Fichier de registres
- Récupération et décodage des instructions

## Pour Commencer
### Prérequis
- Simulateur Verilog (par exemple, ModelSim, Icarus Verilog)
- Toolchain RISC-V pour compiler le code assembleur de test

### Cloner le Répertoire
```sh
git clone https://github.com/yourusername/RISCV-Verilog-Processor.git
cd RISCV-Verilog-Processor
```

### Exécuter les Simulations
1. Compiler les fichiers Verilog avec votre simulateur.
2. Charger le banc de test.
3. Exécuter la simulation.

## Structure du Répertoire
```
/RISCV-Verilog-Processor
├── src/                # Fichiers sources
├── testbench/          # Fichiers de banc de test
└── docs/               # Documentation
```

## Contribuer
Les contributions sont les bienvenues ! Veuillez forker le répertoire et créer une pull request.

## Licence
Ce projet est sous licence MIT.

## Remerciements
- [Fondation RISC-V](https://riscv.org/)
- [Verilog HDL](https://en.wikipedia.org/wiki/Verilog)
- *Computer Organization and Design RISC-V Edition: The Hardware Software Interface* (2nd Edition, 11 décembre 2020) par David A. Patterson et John L. Hennessy. ISBN: 9780128203316 (broché), 9780128245583 (eBook)

