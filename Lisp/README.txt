LP_E2P_HUFFMAN_LISP_202502: Huffman Coding Library in Common Lisp

Componenti del gruppo:
914369 De Angelis Leonardo
914198 Landini Edoardo

Descrizione generale:
Questo progetto consiste in una libreria Common Lisp per la compressione e decompressione di messaggi tramite la codifica di Huffman, basata sull'uso di alberi binari e codici a lunghezza variabile.

Funzionalità principali:
-Creazione di alberi di Huffman partendo da simboli e pesi associati.
-Generazione della tabella simbolo→bit.
-Codifica di messaggi in formato binario.
-Decodifica di sequenze binarie nei messaggi originali.
-Codifica automatica di messaggi contenuti in file testuali.
-Visualizzazione strutturata e leggibile dell'albero di Huffman.

Come usare il programma:

-Generare un albero di Huffman:
(defparameter HT
  (hucodec-generate-huffman-tree '((#\a . 5) (#\b . 2) (#\c . 1))))

-Codificare un messaggio:
(hucodec-encode '(#\a #\b #\c #\a) HT)

-Decodificare una sequenza di bit:
(hucodec-decode '(0 1 1 0) HT)

-Codificare il contenuto di un file:
(hucodec-encode-file "messaggio.txt" HT)

-Visualizzare l'albero di Huffman:
(hucodec-print-huffman-tree HT)

Il nostro progetto è anche su GitHub!
https://github.com/Ell3Tre/Huffman-Codes

Grazie per aver utilizzato la nostra libreria Huffman in Common Lisp!
