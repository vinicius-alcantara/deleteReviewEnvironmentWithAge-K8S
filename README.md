# 🧹 cleanEnvironmentReviewK8S

Este projeto contém um script em **Bash** que automatiza a limpeza de recursos antigos em um cluster **Kubernetes**.  
O objetivo é remover **Deployments**, **Services** e **Ingresses** relacionados ao ambiente de **review**, que estejam inativos ou mais antigos que um período pré-definido.  

---

## 🚀 Funcionalidades

- Itera por todos os **namespaces** do cluster (exceto os reservados/sistemas).
- Identifica **Deployments**, **Services** e **Ingresses** que contenham a palavra `review` no nome.
- Verifica a **idade do recurso** e remove aqueles mais antigos que o limite (`THRESHOLD_DAYS`).
- Gera um **relatório detalhado** (`report.txt`) com os recursos excluídos.
- Substitui placeholders no relatório com estatísticas:
  - Total de recursos encontrados.
  - Total de recursos deletados.
  - Total de recursos restantes.
- Envia o relatório por **e-mail** (via script auxiliar `sendMail.sh`).
- Remove o relatório local após o envio.

---

## ⚙️ Variáveis Principais

- `ENVIRONMENT_K8S_APP="review"` → filtro para identificar recursos do ambiente de revisão.
- `THRESHOLD_DAYS=14` → tempo máximo em dias para manter o recurso.
- `WORK_DIR_SCRIPT="/home/auto.k8s/cleanEnvironmentReviewK8S"` → diretório onde o script roda e armazena relatórios.

---

## 📋 Fluxo do Script

1. **Coleta de informações iniciais**  
   - Conta quantos Deployments, Services e Ingresses existem relacionados ao ambiente `review`.  
   - Define variáveis de data/hora e diretório de trabalho.  

2. **Iteração pelos namespaces**  
   - Ignora namespaces do sistema (ex: `default`, `kube-system`, `monitoring`, etc.).  
   - Para cada namespace válido:
     - Registra no relatório o namespace atual.
     - Busca recursos que contenham `review` no nome.

3. **Validação da idade dos recursos**  
   - Analisa o tempo de existência (`kubectl get ... | awk '{print $6}'`).
   - Se o recurso exceder `THRESHOLD_DAYS`, ele é **deletado**.
   - Atualiza contadores de exclusão.

4. **Finalização**  
   - Gera o relatório consolidado substituindo os placeholders (`<totDep>`, `<totSvc>`, `<totIng>`, etc.).
   - Chama a função `sendMailNotification` para enviar o relatório.
   - Remove o `report.txt`.
