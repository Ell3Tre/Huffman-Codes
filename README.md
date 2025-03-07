📚 Huffman Coding Library

🚀 Compressione e Decompressione efficiente tramite Codifica di Huffman

Questo repository contiene un progetto realizzato in Prolog e Common Lisp, sviluppato nell'ambito del corso di Laboratorio di Linguaggi di Programmazione presso l'Università degli Studi di Milano-Bicocca (Anno Accademico 2024-2025). Il progetto implementa un sistema completo di compressione e decompressione basato sulla codifica di Huffman, nota per la sua efficienza nella compressione di dati con codici a lunghezza variabile.

👨‍💻 Autori

Leonardo De Angelis (Matricola: 914369)

Edoardo Landini (Matricola: 914198)

🧩 Struttura del progetto

Huffman-Codes/
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

⚙️ Funzionalità principali

🌳 Generazione Alberi di Huffman

Crea automaticamente alberi binari di Huffman partendo da una lista di simboli con i rispettivi pesi (frequenze).

🔢 Codifica

Trasforma qualsiasi messaggio in una sequenza compatta di bit utilizzando l'albero di Huffman generato.

🔍 Decodifica

Ripristina il messaggio originale a partire dalla sequenza binaria codificata.

📂 Codifica diretta da File

Permette di leggere direttamente file testuali e codificarli istantaneamente.

🖥️ Debugging facilitato

Include strumenti per la visualizzazione semplice e intuitiva dell'albero di Huffman generato.

📌 Come usare il progetto

💻 Prolog

Genera albero di Huffman:

?- hucodec_generate_huffman_tree([[a,5],[b,2],[c,1]], Tree).

Codifica messaggio:

?- hucodec_encode([a,b,c,a], Tree, Bits).

Decodifica sequenza di bit:

?- hucodec_decode([0,1,1,0], Tree, Message).

Codifica contenuto di file:

?- hucodec_encode_file('messaggio.txt', Tree, Bits).

Visualizza albero:

?- hucodec_print_huffman_tree(Tree).

🖥️ Common Lisp

Genera albero di Huffman:

(defparameter *tree*
  (hucodec-generate-huffman-tree '((#\a . 5) (#\b . 2) (#\c . 1))))

Codifica messaggio:

(hucodec-encode '(#\a #\b #\c #\a) *tree*)

Decodifica sequenza di bit:

(hucodec-decode '(0 1 1 0) *tree*)

Codifica contenuto di file:

(hucodec-encode-file "messaggio.txt" *tree*)

Visualizza albero:

(hucodec-print-huffman-tree *tree*)

🛠️ Tecnologie utilizzate

Prolog (SWI-Prolog)

Common Lisp (LispWorks o altre implementazioni conformi)

🎓 Risorse

Struttura e Interpretazione dei Programmi per il calcolatore (MIT Press)

🌟 Valutazione

Ancora non valutato

🔗 Per ulteriori informazioni, consulta i singoli README presenti nelle directory Prolog e Lisp.

