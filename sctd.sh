#!/bin/sh
# $Id: sctd.sh 20 2017-05-12 21:14:08Z umaxx $
# Copyright (c) 2017 Aaron Bieber <abieber@openbsd.org>
# Copyright (c) 2017 Joerg Jung <jung@openbsd.org>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

readonly S_V="0.4" S_YR="2017"

s_err() {
    logger -i -p daemon.err -s -t "sctd" "error: ${1}"; exit 1
}

s_hm() {
    local h m
    h=$(date +"%H" | sed -e 's/^0//') || s_err "hours failed"
    m=$(date +"%M" | sed -e 's/^0//') || s_err "minutes failed"
    printf "$((h*60 + m))\n"
}

s_run() {
    local r hm=$(s_hm) inc=2 t=4500 sct=$(which sct) || s_err "sct not found"
    [ $hm -gt 720 ] && { t=$((t + inc * (1440 - hm))); } ||
                       { t=$((t + inc * hm)); }
    while :; do
        hm=$(s_hm)
        [ $hm -gt 720 ] && { t=$((t - inc)); } || { t=$((t + inc)); }
        r=$(${sct} ${t})
        [ $? -eq 0 ] && { logger -i -p daemon.info -s -t "sctd" "${r}"; } ||
                        { s_err "${r}"; }
        sleep 60
    done
}

s_main() {
    [ $# -eq 1 ] && [ "${1}" = "version" ] &&
        { printf "sctd %s (c) %s Aaron Bieber, Joerg Jung\n" ${S_V} ${S_YR};
          exit 0; }
    [ $# -ne 0 ] &&
        { printf "usage: sctd\n%7ssctd version\n" " ";
          exit 1; }
    trap "s_err \"signal received\"" 1 2 3 13 15
    s_run
}

s_main "$@"
