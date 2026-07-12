# Nota sobre imagens removidas

Os arquivos `component_atlas_bank_*.png` originais deste diretório eram atlases de sprites
**extraídos diretamente da ROM** (arte original do jogo) e foram removidos deste repositório
público por política de direitos autorais — ver `DISCLAIMER.md` na raiz do projeto.

Os catálogos de metadados (`gobj_sprite_catalog.csv/json/md`, `component_graphics_map.csv/json`)
foram mantidos, pois contêm apenas coordenadas, nomes e referências técnicas — não a arte em si.

Para regenerar essas imagens localmente (a partir da sua própria ROM legalmente adquirida),
use o script `tools/BitplaneToPng.py` / `tools/SpriteDecompressor.py`.
