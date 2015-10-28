;; some tricks to make hacking in the repl easier
;;
;; install
;;  copy this file to your ~/.lein/ directory
;;  if the file already exists add this stuff to it
;;
;; features
;;   - you can access the goodies defined here from *any* namespace
;;       for example you can run (refresh) to load your fixed code into the repl after a compilation error from *anywhere*
;;   - use 'lein' to run leiningen from inside the repl
;;       for example (lein test) in the repl will run your tests
;;       or (lein deps :tree) will show you the dependency tree of the project
;;   - if you experimenting with new stuff you can pull it into the repl to work with it
;;       for example (pull 'org.clojure/algo.monads) will make (require 'clojure.algo.monads) work
;;   - makes some commonly used helper functions available everywhere, these are:
;;       apropos dir doc find-doc source
;;   - spyscope is a clojure debugging tool -- i have not tried it yet pls refer to:
;;       https://github.com/dgrnbrg/spyscope
;;
;; requirements:
;;   - upgrade your leiningen to the curr latest (2.3.4), just run from a terminal:
;;       lein upgrade
;;
;;  details and credits:
;;   http://z.caudate.me/give-your-clojure-workflow-more-flow/
;;   https://github.com/zcaudate/vinyasa


{:user {:dependencies [[io.aviso/pretty "0.1.6"]
                       [spyscope "0.1.4"]
                       [org.clojure/tools.namespace "0.2.4"]
                       [leiningen "2.3.4" :exclusions [org.apache.lucene/lucene-core]]
                       [im.chit/vinyasa "0.1.7"]]
        :injections [(require 'spyscope.core)
                     (require 'vinyasa.inject)

                     (vinyasa.inject/inject
                      'clojure.core
                      '[[vinyasa.inject inject]
                        [vinyasa.pull pull]
                        [vinyasa.lein lein]
                        [clojure.tools.namespace.repl refresh]
                        [clojure.repl apropos dir doc find-doc source
                         [root-cause >cause]]])

                     (let [orig (ns-resolve (doto 'clojure.stacktrace require)
                                            'print-stack-trace)
                           new (ns-resolve (doto 'io.aviso.exception require)
                                           'write-exception)]
                       (alter-var-root orig (constantly (deref new))))

                     ;; that is handy but i am not sure that is safe with a remote repl
                     (refresh)]}}
