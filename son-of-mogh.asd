;;;; son-of-mogh.asd

(asdf:defsystem #:son-of-mogh
  :description "A simple IRC bot that lets users invite their friends
  to a private instance of https://thelounge.chat/"
  :author "Colin OKay <okay@toyful.space>"
  :license  "Unlicense"
  :version "0.1.0"
  :serial t

  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "son-of-mogh"
  :entry-point "son-of-mogh::start"

  :depends-on (#:trivial-irc #:string-case #:alexandria)
  :components ((:file "son-of-mogh")))
