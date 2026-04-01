#lang racket
(require data/maybe)

(provide chain)
(provide wget)
(provide apt-get)
(provide yum-install)
(provide mkdir)
(provide read-system)
(provide memory)
(provide get-os)
(provide nproc)
(provide elem?)
(provide string-chain)

(define (string-chain sep xs)
  (match xs
    [(cons x '()) x]
    [(cons x xxs)
     (string-append x sep (string-chain sep xxs))]
    ['() ""]
    ))

(define (chain . xs)
  (string-chain " && " xs))

(define (wget link)
  (system
   (string-append "wget -c " link)))

(define (apt-get . xs)
  (system
   (string-append
    "apt-get install -y "
    (string-chain " " xs))))

(define (yum-install . xs)
  (system
   (string-append
    "yum install -y "
    (string-chain " " xs))))

(define (mkdir build-dir)
  (if (directory-exists? build-dir)
      ; then
      '()
      ; else
      (make-directory build-dir)))

(define (readlines #:port port)
    (let ([r (read-line port)])
      (if (eof-object? r)
            '()
            (cons r (readlines #:port port))
            )))
 

(define (read-system cmd)
  (let*
    (
      [vs (process cmd)]
      [p (match vs
           [(list input-port output-port _ _ _) input-port]
           [_ (raise 'failed #t)]
         )]
    )
    (readlines #:port p)))

(define (start-with s #:prefix prefix)
  (let*
      ([l (string-length prefix)]
       [ss (substring s 0 l)]
      )
      (string=? ss prefix)))

(define (chunk-prefix s #:prefix prefix)
  (let
      ([l (string-length prefix)])
      (substring s l)))

(define (chunk-space s)
  (define (chunk-space-list ss)
   (match ss
     [(cons #\space ass) (chunk-space-list ass)]
     [_ ss]))
  (list->string (chunk-space-list (string->list s))))
     

(define (memory)
  (define (read-memory p)
    (let ([line (read-line p)]
          [prefix "MemTotal:"]
          )
      (cond
        [(eof-object? line) nothing]
        [(start-with line #:prefix prefix)
         (just (chunk-space (chunk-prefix line #:prefix prefix)))]
        [else (read-memory p)])))
  (define (process-memory p)
    (let
        ([ps (match p 
               [(just x) (string-split x " ")]
               [nothing (raise 'failed #t)])])
        (match ps
          [(list n un) (if (string=? un "kB")
                           ;then
                           (floor (/ (/ (string->number n) 1024) 1024))
                           ;else
                           (raise 'failed #t))]
          [_ (raise 'failed #t)])))
  
  (let* ([port (open-input-file "/proc/meminfo" #:mode 'text)]
         [jl (read-memory port)]
         )
    (process-memory jl)))

(define (get-os)
  (define (read-os-line p)
    (let ([line (read-line p)])
      (cond
        [(eof-object? line) nothing]
        [(start-with line #:prefix "NAME") (just line)]
        [else (read-os-line p)])))
  (define (get-os-line)
    (let ([p (open-input-file "/etc/os-release" #:mode 'text)])
      (read-os-line p)))
  (let* ([jline (get-os-line)]
         [line (match jline
                 [(just line) line]
                 [nothing (raise 'failed #t)])
                 ]
         )
    (match (chunk-prefix line #:prefix "NAME=")
      ["\"Ubuntu\"" 'ubuntu]
      ["\"Rocky\"" 'rocky]
      [_ (raise 'failed #t)])))

(define (nproc)
  (match (read-system "nproc")
    [(list x) (string->number x)]
    [_ (raise 'failed #t)]))

(define (elem? x alist)
  (match alist
    [(cons xx ll) (if (equal-always? x xx)
                      ;then
                      #t
                      ;else
                      (elem? x ll))]
    ['() #f]))


;; (display (elem? "11.4.0" (list "12.8.0" "14.1.0" "11.4.0")))

;; (display (nproc))

;; (display (memory))
;; (newline)
;; (get-os)
