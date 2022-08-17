# Aplicação de colaboradores

Esta aplicacão tem como maior objetivo explorar conhecimentos para o desafio de criação de uma aplicacão em Ruby on Rails para controle de usuários, atendendo alguns tópicos obrigatórios:

    - Sistema de autenticação: apenas usuários logados podem ter acesso ao sistema.
    - Sistema de autorização: apenas usuários admin podem inativar/excluir outros usuários.
    - Cadastros de usuários: busca e ordenação por nome, email e nível de acesso.
    - API RESTful ou GraphQL: permite que o sistema de RH cadastre o usuário e o torne inativo.
    - Uso de testes automatizados (testes unitários, de integração, etc..).

Topics:

- Dependencias
- Construindo o container
- Executando o rubocop como lint de código
- Executando os testes com Rspec
- Checando a cobertura de testes da aplicacão
- Executando a aplicação em um docker
- Rotas uteis da API
- Parar a execução do docker com a aplicação
- Créditos

## Dependencias

Docker/Docker-compose (https://docs.docker.com/get-docker/)

## Construindo o container 

Para fazer build da imagem do container, basta executar o seguinte comando na raiz da aplicação:
```bash
docker-compose build
```

## Executando o rubocop como lint de código

Para checar alguma inconformidade de lint de código, basta executar o rubocop:

```bash
docker-compose run --no-deps web rubocop
```

## Executando os testes com Rspec

Para executar os testes com o Rspec, basta executar o seguinte comando na raiz da aplicação:

```bash
docker-compose run --no-deps web rspec
```

## Checando a cobertura de testes da aplicacão

Após executar os testes pelo rspec, um arquivos é criado na pasta 'coverage/index.html', para abrir, execute o comando:

```bash
 open coverage/index.html
```

## Executando a aplicação em um docker

Para popular o banco local com informações iniciais como um admin válido, execute:

```bash
docker-compose run --no-deps web rake db:seed
```

Para criar uma instancia da imagem e executar a aplicação em background

```bash
docker-compose up -d
```

Agora voce deve ter um container executando, para verificar execute o seguinte comando:

```bash
docker ps
```

A aplicação deve estar exposta na url (http://localhost:3000/)

## Informações uteis sobre a API

A API precisa de um token de autorização para a maioria das rotas, token que tem niveis de permissões, sendo usuário admin capaz de executar qualquer ação na API e regular apenas leitura.

Quando executou o comando "docker-compose run --no-deps web rake db:seed" anteriormente, foram criados 2 usuários, sendo um admin e outro regular:

Os dados do admin são o seguinte:
email: admin@admin.com
senha: 123456

Considerar checar o arquivo db/seeds.rb para confirmar as informações.

Em um API client como Insominia (https://insomnia.rest/download) ou via bash via curl, você pode executar as requisições na API, para mais detalhes, checar o arquivo (apyary.apib) dentro desse projeto.

É importante executar o endpoint de login passando as informações de usuário admin acima, esse endpoint retornará o token para executar outros endpoints que possuem controle de permissões e deverá ser informado no header Authorization.

## Parar a execução do docker com a aplicação

Para remover o container caso necessário, execute o comando:

```bash
docker-compose down
```

## Créditos

*Flavio Avila*<br>
flavio.avila.silva@outlook.com<br>
https://github.com/flavioavilasilva<br>
https://www.linkedin.com/in/flavio-avila-7775702b/