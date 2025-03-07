LP_E2P_HUFFMAN_PROLOG_202502: Huffman Coding Library in Prolog

Componenti del gruppo:
914369 De Angelis Leonardo
914198 Landini Edoardo

Descrizione generale:
Il progetto consiste nella realizzazione di una libreria in Prolog per la compressione e decompressione di messaggi tramite la codifica di Huffman. La libreria include predicati per generare alberi di Huffman, codificare e decodificare messaggi e gestire operazioni su file.

Funzionalità principali:

- Costruzione dell'albero di Huffman a partire da coppie simbolo-peso
- Codifica di messaggi in sequenze binarie
- Decodifica di sequenze binarie in messaggi originali
- Gestione della codifica di messaggi letti da file
- Visualizzazione leggibile dell'albero di Huffman per debugging

Come utilizzare il programma:

- Generare un albero di Huffman:
  ?- hucodec_generate_huffman_tree([[a,5],[b,2],[c,1]], HT).

- Codificare un messaggio:
  ?- hucodec_encode([a,b,c,a], HT, Bits).

- Decodificare un messaggio:
  ?- hucodec_decode([0,1,1,0], HT, Message).

- Codificare messaggi da file:
  ?- hucodec_encode_file('messaggio.txt', HT, Bits).

- Stampare l'albero di Huffman:
  ?- hucodec_print_huffman_tree(HT).

Il nostro progetto è anche su GitHub!
https://github.com/Ell3Tre/Huffman-Codes

Grazie per aver utilizzato la nostra libreria Huffman in Prolog!
