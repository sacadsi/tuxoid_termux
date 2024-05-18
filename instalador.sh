#!/usr/bin/env bash
#0.9.3 esse é o instalador da gambiarra do tuxoid, bom proveito

base1="https://ia803104.us.archive.org/view_archive.php?archive=/30/items/termux-repositories-legacy/termux-repositories-legacy-24.12.2019.tar"
base2=`echo "&"`
base3="file="
basetotal="$base1$base2$base3"

primeiro=$1;pacote=$2;processador="arm"

## declaração das funções
function regex() {
    echo "atualizando lista de pacotes..."
    curl -o arquivo.txt https://ia903104.us.archive.org/view_archive.php?archive=/30/items/termux-repositories-legacy/termux-repositories-legacy-24.12.2019.tar
    echo "indexando links de pacotes, isso pode demorar alguns minutos..."
    while read linha; do
        if [[ "$linha" == *termux* ]]; then
            linha="${linha:109}"
            letras=()
            for i in $(seq 70 ${#linha}); do
                letras[$i]="${linha:$i:1}"
                if [[ "${letras[$i]}" == "\"" ]]; then
                    linha="${linha:0:$i}"
                    echo "${linha}" >> pacotestuxoid.txt
                fi
            done
        fi
    done < arquivo.txt
    mv pacotestuxoid.txt ~/../.cachetuxoid/pacotestuxoid.txt
    rm arquivo.txt
}

function instalar() {
    a=`grep $processador'.*'"%2F"$pacote"_" ~/../.cachetuxoid/pacotestuxoid.txt`
    if [[ -n $a ]]; then
        curl -o $(echo $pacote".deb") $basetotal$a
        dpkg -i $(echo $pacote".deb")
    else
        echo "pacote não encontrado"
    fi
}

function desinstalar() {
    dpkg -r $pacote
    echo "pacote desinstalado"
}

function main() {
    if [[ -e ~/../.cachetuxoid/pacotestuxoid.txt ]]; then
        echo
    else
        regex #funcao
    fi

    case "$primeiro" in
        instalar)
            instalar #funcao
        ;;
         desinstalar)
            desinstalar #funcao
        ;;
         *)
            echo "    voce deve usar: tuxoid [instalar/desintalar] <pacote>"
            echo
        ;;
    esac
}

function instalador() {
    echo "tuxoid é um script que ira baixar e instalar pacotes pedidos assim como vc faria com o pkg"
    echo "voce quer instalar a gambiarra do tuxoid no seu termux?"
    read -p  "?" resposta

    if [[ $resposta == "n" ]]; then
        echo "instalacao abortada"

    elif [[ $resposta == "s" ]]; then
        echo "iniciando a instalação..."
        cp $0 ~/../usr/bin/tuxoid
        chmod +x ~/../usr/bin/tuxoid
        echo "instalado com sucesso"
        echo "use tuxoid [instalar/desintalar] <pacote>"
    else
        echo "digite s ou n somente, minusculas"
    fi
}

##execução
if [[ -e ~/../usr/bin/tuxoid ]]; then
    main
else
    instalador
fi
