;;;; son-of-mogh.asd

(asdf:defsystem #:son-of-mogh
  :description "Describe son-of-mogh here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t

  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "son-of-mogh"
  :entry-point "son-of-mogh::start"

  :depends-on (#:trivial-irc #:string-case #:alexandria)
  :components ((:file "son-of-mogh")))
