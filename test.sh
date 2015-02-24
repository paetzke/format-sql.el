#! /bin/bash


on_error() {
    local msg=$1

    echo $msg
    exit 1
}


install_emacs24() {
    sudo add-apt-repository ppa:cassou/emacs -y
    sudo apt-get update -y
    sudo apt-get install emacs24 -y
}


test_01() {
    emacs --no-init-file --load format-sql.el -nw ./test_data/test_01/before.sql \
          -f format-sql-buffer \
          -f save-buffer \
          -f save-buffers-kill-terminal

    diff ./test_data/test_01/before.sql ./test_data/test_01/after.sql
    if [ $? != 0 ]; then
        on_error "test_01"
    fi
}


test_02() {
    emacs --no-init-file --load format-sql.el -nw ./test_data/test_02/before.py \
          -f format-sql-buffer \
          -f save-buffer \
          -f save-buffers-kill-terminal

    diff ./test_data/test_02/before.py ./test_data/test_02/after.py
    if [ $? != 0 ]; then
        on_error "test_02"
    fi
}


test_03() {
    emacs --no-init-file --load format-sql.el -nw ./test_data/test_03/before.not_sql \
          -f format-sql-buffer \
          -f save-buffer \
          -f save-buffers-kill-terminal

    diff ./test_data/test_03/before.not_sql ./test_data/test_03/after.not_sql
    if [ $? != 0 ]; then
        on_error "test_03"
    fi
}


test_04() {
    emacs -nw format-sql.el -f package-install-from-buffer -f kill-emacs
}


main() {
    if [ "$TRAVIS" = "true" ]; then
        install_emacs24
    fi

    test_01
    test_02
    test_03

    if [ "$TRAVIS" = "true" ]; then
        test_04
    fi
}


main
