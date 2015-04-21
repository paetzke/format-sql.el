#! /bin/bash -e

TEST_FILE=/tmp/py-test-file.py


install_emacs24() {
    sudo add-apt-repository ppa:cassou/emacs -y
    sudo apt-get update -y
    sudo apt-get install emacs24 -y
}


test_install_package() {
    echo $FUNCNAME
    emacs --no-init-file -nw \
          format-sql.el \
          -f package-install-from-buffer \
          -f kill-emacs
}


test_01() {
    echo $FUNCNAME
    rm $TEST_FILE || true
    emacs -nw --no-init-file \
          --load ./tests/tests.el \
          --load format-sql.el \
          ./tests/01/before.sql \
          -f format-sql-buffer \
          -f write-test-file \
          -f kill-emacs

    diff $TEST_FILE ./tests/01/after.sql
}


test_02() {
    echo $FUNCNAME
    rm $TEST_FILE || true
    emacs --no-init-file -nw \
          --load ./tests/tests.el \
          --load format-sql.el \
          ./tests/02/before.py \
          -f format-sql-buffer \
          -f write-test-file \
          -f kill-emacs

    diff $TEST_FILE ./tests/02/after.py
}


test_03() {
    echo $FUNCNAME
    rm $TEST_FILE || true
    emacs --no-init-file -nw \
          --load ./tests/tests.el \
          --load format-sql.el \
          ./tests/03/before.not_sql \
          -f format-sql-buffer \
          -f write-test-file \
          -f kill-emacs

    diff $TEST_FILE ./tests/03/after.not_sql
}


test_04() {
    echo $FUNCNAME
    rm $TEST_FILE || true
    emacs --no-init-file -nw \
          --load ./tests/tests.el \
          --load format-sql.el \
          ./tests/04/before.sql \
          -f mark-whole-buffer \
          -f format-sql-region \
          -f write-test-file \
          -f kill-emacs
    diff $TEST_FILE ./tests/04/after.sql
}


main() {
    if [ "$TRAVIS" = "true" ]; then
        install_emacs24
        test_install_package
    fi

    test_01
    test_02
    test_03
    test_04
}


main
