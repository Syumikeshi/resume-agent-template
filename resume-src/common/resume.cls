\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{common/resume}[2026/10/01 Modern ATS-safe resume class]

% ---------- 字体预设（类选项）----------
% 用法：\documentclass[<预设名>]{common/resume}
%   modern    默认。macOS 用 Avenir Next，其余平台自动回退 TeX Gyre Heros
%   texlive   TeX Gyre Heros（Helvetica 风无衬线）。跨平台渲染完全一致
%   times     TeX Gyre Termes（Times 风衬线，传统正式）
%   palatino  TeX Gyre Pagella（Palatino 风衬线，人文优雅）
% 三款 TeX Gyre 字体随 TeX Live 安装，无需额外装字体。
\newcommand{\resume@preset}{modern}
\DeclareOption{modern}{\renewcommand{\resume@preset}{modern}}
\DeclareOption{texlive}{\renewcommand{\resume@preset}{texlive}}
\DeclareOption{times}{\renewcommand{\resume@preset}{times}}
\DeclareOption{palatino}{\renewcommand{\resume@preset}{palatino}}
\ProcessOptions\relax

\LoadClass[10pt]{article}

\RequirePackage[a4paper,margin=0.47in,nohead]{geometry}
\RequirePackage{fontspec}
\RequirePackage{hyperref}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{xifthen}
\RequirePackage{xcolor}

\hypersetup{hidelinks}
% ---------- 西文字体 ----------
\ifthenelse{\equal{\resume@preset}{texlive}}{%
  \setmainfont{texgyreheros}[
    Extension = .otf, UprightFont = *-regular, BoldFont = *-bold,
    ItalicFont = *-italic, BoldItalicFont = *-bolditalic,
  ]%
}{%
\ifthenelse{\equal{\resume@preset}{times}}{%
  \setmainfont{texgyretermes}[
    Extension = .otf, UprightFont = *-regular, BoldFont = *-bold,
    ItalicFont = *-italic, BoldItalicFont = *-bolditalic,
  ]%
}{%
\ifthenelse{\equal{\resume@preset}{palatino}}{%
  \setmainfont{texgyrepagella}[
    Extension = .otf, UprightFont = *-regular, BoldFont = *-bold,
    ItalicFont = *-italic, BoldItalicFont = *-bolditalic,
  ]%
}{%
  % modern：平台原生优先，找不到时按文件名回退到 TeX Gyre Heros
  % （macOS 的 XeTeX 按族名找不到 TEXMF 内字体，文件名加载走 kpathsea 全平台可靠）
  \IfFontExistsTF{Avenir Next}{%
    \setmainfont{Avenir Next}[
      BoldFont = {Avenir Next Bold},
      ItalicFont = {Avenir Next Italic},
    ]%
  }{%
    \IfFontExistsTF{Helvetica Neue}{%
      \setmainfont{Helvetica Neue}%
    }{%
      \setmainfont{texgyreheros}[
        Extension = .otf, UprightFont = *-regular, BoldFont = *-bold,
        ItalicFont = *-italic, BoldItalicFont = *-bolditalic,
      ]%
    }%
  }%
}}}
\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
% Reduce awkward hyphenation at line ends (not fully disabled — keeps 1 page)
\hyphenpenalty=10000
\exhyphenpenalty=10000
\emergencystretch=3em
\setlist[itemize]{leftmargin=1.10em,itemsep=0.09em,topsep=0.11em,parsep=0pt,partopsep=0pt,label=\textbullet}

\definecolor{Accent}{HTML}{1B4F72}   % deep professional blue
\definecolor{NameColor}{HTML}{16232F}% near-black for the name
\definecolor{MutedText}{HTML}{4A4A4A}% secondary text (contact line)

% --- Section headings: bold small-caps-ish uppercase with accent rule ---
\titleformat{\section}
  {\normalsize\bfseries\color{Accent}}
  {}{0em}{}[{\vspace{-0.06em}{\color{Accent}\titlerule[0.7pt]}}]
\titlespacing*{\section}{0pt}{0.72em}{0.21em}
\newcommand{\resumeSection}[1]{\section*{#1}}

% --- Name: large, weighted, slight letter-spacing ---
\newcommand{\resumeName}[1]{\centerline{{\addfontfeature{LetterSpace=1.2}\LARGE\bfseries\color{NameColor} #1}}\vspace{0.36em}}

% --- Contact line: small, muted ---
\newcommand{\resumeContact}[1]{\centerline{\small\color{MutedText} #1}\vspace{0.55em}}

% --- Entries: bold title left, accent date right ---
\newcommand{\datedEntry}[2]{\textbf{#1}\hspace{1em}\hfill {\color{Accent}#2}\par}
\newcommand{\roleLine}[2]{\textit{#1}\hspace{1em}\hfill #2\par}
\newcommand{\resumeLink}[2][]{\ifthenelse{\isempty{#1}}{\href{#2}{#2}}{\href{#2}{#1}}}
\newcommand{\placeholder}[1]{\textcolor{gray}{\texttt{#1}}}
