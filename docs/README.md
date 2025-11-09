# Documentação - Device Info Pro

Este diretório contém as páginas web de suporte e privacidade do aplicativo Device Info Pro.

## Arquivos

### 📄 suporte.html
Página de suporte com:
- FAQ (Perguntas Frequentes)
- Informações sobre recursos do app
- Formas de contato
- Guia de uso

**URL sugerida:** `https://seu-dominio.com/suporte`

### 🔒 privacidade.html
Política de Privacidade completa com:
- Informações sobre coleta de dados
- Como os dados são usados
- Compartilhamento de dados (não compartilhamos)
- Conformidade com LGPD e GDPR
- Direitos do usuário

**URL sugerida:** `https://seu-dominio.com/privacidade`

## Como Usar

### Opção 1: Hospedar em um Servidor Web
1. Faça upload dos arquivos HTML para seu servidor web
2. Configure as URLs no App Store Connect
3. Adicione os links nas configurações do app

### Opção 2: GitHub Pages
1. Crie um repositório no GitHub
2. Ative GitHub Pages nas configurações
3. Os arquivos estarão disponíveis em:
   - `https://seu-usuario.github.io/repositorio/suporte.html`
   - `https://seu-usuario.github.io/repositorio/privacidade.html`

### Opção 3: Netlify / Vercel
1. Faça deploy dos arquivos HTML
2. Configure domínio personalizado (opcional)
3. Use as URLs geradas no App Store Connect

## Configuração no App Store Connect

Ao fazer upload do app, você precisará fornecer:

1. **URL de Suporte:** `https://seu-dominio.com/suporte`
2. **URL de Privacidade:** `https://seu-dominio.com/privacidade`

## Personalização

### Alterar Email de Contato
Edite os arquivos HTML e substitua:
- `lucaspontessantana@gmail.com` (email de contato atual)

### Alterar Cores
Modifique as cores no CSS dentro de cada arquivo HTML:
- Gradiente principal: `#667eea` e `#764ba2`
- Ajuste conforme sua identidade visual

### Adicionar Logo
Adicione uma tag `<img>` no header de cada página com seu logo.

## Notas

- As páginas são responsivas e funcionam em dispositivos móveis
- Estilo moderno com gradientes e animações suaves
- Conformidade com padrões de acessibilidade web
- Prontas para uso em produção

## Licença

© 2025 Device Info Pro. Todos os direitos reservados.

