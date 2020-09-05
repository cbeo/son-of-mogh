;;;; son-of-mogh.lisp

(defpackage #:son-of-mogh
  (:use #:cl)
  (:local-nicknames (#:irc #:trivial-irc))
  (:import-from #:string-case
                #:string-case)
  (:import-from #:split-sequence
                #:split-sequence)
  (:import-from #:alexandria
                #:when-let))

(in-package #:son-of-mogh)

(defvar *worf*)
(defparameter +nick+ "worfbot")
(defparameter +server+ "localhost")
(defparameter +port+ 6667)
(defparameter +log+ "worf-log.txt")

(defclass son-of-mogh (irc:client) ())

(defun start ()
  (let ((*worf* 
          (make-instance 'son-of-mogh
                         :log-pathname +log+
                         :server +server+
                         :port +port+
                         :nickname +nick+)))
    (irc:connect *worf*)
    (loop (irc:receive-message *worf*))))

(irc:define-handler (:rpl_welcome (worf  son-of-mogh) prefix arguments)
  (irc:send-join worf "#lobby"))

(irc:define-handler (:privmsg (worf son-of-mogh) prefix arguments)
  (destructuring-bind (channel  message) arguments
    (handler-case 
        (worf-handle-message (irc:prefix-nickname prefix) channel message)
      (error (e)
        (format t "We're Under Attack. It seems to be a~%~a~%" e)))))

(defun worf-handle-message (sender channel message)
  (cond
    ((string= channel (irc:nickname *worf*))
     (irc:send-privmsg *worf* sender (worf-handle-private-message message)))
    (t nil)))


(defun tokenize (msg)
  (remove-if (lambda (s) (zerop (length s)))
             (split-sequence #\space msg)))


(defun worf-handle-private-message (message)
  (when-let (tokens (tokenize message))
    (string-case ((string-downcase (car tokens)))
      ("invite" (invite-user (cadr tokens)))
      ("help" "You may invite somebody by typing 'invite someperson' but without the quotes.")
      (t "Yes!? What do you want?"))))


(defparameter +pwchars+ "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890")
(defun random-pw (n)
  (with-output-to-string (pw)
    (dotimes (i n) (princ (elt +pwchars+ (random (length +pwchars+))) pw))))

(defun invite-user (user)
  (if user 
      (format nil "Tell your friend ~a they may join us. Their access codes are ~a"
              user
              (run-invite-for user (random-pw 10)))
      "A Klingon does not long suffer a fools. Ask for HELP if you require it."))


(defun run-invite-for (user pw)
  (with-open-file (infile "./new-user-inputs" :direction :output :if-exists :supersede)
    (princ pw infile) (terpri infile)
    (princ "yes" infile) (terpri infile))
  (uiop:run-program (list "./add-lounge-user.sh" user) :output t)
  (uiop:delete-file-if-exists "./new-user-inputs")
  pw)
