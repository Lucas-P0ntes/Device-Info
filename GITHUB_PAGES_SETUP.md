# Configuração do GitHub Pages

Este guia explica como publicar as páginas web no GitHub Pages.

## 📋 Pré-requisitos

- Repositório no GitHub
- Permissões de administrador no repositório

## 🚀 Passos para Ativar o GitHub Pages

### 1. Ativar GitHub Pages no Repositório

1. Acesse seu repositório no GitHub
2. Vá em **Settings** (Configurações)
3. No menu lateral, clique em **Pages**
4. Em **Source** (Fonte), selecione:
   - **Branch:** `gh-pages`
   - **Folder:** `/ (root)`
5. Clique em **Save** (Salvar)

### 2. Habilitar GitHub Actions

1. No mesmo repositório, vá em **Settings**
2. Clique em **Actions** → **General**
3. Certifique-se de que **Workflow permissions** está configurado como:
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**

### 3. Fazer Push das Alterações

Após fazer push deste código para o repositório:

```bash
git add .
git commit -m "Configurar GitHub Pages"
git push origin main
```

### 4. Verificar o Deploy

1. Vá na aba **Actions** do seu repositório
2. Você verá o workflow "Deploy to GitHub Pages" em execução
3. Aguarde alguns minutos para o deploy completar
4. Quando concluído, você verá um link para acessar o site

## 🌐 URLs das Páginas

Após o deploy, suas páginas estarão disponíveis em:

- **Página Inicial:** `https://SEU-USUARIO.github.io/Device-Info/`
- **Suporte:** `https://SEU-USUARIO.github.io/Device-Info/suporte.html`
- **Privacidade:** `https://SEU-USUARIO.github.io/Device-Info/privacidade.html`

**Nota:** Substitua `SEU-USUARIO` pelo seu nome de usuário do GitHub.

## 🔄 Deploy Automático

O workflow configurado faz deploy automático sempre que você:
- Fizer push para a branch `main`
- Executar manualmente o workflow na aba **Actions**

## 📝 Estrutura dos Arquivos

```
Device-Info/
├── .github/
│   └── workflows/
│       └── pages.yml          # Workflow de deploy
├── doc/
│   ├── index.html             # Página inicial
│   ├── privacidade.html       # Política de privacidade
│   └── suporte.html          # Página de suporte
└── GITHUB_PAGES_SETUP.md     # Este arquivo
```

## ⚙️ Configuração Alternativa (Branch gh-pages)

Se preferir usar a branch `gh-pages` diretamente:

1. Crie uma branch `gh-pages`:
   ```bash
   git checkout -b gh-pages
   ```

2. Copie os arquivos HTML para a raiz:
   ```bash
   cp doc/*.html .
   ```

3. Faça commit e push:
   ```bash
   git add *.html
   git commit -m "Adicionar páginas para GitHub Pages"
   git push origin gh-pages
   ```

4. Configure o GitHub Pages para usar a branch `gh-pages`

## 🐛 Solução de Problemas

### O workflow não está executando
- Verifique se o GitHub Actions está habilitado no repositório
- Confirme que você fez push para a branch `main`

### As páginas não aparecem
- Aguarde alguns minutos (o deploy pode levar até 5 minutos)
- Verifique a aba **Actions** para ver se há erros
- Confirme que o GitHub Pages está configurado corretamente em **Settings** → **Pages**

### Erro de permissões
- Vá em **Settings** → **Actions** → **General**
- Configure as permissões como descrito no passo 2

## 📞 Suporte

Se tiver problemas, verifique:
- [Documentação do GitHub Pages](https://docs.github.com/en/pages)
- [Documentação do GitHub Actions](https://docs.github.com/en/actions)

