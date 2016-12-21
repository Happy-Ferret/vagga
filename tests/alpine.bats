setup() {
    cd /work/tests/alpine
}

@test "alpine: Alpine builds" {
    vagga _build v31
    link=$(readlink .vagga/v31)
    [[ $link = ".roots/v31.c2685945/root" ]]
}

@test "alpine: Check stdout" {
    run echo $(vagga v33-tar -cz vagga.yaml | tar -zt)
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    link=$(readlink .vagga/v33-tar)
    [[ $link = ".roots/v33-tar.bec5f9d5/root" ]]
    [[ $output = "vagga.yaml" ]]
}

@test "alpine: Check version" {
    run vagga _build alpine-check-version
    printf "%s\n" "${lines[@]}"
    [[ $status = 121 ]]
    [[ $output = *"Error checking alpine version"* ]]
}

@test "alpine: Run echo command" {
    run vagga echo-cmd hello
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ $output = hello ]]
    run vagga echo-cmd world
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
    [[ $output = world ]]
}

@test "alpine: Run bc on v3.4" {
    run vagga v34-calc 100*24
    printf "%s\n" "${lines[@]}"
    [[ $status -eq 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "2400" ]]
    link=$(readlink .vagga/v34-calc)
    [[ $link = ".roots/v34-calc.72452299/root" ]]
}

@test "alpine: Run bc on v3.3" {
    run vagga v33-calc 100*24
    printf "%s\n" "${lines[@]}"
    [[ $status -eq 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "2400" ]]
    link=$(readlink .vagga/v33-calc)
    [[ $link = ".roots/v33-calc.c0bb1626/root" ]]
}

@test "alpine: Run bc on v3.2" {
    run vagga v32-calc 100*24
    printf "%s\n" "${lines[@]}"
    [[ $status -eq 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "2400" ]]
    link=$(readlink .vagga/v32-calc)
    [[ $link = ".roots/v32-calc.740d7bfb/root" ]]
}

@test "alpine: Run bc on v3.1" {
    run vagga v31-calc 100*24
    printf "%s\n" "${lines[@]}"
    [[ $status -eq 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "2400" ]]
    link=$(readlink .vagga/v31-calc)
    [[ $link = ".roots/v31-calc.4f6a8a69/root" ]]
}

@test "alpine: Run bc on v3.0" {
    run vagga v30-calc 23*7+3
    printf "%s\n" "${lines[@]}"
    [[ $status -eq 0 ]]
    [[ ${lines[${#lines[@]}-1]} = "164" ]]
    link=$(readlink .vagga/v30-calc)
    [[ $link = ".roots/v30-calc.a68c41a8/root" ]]
}

@test "alpine: Run vagga inside alpine" {
    cp ../../vagga vagga_inside_alpine/
    cp ../../apk vagga_inside_alpine/
    cp ../../busybox vagga_inside_alpine/
    cp ../../alpine-keys.apk vagga_inside_alpine/

    run vagga vagga-alpine
    printf "%s\n" "${lines[@]}"
    [[ $status -eq 0 ]]
    [[ ${lines[${#lines[@]}-2]} = c3394eb0 ]]
    [[ ${lines[${#lines[@]}-1]} = c3394eb0e510330a2184491270a557d43d6f5f84c748db5a1b88c159ac1c1c32a53235a10d0248c366681724af6c19f817f04bee425118958295cbef3c8d2419 ]]
}

@test "alpine: AlpineRepo minimal" {
    run vagga _build alpine-repo
    printf "%s\n" "${lines[@]}"
    link=$(readlink .vagga/alpine-repo)
    [[ $link = ".roots/alpine-repo.02b226ea/root" ]]

    [[ $(tail -n 1 ".vagga/alpine-repo/etc/apk/repositories") = *"/v3.4/community" ]]
    repositories=($(sed "s/\/community/\/main/g" ".vagga/alpine-repo/etc/apk/repositories"))
    # test that additional repository has the same mirror
    [[ ${repositories[0]} = ${repositories[1]} ]]

    run vagga _run alpine-repo tini -h
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
}

@test "alpine: AlpineRepo full" {
    run vagga _build alpine-repo-full
    printf "%s\n" "${lines[@]}"
    link=$(readlink .vagga/alpine-repo-full)
    [[ $link = ".roots/alpine-repo-full.1d03281c/root" ]]

    [[ $(tail -n 1 ".vagga/alpine-repo-full/etc/apk/repositories") = \
        "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" ]]

    run vagga _run alpine-repo-full tini -h
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
}

@test "alpine: Repo simple" {
    run vagga _build repo-simple
    printf "%s\n" "${lines[@]}"
    link=$(readlink .vagga/repo-simple)
    [[ $link = ".roots/repo-simple.1a76ceb6/root" ]]

    [[ $(tail -n 1 ".vagga/repo-simple/etc/apk/repositories") = *"/v3.4/community" ]]
    repositories=($(sed "s/\/community/\/main/g" ".vagga/repo-simple/etc/apk/repositories"))
    # test that additional repository has the same mirror
    [[ ${repositories[0]} = ${repositories[1]} ]]

    run vagga _run repo-simple tini -h
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
}

@test "alpine: Repo with branch" {
    run vagga _build repo-with-branch
    printf "%s\n" "${lines[@]}"
    link=$(readlink .vagga/repo-with-branch)
    [[ $link = ".roots/repo-with-branch.92950c67/root" ]]

    [[ $(tail -n 1 ".vagga/repo-with-branch/etc/apk/repositories") = *"/edge/community" ]]
    repositories=($(sed "s/\/edge\/community/\/v3.4\/main/g" ".vagga/repo-with-branch/etc/apk/repositories"))
    # test that additional repository has the same mirror
    echo ${repositories[*]}
    [[ ${repositories[0]} = ${repositories[1]} ]]

    run vagga _run repo-with-branch tini -h
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
}

@test "alpine: Repo subcontainer" {
    run vagga _build repo-subcontainer
    printf "%s\n" "${lines[@]}"
    link=$(readlink .vagga/repo-subcontainer)
    [[ $link = ".roots/repo-subcontainer.deadfee0/root" ]]

    run vagga _run repo-subcontainer tini -h
    printf "%s\n" "${lines[@]}"
    [[ $status = 0 ]]
}
