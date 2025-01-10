# Comunicação entre Contêineres

Neste vídeo, você aprenderá como configurar a comunicação entre **contêineres no Docker**, criando uma rede customizada e implementando múltiplos serviços que podem se comunicar entre si. Esta abordagem é útil para arquiteturas que necessitam de escalabilidade e isolamento entre serviços.

<!--
https://www.youtube.com/@renato-coelho
-->

## Apresentação em Vídeo

<p align="center">
  <a href="https://www.youtube.com/@renato-coelho" target="_blank"><img src="imagens/thumbnail/thumbnail-docker-comunicacao-github.png" alt="Vídeo de apresentação"></a>
</p>

### Requisitos

+ ![Docker](https://img.shields.io/badge/Docker-27.4.1-E3E3E3)

+ ![Docker-compose](https://img.shields.io/badge/Docker--compose-1.25.0-E3E3E3)

+ ![Git](https://img.shields.io/badge/Git-2.25.1%2B-E3E3E3)

+ ![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04-E3E3E3)


## Configurando a Imagem Base

### Passos

1. **Crie o Dockerfile**
   - Utilize o arquivo `dockerfile` ou crie com o seguinte conteúdo:

   ```bash
   FROM ubuntu:22.04

   SHELL ["/bin/bash", "-c"]

   RUN apt update && \
     apt install iputils-ping -y

   ENTRYPOINT tail -f /dev/null
   ```

2. **Construa a Imagem**
   - Execute o seguinte comando:
     ```bash
     docker build -f dockerfile -t base-comunicacao:0.0.1 .
     ```

## Criando os Serviços

### docker-compose.yaml

1. **Crie o arquivo de configuração**
   - No repositório utilize ou crie o arquivo `docker-compose.yaml` com o conteúdo abaixo:

   ```yaml
    services:
      servidor01:
        image: base-comunicacao:0.0.1
        container_name: servidor01
        hostname: servidor01
        networks:
          rede_comunicacao:

      servidor02:
        image: base-comunicacao:0.0.1
        container_name: servidor02
        hostname: servidor02
        networks:
          rede_comunicacao:

      servidor03:
        image: base-comunicacao:0.0.1
        container_name: servidor03
        hostname: servidor03
        networks:
          rede_comunicacao:

    networks:
      rede_comunicacao:
        driver: bridge
        ipam:
          config:
            - subnet: 10.0.0.0/29 #Nessa faixa tem 6 IPs válidos.
   ```

2. **Ative os Serviços**
   - Inicie os contêineres com o comando:
     ```bash
     docker compose -p comunicacao -f docker-compose.yaml up -d
     ```

## Demonstração

Os contêineres criados podem se comunicar diretamente utilizando seus respectivos **hostnames** configurados no arquivo `docker-compose.yaml`. Isso permite implementar soluções distribuídas com comunicação eficiente entre os serviços.

### Exemplo de Configuração:

| Serviço      | Hostname    |
|--------------|-------------|
| servidor01   | servidor01  |
| servidor02   | servidor02  |
| servidor03   | servidor03  |

### Acessando e Testando a Comunicação

1. **Acessar os Contêineres**
   - Para acessar um dos contêineres, use o comando:
     ```bash
     docker exec -it servidor01 bash
     ```

2. **Testar Comunicação Entre Contêineres**
   - Dentro do contêiner, execute o seguinte comando para testar a comunicação com outro contêiner:
     ```bash
     ping servidor02 -c 3
     ```
   - Repita o teste entre todos os contêineres para verificar a comunicação.

## Referências

- Networking overview, **Docker Docs**. Disponível em: <https://docs.docker.com/engine/network/>. Acesso em: 10 Jan. 2025.
- Networking in Compose, **Docker Docs**. Disponível em: <https://docs.docker.com/compose/how-tos/networking/>. Acesso em: 10 Jan. 2025.
