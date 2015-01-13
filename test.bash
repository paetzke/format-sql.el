#! /bin/bash

install_emacs24() {
    sudo add-apt-repository ppa:cassou/emacs -y
    sudo apt-get update -y

    sudo apt-get install emacs24 -y
}


install_package() {
    emacs -nw format-sql.el -f package-install-from-buffer -f kill-emacs
}


test_01() {
    emacs -nw ./test_data/test_01/before.sql -f format-sql-buffer -f save-buffer -f save-buffers-kill-terminal
    diff ./test_data/test_01/before.sql ./test_data/test_01/after.sql
    if [ $? != 0 ]; then
        exit 1
    fi
}


test_02() {
    emacs -nw ./test_data/test_02/before.py -f format-sql-buffer -f save-buffer -f save-buffers-kill-terminal
    diff ./test_data/test_02/before.py ./test_data/test_02/after.py
    if [ $? != 0 ]; then
        exit 1
    fi
}


main() {
    if [ "$TRAVIS" = "true" ]; then
        install_emacs24
    fi
    install_package

    test_01
    test_02
}


main
