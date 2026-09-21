#!/usr/bin/env bash
# 一键发布新版：把桌面上的源文件推到 GitHub Pages
# 用法：./publish.sh ["这次改了啥"]
set -euo pipefail

SRC="$HOME/Desktop/cc练字.html"
DST="$(cd "$(dirname "$0")" && pwd)/index.html"
MSG="${1:-更新}"

[ -f "$SRC" ] || { echo "❌ 找不到源文件：$SRC"; exit 1; }

# 语法先过一遍，别把打不开的版本发上去
if command -v node >/dev/null 2>&1; then
  node -e '
    const fs=require("fs"), s=fs.readFileSync(process.argv[1],"utf8");
    const js=s.slice(s.indexOf("<script>")+8, s.lastIndexOf("</script>"));
    new Function(js);
  ' "$SRC" || { echo "❌ JS 语法有错，已中止发布"; exit 1; }
  echo "✅ 语法检查通过"
fi

cd "$(dirname "$DST")"
cp -a "$SRC" "$DST"

if git diff --quiet -- index.html; then
  echo "ℹ️  内容和线上一样，没什么可发的"
  exit 0
fi

git add index.html
git commit -q -m "$MSG"
git push -q origin main
echo "🚀 已推送。1～2 分钟后刷新： https://nirxzzz.github.io/typing-practice/"
