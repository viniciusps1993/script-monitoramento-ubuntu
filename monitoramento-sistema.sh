#!/bin/bash

LOG_DIR="monitoramento_sistema"
mkdir -p $LOG_DIR

function monitorar_logs() {
        grep -E "fail(ed)?|error|denied|unauthorized" /var/log/syslog | awk '{print $1, $2, $3, $5, $6, $7}' > $LOG_DIR/monitoramento_logs_sistema.txt
        grep -E "fail(ed)?|error|denied|unauthorized" /var/log/auth.log | awk '{print $1, $2, $3, $5, $6, $7}' > $LOG_DIR/monitoramento_logs_auth.txt
}

function monitorar_rede() {
        if ping -c 1 8.8.8.8 > /dev/null; then
                echo "$(date): Conectividade ativa." >> $LOG_DIR/monitoramento_rede.txt
        else
                echo "$(date): Sem conexao com a internet." >> $LOG_DIR/monitoramento_rede.txt
        fi

        if curl -s --head https://www.youtube.com/ | grep "HTTP/2 200" > /dev/null; then
                echo "$(date): Conexao com o YouTube bem-sucedida." >> $LOG_DIR/monitoramento_rede.txt
        else
                echo "$(date): Falha ao conectar com o YouTube." >> $LOG_DIR/monitoramento_rede.txt
        fi
}

function monitorar_disco() {
    echo "$(date)" >> $LOG_DIR/monitoramento_disco.txt
    df -h | grep -v "snapfuse" | awk '$5+0 > 70 {print $1 " esta com " $5 " de uso."}' >> $LOG_DIR/monitoramento_disco.txt
    echo "Uso de disco no diretório principal:" >> $LOG_DIR/monitoramento_disco.txt
    du -sh /home/vinicius_souza >> $LOG_DIR/monitoramento_disco.txt
}


function executar_monitoramento() {
        monitorar_logs
        monitorar_rede
        monitorar_disco
}

executar_monitoramento