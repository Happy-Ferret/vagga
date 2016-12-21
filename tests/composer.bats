setup() {
    cd /work/tests/composer
}

teardown() {
    cd /work/tests/composer
    if [ -f composer.lock ]; then rm composer.lock; fi
}

# test composer is available in PATH and removed after container is built
@test "composer: lifecycle" {
    run vagga _build composer-lifecycle
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ $output = *"Composer version"* ]]
    [[ ! -f ".vagga/composer-lifecycle/usr/local/bin/composer" ]]
    link=$(readlink .vagga/composer-lifecycle)
    [[ $link = ".roots/composer-lifecycle.94bdac56/root" ]]
}

@test "composer: keep composer after build" {
    run vagga _build keep-composer
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ -f .vagga/keep-composer/usr/local/bin/composer ]]
}

@test "composer: change vendor directory" {
    run vagga _build change-vendor-dir
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ -d .vagga/change-vendor-dir/usr/local/dependencies/vendor/nette/tester ]]
}

# php

@test "composer: php ubuntu xenial" {
    run vagga _run php-ubuntu-xenial laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer 1.3.0" ]]
    link=$(readlink .vagga/php-ubuntu-xenial)
    [[ $link = ".roots/php-ubuntu-xenial.7557ac65/root" ]]
}

@test "composer: php ubuntu trusty" {
    run vagga _run php-ubuntu-trusty laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer 1.3.0" ]]
    link=$(readlink .vagga/php-ubuntu-trusty)
    [[ $link = ".roots/php-ubuntu-trusty.383d0fa4/root" ]]
}

@test "composer: php ubuntu precise" {
    run vagga _run php-ubuntu-precise tester .
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "No tests found" ]]
    link=$(readlink .vagga/php-ubuntu-precise)
    [[ $link = ".roots/php-ubuntu-precise.1705a1c1/root" ]]
}

@test "composer: php alpine 3.4" {
    run vagga _run php-alpine-3_4 laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer 1.3.0" ]]
    link=$(readlink .vagga/php-alpine-3_4)
    [[ $link = ".roots/php-alpine-3_4.46bd0c52/root" ]]
}

@test "composer: php alpine 3.3" {
    run vagga _run php-alpine-3_3 laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer 1.3.0" ]]
    link=$(readlink .vagga/php-alpine-3_3)
    [[ $link = ".roots/php-alpine-3_3.cc007bd2/root" ]]
}

@test "composer: php alpine 3.2" {
    run vagga _run php-alpine-3_2 laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer 1.3.0" ]]
    link=$(readlink .vagga/php-alpine-3_2)
    [[ $link = ".roots/php-alpine-3_2.688224a6/root" ]]
}

@test "composer: php ComposerDependencies" {
    run vagga _run php-composer-deps laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer version 1.3.0" ]]
    link=$(readlink .vagga/php-composer-deps)
    [[ $link = ".roots/php-composer-deps.c94d5c1e/root" ]]
}

@test "composer: php ComposerDependencies ubuntu xenial" {
    run vagga _run php-composer-deps-ubuntu-xenial laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer version 1.3.0" ]]
    link=$(readlink .vagga/php-composer-deps-ubuntu-xenial)
    [[ $link = ".roots/php-composer-deps-ubuntu-xenial.06cd630e/root" ]]
}

@test "composer: php ComposerDependencies ubuntu trusty" {
    run vagga _run php-composer-deps-ubuntu-trusty laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer version 1.3.0" ]]
    link=$(readlink .vagga/php-composer-deps-ubuntu-trusty)
    [[ $link = ".roots/php-composer-deps-ubuntu-trusty.bdcfdb4d/root" ]]
}

@test "composer: php ComposerDependencies dev" {
    run vagga _run php-composer-dev-deps task greet
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Hello, Vagga!" ]]
    link=$(readlink .vagga/php-composer-dev-deps)
    [[ $link = ".roots/php-composer-dev-deps.c94d5c1e/root" ]]
}

@test "composer: php ComposerDependencies dev ubuntu xenial" {
    run vagga _run php-composer-dev-deps-ubuntu-xenial task greet
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Hello, Vagga!" ]]
    link=$(readlink .vagga/php-composer-dev-deps-ubuntu-xenial)
    [[ $link = ".roots/php-composer-dev-deps-ubuntu-xenial.06cd630e/root" ]]
}

@test "composer: php ComposerDependencies dev ubuntu trusty" {
    run vagga _run php-composer-dev-deps-ubuntu-trusty task greet
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Hello, Vagga!" ]]
    link=$(readlink .vagga/php-composer-dev-deps-ubuntu-trusty)
    [[ $link = ".roots/php-composer-dev-deps-ubuntu-trusty.bdcfdb4d/root" ]]
}

@test "composer: php ComposerDependencies prefer dist" {
    run vagga _run php-composer-deps-prefer-dist task greet
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Hello, Vagga!" ]]
    link=$(readlink .vagga/php-composer-deps-prefer-dist)
    [[ $link = ".roots/php-composer-deps-prefer-dist.c94d5c1e/root" ]]
}

@test "composer: php ComposerDependencies wrong prefer" {
    run vagga _build php-composer-deps-wrong-prefer
    printf "%s\n" "${lines[@]}"
    [[ $status = 121 ]]
    [[ $output = *"Value of 'ComposerDependencies.prefer' must be either 'source' or 'dist', 'wrong' given"* ]]
}

@test "composer: php ComposerDependencies lock" {
    cd /work/tests/composer_lock
    run vagga _run php-composer-deps-lock laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ $output = *"The lock file is not up to date with the latest changes in composer.json"* ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer version 1.3.0" ]]
    link=$(readlink .vagga/php-composer-deps-lock)
    [[ $link = ".roots/php-composer-deps-lock.a1406b15/root" ]]
}

# hhvm

@test "composer: hhvm ubuntu xenial" {
    run vagga _run hhvm-ubuntu-xenial laravel --version
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "Laravel Installer 1.3.0" ]]
    link=$(readlink .vagga/hhvm-ubuntu-xenial)
    [[ $link = ".roots/hhvm-ubuntu-xenial.53c993a5/root" ]]
}
