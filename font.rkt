#lang racket

(system "wget https://github.com/be5invis/Iosevka/releases/download/v33.3.6/PkgTTC-SGr-Iosevka-33.3.6.zip")
(system "wget https://github.com/be5invis/Iosevka/releases/download/v33.3.6/PkgTTC-SGr-IosevkaTerm-33.3.6.zip")
(system "unzip PkgTTC-SGr-Iosevka-33.3.6.zip")
(system "unzip PkgTTC-SGr-IosevkaTerm-33.3.6.zip")
(system "mkdir -p ~/.local/share/fonts")
(system "cp *.ttc ~/.local/share/fonts/")
(system "fc-cache -fv")
