# Contexto e Handover do Projeto T3 Code

Este documento consolida o estado atual do desenvolvimento, decisões arquiteturais, pull requests abertos, branches e tarefas concluídas para continuidade das sessões no **T3 Code**.

---

## 📌 Regras Estritas do Usuário

1. **Sempre responder em português.**
2. **Nunca adicionar comentários ao código** (proibição absoluta de comentários de linha ou bloco em qualquer arquivo editado ou criado).

---

## 🌿 Branches e Pull Requests

| Branch                             | PR / Status              | Descrição                                                                                  |
| ---------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------ |
| `t3code-enhanced`                  | Branch Principal do Fork | Branch consolidada com todas as melhorias e customizações                                  |
| `feat/turn-completion-sound`       | **PR #7066**             | Sons de notificação de conclusão e erro configuráveis com presets e preview                |
| `fix/thread-titlebar-actions-menu` | **PR #7067**             | Menu de contexto na barra superior/abas para ocultar/exibir ações rápidas com persistência |

---

## 🛠️ Funcionalidades Implementadas

### 1. Sistema de Notificações Sonoras de Turno

- **Sons de Conclusão**:
  - Presets: `chime` (2 tons ascendentes), `bell` (tom puro cristalino), `marimba` (tríade ascendente), `pop` (pitch-drop sutil).
  - Toggle on/off independente.
  - Botão de preview com ícone de volume ao lado do seletor.
- **Sons de Erro**:
  - Presets: `descending` (2 tons descendentes), `chord` (acorde diminuto), `subtle` (onda triangular suave), `buzz` (duplo pulso).
  - Toggle on/off independente.
  - Botão de preview ao lado do seletor.
- **Supressão Inteligente**: Sons de conclusão não tocam se o turno foi interrompido manualmente via botão Stop.
- **Arquivos**:
  - `packages/contracts/src/settings.ts`
  - `apps/web/src/audio/turnChime.ts`
  - `apps/web/src/hooks/useTurnCompletionSound.ts`
  - `apps/web/src/components/settings/SettingsPanels.tsx`

---

### 2. Página de Status do Provedor Antigravity

- Alinhada com a estética e ordenamento de cards do Codex e Claude.
- **Grupos de Modelos com Cotas**:
  - **GEMINI MODELS** (Gemini Flash, Gemini Pro):
    - Weekly Limit Remaining (com percentual e tempo restante de refresh).
    - Five Hour Limit Remaining (com percentual e tempo de refresh).
  - **CLAUDE AND GPT MODELS** (Claude Opus, Claude Sonnet, GPT-OSS):
    - Weekly Limit Remaining.
    - Five Hour Limit Remaining.
  - Link direto ao final da seção para a página de quotas.
- **Arquivos**:
  - `packages/contracts/src/server.ts`
  - `apps/server/src/provider/Layers/AntigravityProvider.ts`
  - `apps/web/src/components/status/StatusPage.tsx`

---

### 3. Abas e Barra Superior de Ações

- Notificações de término com badge numérico nas abas inativas.
- Supressão do badge de +1 se a aba correspondente já estiver aberta/ativa.
- Menu de contexto para ligar/desligar visibilidade de botões rápidos (`Add action`, `Open`, `Commit e Push`).

---

### 4. Build e Empacotamento Local

- Pacote local atualizado em:
  `/home/kbrianps/.local/opt/t3code-enhanced/opt/T3 Code Enhanced/resources/app.asar`
- Comando para compilar e empacotar:
  ```bash
  vp run --filter=@t3tools/web --filter=t3 build
  ```

---

## 🚀 Como Continuar no T3 Code

1. Abra o **T3 Code**.
2. Abra o projeto `/home/kbrianps/t3code`.
3. Inicie uma nova conversa (Thread) selecionando o provedor **Antigravity**.
4. Envie a mensagem:
   > _"Li o `CONTEXT_HANDOVER.md` e estou pronto para continuar."_
