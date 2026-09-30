#!/bin/bash
# 简历编译脚本（参数化版）
#
# 用法：
#   cd resume-src && bash build.sh
#   或自定义姓名：NAME_ZH="李四" NAME_EN="Li_Si" bash build.sh
#
# 改自己的简历时只需改两处：
#   1. 下方 NAME_ZH / NAME_EN —— 输出 PDF 的文件名用
#   2. TRACKS / TRACK_LABELS —— 你的求职方向列表；
#      每个方向 <track> 对应两个源文件：<track>-en.tex（英文）与 <track>-zh.tex（中文），
#      参见 example-en.tex / example-zh.tex，复制改名即可增加方向。
#
# 产物：output/<序号>_<方向>_彩色_线上上传/ 与 ..._黑白_打印用/，每个方向中英各一份。
# 依赖：xelatex、pdfinfo（页数检查，缺了只影响显示页数，不影响编译）

set -e
cd "$(dirname "$0")"

NAME_ZH="${NAME_ZH:-张三}"          # PDF 文件名中的中文姓名
NAME_EN="${NAME_EN:-Zhang_San}"     # PDF 文件名中的英文姓名

# 求职方向列表（track 名只允许用 ASCII，与源文件名对应）
TRACKS=("example")
# 各方向的中文显示名（用于输出文件夹名，与 TRACKS 一一对应）
TRACK_LABELS=("数据分析")

OUT="output"   # 编译产物归档目录（建议加入 .gitignore）

echo "→ 生成黑白打印版源文件"
python3 make_bw.py

compile () {
  xelatex -interaction=nonstopmode -halt-on-error "$1" > /dev/null
  xelatex -interaction=nonstopmode -halt-on-error "$1" > /dev/null
}

COLOR_DIRS=()
BW_DIRS=()
for i in "${!TRACKS[@]}"; do
  track="${TRACKS[$i]}"
  label="${TRACK_LABELS[$i]}"
  n=$(printf "%02d" $((i + 1)))
  COLOR_DIRS+=("$OUT/${n}_${label}_彩色_线上上传")
  BW_DIRS+=("$OUT/${n}_${label}_黑白_打印用")

  echo "→ 编译方向「${label}」（${track}）"
  compile "${track}-zh.tex"
  compile "${track}-en.tex"
  compile "${track}-zh-bw.tex"
  compile "${track}-en-bw.tex"
done

echo "→ 按方向与颜色归档"
mkdir -p "${COLOR_DIRS[@]}" "${BW_DIRS[@]}"
for i in "${!TRACKS[@]}"; do
  track="${TRACKS[$i]}"
  label="${TRACK_LABELS[$i]}"
  cp "${track}-zh.pdf"    "${COLOR_DIRS[$i]}/${NAME_ZH}_简历_${label}_彩色.pdf"
  cp "${track}-en.pdf"    "${COLOR_DIRS[$i]}/${NAME_EN}_Resume_${track}_Color.pdf"
  cp "${track}-zh-bw.pdf" "${BW_DIRS[$i]}/${NAME_ZH}_简历_${label}_黑白.pdf"
  cp "${track}-en-bw.pdf" "${BW_DIRS[$i]}/${NAME_EN}_Resume_${track}_BW.pdf"
done

echo "→ 页数检查"
if ! command -v pdfinfo > /dev/null; then
  echo "  ! 未安装 pdfinfo，跳过页数检查（brew install poppler 可补上）"
else
  for d in "${COLOR_DIRS[@]}" "${BW_DIRS[@]}"; do
    for f in "$d"/*.pdf; do
      p=$(pdfinfo "$f" 2>/dev/null | awk '/^Pages/{print $2}')
      printf "   %-58s %s 页\n" "$(basename "$f")" "$p"
    done
  done
fi

echo "✓ 完成（$(( ${#TRACKS[@]} * 4 )) 份，已归档到 ${OUT}/）"
echo "  ⚠️ 若某份超过 1 页，先压缩该版本的条目，不要直接缩字号（ATS 可读性优先）"
