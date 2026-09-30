\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{common/resume-zh}[2026/08/11 Chinese ATS-safe resume class]
\LoadClass[10pt]{article}

\RequirePackage[a4paper,margin=0.47in,nohead]{geometry}
% ctex 不强制 fontset：按平台自动选择（macOS/Windows/Linux 各有默认字体集），
% 下方再在 PingFang SC 可用时覆盖为与 macOS 原版一致的外观。
\RequirePackage{ctex}
\RequirePackage{hyperref}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{xifthen}
\RequirePackage{xcolor}

\hypersetup{hidelinks}
% Western 字体回退链：Avenir Next → Helvetica Neue → TeX Gyre Heros（TeX Live 自带）
\IfFontExistsTF{Avenir Next}{%
  \setmainfont{Avenir Next}[
    BoldFont = {Avenir Next Bold},
    ItalicFont = {Avenir Next Italic},
  ]%
}{%
  \IfFontExistsTF{Helvetica Neue}{%
    \setmainfont{Helvetica Neue}%
  }{%
    \setmainfont{TeX Gyre Heros}%
  }%
}
% CJK：有 PingFang SC（macOS）时用它，保持与原版一致；否则交给 ctex 的平台默认
\IfFontExistsTF{PingFang SC}{%
  \setCJKmainfont{PingFang SC}%
  \setCJKsansfont{PingFang SC}%
}{}
\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
% Reduce awkward hyphenation at line ends (not fully disabled — keeps 1 page)
\hyphenpenalty=10000
\exhyphenpenalty=10000
\emergencystretch=1.5em
\setlist[itemize]{leftmargin=1.10em,itemsep=0.09em,topsep=0.11em,parsep=0pt,partopsep=0pt,label=\textbullet}

\definecolor{Accent}{HTML}{1B4F72}   % deep professional blue
\definecolor{NameColor}{HTML}{16232F}% near-black for the name
\definecolor{MutedText}{HTML}{4A4A4A}% secondary text (contact line)

% --- Section headings: bold with accent rule (uppercase effect not needed for CJK) ---
\titleformat{\section}
  {\normalsize\bfseries\color{Accent}}
  {}{0em}{}[{\vspace{-0.06em}{\color{Accent}\titlerule[0.7pt]}}]
\titlespacing*{\section}{0pt}{0.72em}{0.21em}
\newcommand{\resumeSection}[1]{\section*{#1}}

% --- Name: large, weighted (no letter-spacing for CJK) ---
\newcommand{\resumeName}[1]{\centerline{{\LARGE\bfseries\color{NameColor} #1}}\vspace{0.36em}}

% --- Contact line: small, muted ---
\newcommand{\resumeContact}[1]{\centerline{\small\color{MutedText} #1}\vspace{0.55em}}

% --- Entries: bold title left, accent date right ---
\newcommand{\datedEntry}[2]{\textbf{#1}\hspace{1em}\hfill {\color{Accent}#2}\par}
\newcommand{\roleLine}[2]{\textit{#1}\hspace{1em}\hfill #2\par}
\newcommand{\resumeLink}[2][]{\ifthenelse{\isempty{#1}}{\href{#2}{#2}}{\href{#2}{#1}}}
\newcommand{\placeholder}[1]{\textcolor{gray}{\texttt{#1}}}
