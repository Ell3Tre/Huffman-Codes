%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                          %%
%%                   Huffman Coding Library                 %%
%%                                                          %%
%%            De Angelis Leonardo - Matricola: 914369       %%
%%              Landini Edoardo - Matricola: 914198         %%
%%                         07/03/2025                       %%
%%                                                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Costruzione dell'albero di Huffman            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Funzione principale per la costruzione dell'albero di Huffman.
hucodec_generate_huffman_tree(SymbolsWeights, HuffmanTree) :-
    findall(node(S, W, nil, nil), member([S, W], SymbolsWeights), Leaves),
    Leaves \= [],
    build_tree(Leaves, HuffmanTree).

% Combina iterativamente i nodi della Lista  fino ad ottenere un unico albero.
build_tree([Tree], Tree).
build_tree(NodeList, Tree) :-
    sort_by_weight(NodeList, Sorted),
    Sorted = [N1, N2 | Rest],
    merge_nodes(N1, N2, Merged),
    append(Rest, [Merged], NewList),
    build_tree(NewList, Tree).

% Combina due nodi in un nuovo nodo, sommando i pesi e concatenando i simboli.
merge_nodes(node(S1, W1, L1, R1), node(S2, W2, L2, R2),
            node(S, W, node(S1, W1, L1, R1), node(S2, W2, L2, R2))) :-
    W is W1 + W2,
    atom_concat(S1, S2, S).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 Ordinamento Dei Nodi                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Converte la lista di nodi in una lista di coppie Peso-node
sort_by_weight(NodeList, Sorted) :-
    convert_list_to_pairs(NodeList, Pairs),
    insertion_sort(Pairs, SortedPairs),
    pairs_to_nodes(SortedPairs, Sorted).

% Converte ogni nodo della Lista in una coppia Peso-node.
convert_list_to_pairs([], []).

convert_list_to_pairs(
  [node(S, W, L, R)|Rest],
  [W-node(S, W, L, R)|PairsRest]
) :-
    convert_list_to_pairs(Rest, PairsRest).


% Ordina una lista di coppie Peso-node usando insertion sort.
insertion_sort([], []).
insertion_sort([H|T], Sorted) :-
    insertion_sort(T, SortedTail),
    insert_pair(H, SortedTail, Sorted).

% Inserisce una coppia nella lista già ordinata in base al peso.
insert_pair(P, [], [P]).
insert_pair(W1-node(S1, W1, L1, R1), [W2-node(S2, W2, L2, R2)|Rest],
            [W1-node(S1, W1, L1, R1), W2-node(S2, W2, L2, R2)|Rest]) :-
    W1 =< W2.
insert_pair(W1-node(S1, W1, L1, R1), [H|Rest],
            [H|NewRest]) :-
    H = (W2-node(S2, W2, L2, R2)),
    W1 > W2,
    insert_pair(W1-node(S1, W1, L1, R1), Rest, NewRest).

% Estrae i nodi ordinati dalla lista di coppie.
pairs_to_nodes([], []).
pairs_to_nodes([_-Node|Rest], [Node|NodesRest]) :-
    pairs_to_nodes(Rest, NodesRest).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               Costruzione Tabella SIMBOLO→BIT            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Per ogni simbolo presente nell'albero genera 
% il corrispondente codice binario
hucodec_generate_symbol_bits_table(Tree, Table) :-
    generate_codes(Tree, [], Table).

% Percorre l'albero accumulando il codice binario per ogni simbolo.
generate_codes(node(S, _, nil, nil), Acc, [[S, Code]]) :-
    reverse(Acc, Code).
generate_codes(node(_, _, Left, Right), Acc, Table) :-
    generate_codes(Left, [0|Acc], TableL),
    generate_codes(Right, [1|Acc], TableR),
    append(TableL, TableR, Table).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  Codifica Del Messaggio                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Codifica il messaggio in una lista di bit.
hucodec_encode([], _, []).
hucodec_encode([Symbol|Rest], Tree, Bits) :-
    find_code(Symbol, Tree, Code),
    hucodec_encode(Rest, Tree, RestBits),
    append(Code, RestBits, Bits).

% Trova il codice binario associato a un simbolo scorrendo l'albero.
find_code(Symbol, node(Symbol, _, nil, nil), []).
find_code(Symbol, node(_, _, Left, _), [0|Code]) :-
    find_code(Symbol, Left, Code).
find_code(Symbol, node(_, _, _, Right), [1|Code]) :-
    find_code(Symbol, Right, Code).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  Decodifica Del Messaggio                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Decodifica una lista di bit in un messaggio
hucodec_decode(Bits, Tree, Message) :-
    decode(Bits, Tree, Tree, Message).

% Decodifica i bit scorrendo l'albero fino a trovare un simbolo.
decode([], node(S, _, nil, nil), [S]).
decode(Bits, node(S, _, nil, nil), Tree, [S|Rest]) :-
    Bits \= [],
    decode(Bits, Tree, Tree, Rest).
decode([0|RestBits], node(_, _, Left, _), Tree, Message) :-
    decode(RestBits, Left, Tree, Message).
decode([1|RestBits], node(_, _, _, Right), Tree, Message) :-
    decode(RestBits, Right, Tree, Message).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%              Codifica A Partire Da Un File               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Codifica il contenuto di un file in una lista di bit.
hucodec_encode_file(Filename, HuffmanTree, Bits) :-
    exists_file(Filename),
    !,
    read_file_to_string(Filename, String, []),
    string_chars(String, Chars),
    hucodec_encode(Chars, HuffmanTree, Bits).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                Stampa Dell'Albero Huffman                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Stampa l'albero di Huffman in modo leggibile con indentazione.
hucodec_print_huffman_tree(Tree) :-
    print_tree(Tree, 0).

print_tree(nil, _).
print_tree(node(S, W, nil, nil), Indent) :-
    tab(Indent),
    format("~w (~w)~n", [S, W]).
print_tree(node(_, W, Left, Right), Indent) :-
    tab(Indent),
    format("Node (~w)~n", [W]),
    Next is Indent + 4,
    print_tree(Left, Next),
    print_tree(Right, Next).
