# Pass 39 - Field HUD / Status Menu Gate Core 100%

Escopo fechado em 100%:

- identificado o gate de Start para menu/status de campo;
- documentado o uso de `$7F1F5A & $8000`;
- documentado o pedido de abertura via `$7F1F5C |= $0004`;
- documentado `$95 = $09` como submodo pendente do menu secundario/status;
- renomeado `CODE_84C7D6` para `PlayerInput_DispatchBufferedFieldButtons`;
- mantido comportamento byte-perfect.

Proxima meta recomendada: mapear o submodo `$95 = $09` e as rotinas/tabelas que desenham o menu secundario/status.
