;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                           ;;
;;                   Huffman Coding Library                  ;;
;;                                                           ;;
;;            De Angelis Leonardo - Matricola: 914369        ;;
;;              Landini Edoardo - Matricola: 914198          ;;
;;                         07/03/2025                        ;;
;;                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Funzione per creare un nodo.
(defun make-huffman-node (symbol weight left right)
  (list symbol weight left right))

;; Funzioni per i nodi.
(defun huffman-node-symbol (node)
  (if (consp node) (car node) nil))
(defun huffman-node-weight (node)
  (if (consp node) (cadr node) nil))
(defun huffman-node-left (node)
  (if (consp node) (caddr node) nil))
(defun huffman-node-right (node)
  (if (consp node) (cadddr node) nil))
(defun huffman-node-p (node)
  (and (listp node) (= (length node) 4)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;            Costruzione dell'albero di Huffman             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Funzioni per ordinare i nodi per peso (usando insertion sort).
(defun insert-sorted (node sorted)
  (if (or (null sorted)
          (< (huffman-node-weight node)
             (huffman-node-weight (car sorted))))
      (cons node sorted)
      (cons (car sorted)
            (insert-sorted node (cdr sorted)))))

(defun sort-by-weight (nodes)
  (if (null nodes)
      nil
      (insert-sorted (car nodes) (sort-by-weight (cdr nodes)))))

;; Combina ricorsivamente i nodi per ottenere l'albero.
(defun combine-nodes (nodes)
  (if (null (cdr nodes))
      (car nodes)
      (let* ((sorted (sort-by-weight nodes))
             (node1 (car sorted))
             (rest (cdr sorted))
             (node2 (car rest))
             (rest2 (cdr rest))
             (combined (make-huffman-node nil
                                           (+ (huffman-node-weight node1)
                                              (huffman-node-weight node2))
                                           node1
                                           node2)))
        (combine-nodes (cons combined rest2)))))

;; Costruisce la lista iniziale di nodi a partire dalla lista di coppie
;; (simbolo . peso).
(defun build-nodes (pairs seen)
  (if (null pairs)
      nil
      (let ((entry (car pairs)))
        (if (or (not (consp entry))
                (consp (cdr entry)))
            (error
             "Ogni elemento deve essere (simbolo . peso); trovato ~S"
             entry)
            (let ((sym (car entry))
                  (wgt (cdr entry)))
              (if (not (numberp wgt))
                  (error
                   "Il peso ~S per ~S non è un numero"
                   wgt sym)
                  (if (<= wgt 0)
                      (error
                       "Il peso ~S per ~S non è positivo"
                       wgt sym)
                      (if (member sym seen)
                          (error "Simbolo duplicato ~S " sym)
                          (cons (make-huffman-node sym wgt nil nil)
                                (build-nodes (cdr pairs)
                                             (cons sym seen)))))))))))

;; Funzione principale per generare l'albero di Huffman.
(defun hucodec-generate-huffman-tree (symbols-n-weights)
  (if (not (listp symbols-n-weights))
      (error "Lista di coppie (simbolo . peso) non valida, ottenuto ~S" 
              symbols-n-weights)
      (if (null symbols-n-weights)
          (error "La lista non può essere vuota")
          (combine-nodes (build-nodes symbols-n-weights nil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          Generazione della tabella simbolo->bit           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Funzione ausiliaria per generare la tabella di codifica.
(defun hucodec-traverse (node prefix table)
  (if (huffman-node-symbol node)
      (cons (cons (huffman-node-symbol node) prefix) table)
      (let ((table1 (if (huffman-node-left node)
                        (hucodec-traverse (huffman-node-left node)
                                          (append prefix (list 0))
                                          table)
                        table)))
        (if (huffman-node-right node)
            (hucodec-traverse (huffman-node-right node)
                              (append prefix (list 1))
                              table1)
            table1))))

;; Genera la tabella di codifica (lista di coppie simbolo . lista-di-bit).
(defun hucodec-generate-symbol-bits-table (huffman-tree)
  (if (not (huffman-node-p huffman-tree))
      (error "Albero di Huffman non valido in generate-symbol-bits-table")
      (let ((table (hucodec-traverse huffman-tree '() nil)))
        (if (and table (null (cdr table))) ; se c'è un solo elemento
            (let ((entry (car table)))
              (if (null (cdr entry))
                  (list (cons (car entry) (list 0)))
                  table))
            (reverse table)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        Codifica e decodifica del messaggio                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Funzione per codificare una lista di simboli.
(defun encode-symbols (symbols table)
  (if (null symbols)
      nil
      (let ((entry (assoc (car symbols) table)))
        (if (null entry)
            (encode-symbols (cdr symbols) table)
            (append (cdr entry) (encode-symbols (cdr symbols) table))))))

(defun hucodec-encode (message huffman-tree)
  (if (not (huffman-node-p huffman-tree))
      (error "Albero di Huffman non valido in encode")
      (let ((symbols-list (cond ((stringp message) (coerce message 'list))
                                ((listp message) message)
                                (t (error "Messaggio non valido")))))
        (let ((table (hucodec-generate-symbol-bits-table huffman-tree)))
          (encode-symbols symbols-list table)))))

;; Funzioni per normalizzare la sequenza di bit.
(defun normalize-bits-string (str index len)
  (if (>= index len)
      nil
      (let ((ch (char str index)))
        (if (char= ch #\0)
            (cons 0 (normalize-bits-string str (+ index 1) len))
            (if (char= ch #\1)
                (cons 1 (normalize-bits-string str (+ index 1) len))
                (error "Carattere non valido ~S" ch))))))

(defun normalize-bits (bits)
  (cond ((stringp bits)
        (normalize-bits-string bits 0 (length bits)))
      ((listp bits)
        (if (every (lambda (b) (and (integerp b) (or (zerop b) (= b 1)))) bits)
            bits
            (error "Valore di bit non valido nella lista")))
      (t (error "I bit devono essere lista di 0/1 o stringa \"0\"/\"1\""))))

;; Funzioni ausiliarie per la decodifica.
(defun node-left (branch)
  (huffman-node-left branch))
(defun node-right (branch)
  (huffman-node-right branch))
(defun leaf-p (node)
  (and (huffman-node-symbol node)
       (null (huffman-node-left node))
       (null (huffman-node-right node))))
(defun leaf-symbol (node)
  (huffman-node-symbol node))

;; Funzione per scegliere il ramo successivo in base al bit.
(defun choose-branch (bit branch)
  (cond ((= 0 bit) (node-left branch))
        ((= 1 bit) (node-right branch))
        (t (error "Bad bit ~D." bit))))

;; Decodifica: dato una lista di bit e l'albero, ricostruisce il messaggio.
(defun hucodec-decode (bits code-tree)
  (labels ((hucodec-decode-1 (bits current-branch)
             (unless (null bits)
               (let ((next-branch (choose-branch (first bits) current-branch)))
                 (if (leaf-p next-branch)
                     (cons (leaf-symbol next-branch)
                           (hucodec-decode-1 (rest bits) code-tree))
                     (hucodec-decode-1 (rest bits) next-branch))))))
    (hucodec-decode-1 bits code-tree)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                   Codifica di file                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Legge ricorsivamente tutti i caratteri dal file.
(defun read-file-contents (stream)
  (let ((ch (read-char stream nil nil)))
    (if ch
        (cons ch (read-file-contents stream))
        nil)))

(defun hucodec-encode-file (filename huffman-tree)
  (if (not (huffman-node-p huffman-tree))
      (error "Albero di Huffman non valido in encode-file")
      (if (not (probe-file filename))
          (error "File ~A non trovato" filename)
          (with-open-file (in filename
                              :direction :input
                              :element-type 'character)
            (let ((chars (read-file-contents in)))
              (format t "Contenuto del file: ~S~%" chars)
              (hucodec-encode chars huffman-tree))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              Stampa dell'albero Huffman                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Funzione ausiliaria per creare una stringa di spazi per l'indentazione.
(defun make-indent (n)
  (if (<= n 0)
      ""
      (concatenate 'string " " (make-indent (- n 1)))))

(defun hucodec-print-huffman-tree (huffman-tree &optional (indent-level 0))
  (if (not (huffman-node-p huffman-tree))
      (error "Albero di Huffman non valido in print-huffman-tree")
      (if (not (integerp indent-level))
          (error "Il livello di indentazione deve essere un intero")
          (let ((indent (make-indent indent-level))
                (sym (huffman-node-symbol huffman-tree))
                (wgt (huffman-node-weight huffman-tree)))
            (cond
              ((and (zerop indent-level) sym)
               (format t "~A(RADICE) ~S (weight ~A)~%" indent sym wgt))
              ((and (zerop indent-level) (null sym))
               (format t "~A(RADICE) (weight ~A)~%" indent wgt))
              (sym
               (format t "~A~S (weight ~A)~%" indent sym wgt))
              (t
               (format t "~A(NODO-INTERNO) (weight ~A)~%" indent wgt)))
            (unless sym
              (format t "~A0:~%" indent)
              (hucodec-print-huffman-tree (huffman-node-left huffman-tree)
                                          (+ indent-level 4))
              (format t "~A1:~%" indent)
              (hucodec-print-huffman-tree (huffman-node-right huffman-tree)
                                          (+ indent-level 4)))))))

