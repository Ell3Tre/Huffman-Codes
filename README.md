# 🗃️ Huffman Coding Library

Questo progetto implementa una libreria in Prolog e Common Lisp per la compressione e decompressione di messaggi tramite la codifica di Huffman, sviluppato nell'ambito del corso di **Linguaggi di Programmazione** presso l'Università degli Studi di Milano-Bicocca (Anno Accademico 2024-2025).

🎓 **Autori:**

- **Leonardo De Angelis** (Matricola: 914369)
- **Edoardo Landini** (Matricola: 914198)

---

## 📂 Struttura del Progetto

```
Huffman_Codes/
│
├── Prolog/
│   ├── huffman-codes.pl
│   └── README.txt
│
├── Lisp/
│   ├── huffman-codes.lisp
│   └── README.txt
│
└── Group.txt
```

---

## 🚀 Funzionalità

### 🌳 Generazione Alberi di Huffman

Crea automaticamente alberi binari di Huffman partendo da simboli e rispettivi pesi (frequenze).

### 📡 Codifica

Trasforma messaggi in una sequenza binaria compressa usando l'albero di Huffman.

### 🔑 Decodifica

Ripristina il messaggio originale a partire da una sequenza binaria codificata.

### 📄 Codifica diretta da File

Permette la lettura diretta da file testuali e la loro codifica immediata in binario.

### 🛠 Debugging facilitato

Fornisce funzioni per visualizzare chiaramente la struttura dell'albero di Huffman.

---

## 📌 Come usare la libreria

### Prolog

- Generazione albero:

```prolog
?- hucodec_generate_huffman_tree([[a,5],[b,2],[c,1]], HT).
```

- Codifica messaggio:

```prolog
?- hucodec_encode([a,b,c,a], HT, Bits).
```

- Decodifica messaggio:

```prolog
?- hucodec_decode([0,1,1,0], HT, Message).
```

- Codifica file:

```prolog
?- hucodec_encode_file('messaggio.txt', HT, Bits).
```

- Stampa albero:

```prolog
?- hucodec_print_huffman_tree(HT).
```

### Common Lisp

- Generazione albero:

```lisp
(defparameter *tree*
  (hucodec-generate-huffman-tree '((#\a . 5) (#\b . 2) (#\c . 1))))
```

- Codifica messaggio:

```lisp
(hucodec-encode '(#\a #\b #\c #\a) HT)
```

- Decodifica messaggio:

```lisp
(hucodec-decode '(0 1 1 0) HT)
```

- Codifica da file:

```lisp
(hucodec-encode-file "messaggio.txt" HT)
```

- Visualizzare albero:

```lisp
(hucodec-print-huffman-tree HT)
```

---

## 🧑‍💻 Tecnologie Utilizzate

- **Prolog** (SWI-Prolog)
- **Common Lisp** (LispWorks o altre implementazioni compatibili)

---

## 🎓 Contesto Accademico

Realizzato per il corso di **Linguaggi di Programmazione** dell'Università degli Studi di Milano-Bicocca (AA 2024-2025).

---

📚 **Riferimenti**

- [Structure and Interpretation of Computer Programs - MIT Press](https://mitpress.mit.edu/sicp)

Grazie per aver visitato questo progetto!

